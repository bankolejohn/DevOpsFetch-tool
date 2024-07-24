
Creating a Logrotate Configuration File for devopsfetch

logrotate is a utility designed to manage the automatic rotation and compression of log files. To ensure the logs generated by devopsfetch are managed properly, we will create a logrotate configuration file.

Steps to Create and Configure Logrotate for devopsfetch

Create the Logrotate Configuration File:

Open a terminal window.
Create a new file named devopsfetch in the /etc/logrotate.d/ directory using a text editor (e.g., nano, vi).
bash
Copy code
sudo nano /etc/logrotate.d/devopsfetch
Add Configuration Directives:

Add the following content to the devopsfetch file. This configuration tells logrotate how to handle the /var/log/devopsfetch.log file.

```
/var/log/devopsfetch.log {
    daily                # Rotate the log file daily
    rotate 7             # Keep 7 days' worth of backlogs
    compress             # Compress the rotated log files
    missingok            # Do not issue an error if the log file is missing
    notifempty           # Do not rotate the log if it is empty
    create 0640 root adm # Create a new log file with specified permissions
}
```


Here is an explanation of each directive:

daily: Rotate the log file daily.
rotate 7: Keep 7 rotated log files before deleting old ones.
compress: Compress the rotated log files to save space.
missingok: If the log file is missing, do not issue an error.
notifempty: Do not rotate the log file if it is empty.
create 0640 root adm: Create a new log file after rotation with permissions set to 0640, owned by root and group adm.
Save and Close the File:

Save the changes and close the text editor (in nano, press Ctrl+X, then Y, and Enter).
Verify Logrotate Configuration
To ensure the logrotate configuration for devopsfetch is working correctly, you can force logrotate to run and check the results:

Run Logrotate Manually:

bash
Copy code
sudo logrotate -f /etc/logrotate.d/devopsfetch
This command forces logrotate to process the devopsfetch configuration file immediately.

Check the Logs Directory:

After running logrotate, check the /var/log directory to see the rotated log files. You should see compressed log files like devopsfetch.log.1.gz, devopsfetch.log.2.gz, etc.

```bash
ls -l /var/log/devopsfetch*
```

Managing Logs

View the Latest Log File:

```bash
sudo tail -f /var/log/devopsfetch.log
```

View Older Rotated Logs:

Rotated logs are compressed with .gz extension. Use zcat or zless to view them.

```bash
sudo zcat /var/log/devopsfetch.log.1.gz
```

Configure Systemd Service for Continuous Logging:

Ensure the devopsfetch.sh script logs output to /var/log/devopsfetch.log by modifying the script:

```bash
#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"

# Redirect output to log file
exec >> "$LOG_FILE" 2>&1
```

With these steps, you will have set up a robust logging mechanism for the devopsfetch script, ensuring logs are rotated and managed efficiently, preventing disk space issues and keeping log data organized.












# Flask Web App Tutorial

## Setup & Installation

Make sure you have the latest version of Python installed.

```bash
git clone <repo-url>
```

```bash
pip install -r requirements.txt
```

## Running The App

```bash
python main.py
```

## Viewing The App

Go to `http://127.0.0.1:5000`
