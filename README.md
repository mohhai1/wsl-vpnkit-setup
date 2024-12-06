# Resolving WSL2 Internet Connectivity Issues When Using a VPN on Windows

## Problem Statement

When connecting to a VPN from a Windows PC, users may experience loss of internet connectivity within their WSL2 (Windows Subsystem for Linux 2) Ubuntu distribution. This issue arises because the VPN client routes all traffic through the VPN, causing WSL2 to lose its internet connection.

## Solution

To resolve this issue, we can use `wsl-vpnkit`, a tool that helps WSL2 work seamlessly with VPNs. Below are the steps to set up `wsl-vpnkit` to restore internet connectivity in WSL2 while connected to a VPN.

### Steps to Set Up `wsl-vpnkit`

1. **Download and Extract `wsl-vpnkit`**:
   ```bash
   wget -cO wsl-vpnkit.tar.gz "https://github.com/sakai135/wsl-vpnkit/releases/download/v0.4.1/wsl-vpnkit.tar.gz"
   sudo mkdir -p /opt/wsl-vpnkit
   sudo tar --directory /opt/wsl-vpnkit --strip-components=1 -xf wsl-vpnkit.tar.gz
   sudo rm wsl-vpnkit.tar.gz
Create the wsl-interop-env.sh Script:

sudo nano /etc/systemd/system/wsl-interop-env.sh
Add the following content:

#!/bin/sh
export WSL_INTEROP=
for socket in $(ls /run/WSL | sort -n); do
    if ss -elx | grep "$socket"; then
        export WSL_INTEROP=/run/WSL/$socket
    else
        rm $socket
    fi
done
Make the Script Executable:

sudo chmod +x /etc/systemd/system/wsl-interop-env.sh
Create the wsl-vpnkit.service File:

sudo nano /etc/systemd/system/wsl-vpnkit.service
Add the following content:

[Unit]
Description=wsl-vpnkit
After=network.target

[Service]
Type=idle
ExecStart=/bin/sh -c '. /etc/systemd/system/wsl-interop-env.sh; /opt/wsl-vpnkit/wsl-vpnkit'
Environment=VMEXEC_PATH=/opt/wsl-vpnkit/wsl-vm
Environment=GVPROXY_PATH=/opt/wsl-vpnkit/wsl-gvproxy.exe
Restart=always
KillMode=mixed

[Install]
WantedBy=multi-user.target
Enable and Start the Service:

sudo systemctl enable wsl-vpnkit
sudo systemctl start wsl-vpnkit
Conclusion
By following these steps, you can restore internet connectivity in your WSL2 environment while connected to a VPN on Windows. This solution leverages wsl-vpnkit to ensure seamless network integration between WSL2 and your VPN.