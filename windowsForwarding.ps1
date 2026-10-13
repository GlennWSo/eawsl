# =========================================================================
# AUTOMATED WSL NAT PORT FORWARDING SCRIPT
# =========================================================================
# INSTRUCTIONS: Run this script inside Windows PowerShell as an Administrator.

# 1. Define the port you configured for Vector inside NixOS
$Port = 6767

Write-Host "[+] Resolving dynamic guest networking boundaries..." -ForegroundColor Cyan

# 2. Automatically fetch the current internal NAT IP of your NixOS instance
$WslIp = (wsl -d NixOS hostname -I).Trim().Split(" ")[0]

if ([string]::IsNullOrEmpty($WslIp)) {
    Write-Error "[-] Critical Error: Unable to locate an active IP address for your NixOS WSL distribution."
    exit
}

Write-Host "[+] Active NixOS WSL IP Discovered: $WslIp" -ForegroundColor Green

# 3. Flush out any old, broken proxy rules mapped to this specific port
Write-Host "[+] Purging stale network mapping rules for port $Port..." -ForegroundColor Yellow
netsh interface portproxy delete v4tov4 listenport=$Port listenaddress=0.0.0.0 | Out-Null

# 4. Bind the fresh network connection rule (Windows Host -> NixOS Guest Subnet)
Write-Host "[+] Creating proxy bridge: Windows Host Port $Port ===> NixOS IP $WslIp..." -ForegroundColor Cyan
netsh interface portproxy add v4tov4 listenport=$Port listenaddress=0.0.0.0 connectport=$Port connectaddress=$WslIp

# 5. Open up the Windows Defender Firewall rule so other LAN machines can connect
Write-Host "[+] Configuring Windows Defender Firewall authorization rules..." -ForegroundColor Cyan
Remove-NetFirewallRule -DisplayName "WSL Vector Logging Incoming" -ErrorAction SilentlyContinue | Out-Null
New-NetFirewallRule -DisplayName "WSL Vector Logging Incoming" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port | Out-Null

Write-Host "`n[====== SUCCESS ======]" -ForegroundColor Green
Write-Host "External network traffic hitting port $Port is now routed safely down to NixOS!" -ForegroundColor Green
Write-Host "Test this from another machine using: curl -X POST http://YOUR_WINDOWS_IP:$Port/ -d 'test'" -ForegroundColor White

