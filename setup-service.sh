#!/bin/bash

# Script to install and enable the Swadiq Schools service

# Copy service file to systemd directory
sudo cp swadiq-app.service /etc/systemd/system/

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable swadiq-app.service

# Start the service
sudo systemctl start swadiq-app.service

echo "Swadiq Schools service installed and enabled!"
echo "The application will now automatically start on system boot."
echo "You can check the status with: sudo systemctl status swadiq-app.service"