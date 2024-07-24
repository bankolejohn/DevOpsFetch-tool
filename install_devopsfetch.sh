#!/bin/bash

# Install necessary dependencies
sudo apt update
sudo apt install -y net-tools docker.io nginx

# Place devopsfetch.sh in /usr/local/bin
sudo cp devopsfetch.sh /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch

# Create a log file
sudo touch /var/log/devopsfetch.log
sudo chown syslog:adm /var/log/devopsfetch.log
sudo chmod 664 /var/log/devopsfetch.log

# Create a systemd service
sudo bash -c 'cat << EOF > /etc/systemd/system/devopsfetch.service
[Unit]
Description=Devopsfetch Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch
StandardOutput=append:/var/log/devopsfetch.log
StandardError=append:/var/log/devopsfetch.log
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

# Create a logrotate configuration for devopsfetch logs
sudo bash -c 'cat << EOF > /etc/logrotate.d/devopsfetch
/var/log/devopsfetch.log {
    su root adm
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root adm
}
EOF'

echo "Installation complete. Devopsfetch service is now running."




