#!/bin/bash
# Update the system
dnf update -y
# Install Docker
dnf install -y docker
# Start Docker Service
service docker start
# Enable Docker to start on boot
systemctl enable docker
# Add ec2-user to docker group to run commands without sudo
usermod -a -G docker ec2-user
#install git
dnf install -y git
#clone Project(if not already exists)
if [ ! -d "/home/ec2-user/network_monitoring_project"]; then
  git clone https://github.com/SuhaniSharmaJoshi/network_monitoring_project.git
fi
#Go to app directory
cd /home/ec2-user/network_monitoring_project/app || {echo "app folder not found! Exiting"; exit 1;}
#Ensure log file exists
touch /home/ec2-user/network_monitoring_project/app/app.log
#permissions
chown -R ec2-user:ec2-user /home/ec2-user/network_monitoring_project
#build docker image
docker build -t my-flask-app .
docker run -d -p 80:5000 --name flask-app my-flask-app
#install cloud watch agent
dnf install amazon-cloudwatch-agent -y
#create cloudwatch confg
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },

  "metrics": {
    "aggregation_dimensions": [
      ["InstanceId"]
    ],
    "append_dimensions": {
      "AutoScalingGroupName": "\${aws:AutoScalingGroupName}",
      "ImageId": "\${aws:ImageId}",
      "InstanceId": "\${aws:InstanceId}",
      "InstanceType": "\${aws:InstanceType}"
    },
    "metrics_collected": {
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  },

  "logs": {
    "force_flush_interval": 5,
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/ec2/security/ssh",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/home/ec2-user/network_monitoring_project/app/app.log",
            "log_group_name": "/app/flask/logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

#start cloudwatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s
#permissions
chown -R ec2-user:ec2-user /home/ec2-user/network_monitoring_project
