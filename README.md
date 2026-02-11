📊 Logging layers (this is core DevOps knowledge)
Layer	                 Command
Application logs	    - docker logs <id>
Container engine logs	- journalctl -u docker
System logs	            - journalctl
SSH logs	            - journalctl -u sshd
Boot logs 	            - journalctl -b