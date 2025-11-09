#!/bin/bash
# SCRIPT 1: Secure User Creation

set -e
NEW_USER="prod-dokploy"
DEFAULT_USER="ubuntu"

if [ "$(whoami)" != "$DEFAULT_USER" ]; then
  echo "ERROR: This script must be run by the user '$DEFAULT_USER'."
  exit 1
fi

echo "--- Creating new user: $NEW_USER ---"
sudo adduser $NEW_USER

echo "--- Granting sudo privileges to $NEW_USER ---"
sudo usermod -aG sudo $NEW_USER
echo "✅ Sudo privileges granted."

echo "--- Copying SSH key from '$DEFAULT_USER' to '$NEW_USER' ---"
sudo rsync --archive --chown=$NEW_USER:$NEW_USER /home/$DEFAULT_USER/.ssh /home/$NEW_USER/
echo "✅ SSH key copied successfully."

echo ""
echo "------------------------------------------------------------------"
echo "✅ User '$NEW_USER' has been created successfully."
echo "ACTION REQUIRED:"
echo "1. Disconnect from this session ('exit')."
echo "2. Reconnect to the server using the new user: ssh $NEW_USER@<your_ip>"
echo "3. Once you are logged in as '$NEW_USER', run the main setup script (main_setup.sh)."
echo "------------------------------------------------------------------"