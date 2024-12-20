#!usr/bin/env bash

echo "Setting password policy, please ensure you are logged in as root."
read -p "Press Enter to continue..."

apt install -y libpam-pwquality #-y: will say yes and install automatically without prompting

#login.defs settings
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   60/' /etc/login.defs #^ means find line that starts with the following phrase
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs #.* means replace the entire line (* represents all the following characters)
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs #phrase between /   / is the new line
sed -i 's/^LOGIN_RETRIES.*/LOGIN_RETRIES   3/' /etc/login.defs
sed -i 's/^LOGIN_TIMEOUT.*/LOGIN_TIMEOUT   60/' /etc/login.defs

#pam.d settings
sed -i 's/^password.*pam_pwquality.so.*/password  requisite  pam_pwquality.so retry=3 minlen=10 difok=3 ucredit=-1 lcredit=-1 ocredit=-1 dcredit=-1/' /etc/pam.d/common-password

# Ensure pam_unix.so is correctly configured 
sed -i 's/^\(password.*pam_unix.so.*\)/\1 obscure use_authtok try_first_pass yescrypt remember=5/' /etc/pam.d/common-password
# back up version sed -i 's/[success.*/[success=1, default=ignore]    pam_unix.so obscure use_authtok try_first_pass yescrypt remember=5/' /etc/pam.d/common-password

# Confirmation message
echo "Password policy has been updated. Please test to ensure it works as expected."
