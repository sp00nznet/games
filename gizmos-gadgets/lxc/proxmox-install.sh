#!/usr/bin/env bash
# Gizmos & Gadgets LXC Installation Script for Proxmox
#
# Usage: bash -c "$(wget -qLO - https://raw.githubusercontent.com/YOUR_REPO/main/gizmos-gadgets/lxc/proxmox-install.sh)"

set -euo pipefail

# Colors
RD=$(echo "\033[01;31m")
GN=$(echo "\033[1;32m")
CL=$(echo "\033[m")
BL=$(echo "\033[36m")
YW=$(echo "\033[33m")

# Default values
CTID=""
HN="gizmos-gadgets"
DISK_SIZE="2"
CORE_COUNT="1"
RAM_SIZE="512"
BRG="vmbr0"
NET="dhcp"
APP="Gizmos & Gadgets"

# Header
function header_info {
    clear
    echo -e "${GN}
   _____ _                            ___      _____           _            _
  / ____(_)                          ( _ )    / ____|         | |          | |
 | |  __ _ _____  ___   ___  ___    / _ \/\ | |  __  __ _  __| | __ _  ___| |_ ___
 | | |_ | |_  / '_ ` _ \ / _ \/ __|  | (_>  < | | |_ |/ _\` |/ _\` |/ _\` |/ _ \ __/ __|
 | |__| | |/ /| | | | | | (_) \__ \   \___/\/ | |__| | (_| | (_| | (_| |  __/ |_\__ \\
  \_____|_/___|_| |_| |_|\___/|___/          \_____|\__,_|\__,_|\__, |\___|\__|___/
                                                                  __/ |
                                                                 |___/
${CL}"
    echo -e "${BL}Self-Hosted DOS Game via js-dos${CL}"
    echo ""
}

function msg_info() { echo -e "${BL}[INFO]${CL} $1"; }
function msg_ok() { echo -e "${GN}[OK]${CL} $1"; }
function msg_error() { echo -e "${RD}[ERROR]${CL} $1"; }

function check_proxmox() {
    if ! command -v pveversion &> /dev/null; then
        msg_error "This script must be run on a Proxmox VE host"
        exit 1
    fi
    msg_ok "Proxmox VE detected"
}

function get_next_ctid() {
    local ctid=100
    while pct status $ctid &> /dev/null; do
        ((ctid++))
    done
    echo $ctid
}

function default_settings() {
    msg_info "Using default settings"
    CTID=$(get_next_ctid)
    msg_ok "Container ID: ${BL}$CTID${CL}"
    msg_ok "Hostname: ${BL}$HN${CL}"
    msg_ok "Disk Size: ${BL}${DISK_SIZE}GB${CL}"
    msg_ok "CPU Cores: ${BL}$CORE_COUNT${CL}"
    msg_ok "RAM: ${BL}${RAM_SIZE}MB${CL}"
    msg_ok "Bridge: ${BL}$BRG${CL}"
    echo ""
}

function advanced_settings() {
    read -p "Enter Container ID (default: $(get_next_ctid)): " input_ctid
    CTID=${input_ctid:-$(get_next_ctid)}
    read -p "Enter Hostname (default: $HN): " input_hn
    HN=${input_hn:-$HN}
    read -p "Enter Disk Size in GB (default: $DISK_SIZE): " input_disk
    DISK_SIZE=${input_disk:-$DISK_SIZE}
    read -p "Enter CPU Cores (default: $CORE_COUNT): " input_cores
    CORE_COUNT=${input_cores:-$CORE_COUNT}
    read -p "Enter RAM in MB (default: $RAM_SIZE): " input_ram
    RAM_SIZE=${input_ram:-$RAM_SIZE}
    read -p "Enter Network Bridge (default: $BRG): " input_brg
    BRG=${input_brg:-$BRG}
    echo ""
    msg_ok "Configuration complete"
}

function download_template() {
    local template="debian-12-standard_12.2-1_amd64.tar.zst"
    local template_path="/var/lib/vz/template/cache/$template"
    if [ ! -f "$template_path" ]; then
        msg_info "Downloading Debian 12 template..."
        pveam update &>/dev/null
        pveam download local $template &>/dev/null
        msg_ok "Template downloaded"
    else
        msg_ok "Template already exists"
    fi
    echo "$template_path"
}

function create_container() {
    local template_path="$1"
    msg_info "Creating LXC container..."
    pct create $CTID "$template_path" \
        --hostname $HN \
        --rootfs local-lvm:${DISK_SIZE} \
        --memory $RAM_SIZE \
        --cores $CORE_COUNT \
        --net0 name=eth0,bridge=$BRG,ip=$NET \
        --unprivileged 1 \
        --features nesting=1 \
        --onboot 1 \
        --start 0 &>/dev/null
    msg_ok "Container $CTID created"
}

function setup_container() {
    msg_info "Starting container..."
    pct start $CTID
    sleep 5

    msg_info "Installing packages inside container..."
    pct exec $CTID -- bash -c "apt-get update && apt-get install -y nginx curl unzip wget" &>/dev/null

    msg_info "Configuring web server..."
    pct exec $CTID -- mkdir -p /var/www/gizmos-gadgets/game

    pct exec $CTID -- bash -c 'cat > /var/www/gizmos-gadgets/index.html << '\''HTMLEOF'\''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gizmos & Gadgets</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}body{background:#1a1a2e;color:#eee;font-family:sans-serif;min-height:100vh;display:flex;flex-direction:column;align-items:center}header{text-align:center;padding:20px;background:linear-gradient(135deg,#1e3a1e,#2d5a2d);width:100%}h1{color:#7fff7f;text-shadow:0 0 10px rgba(127,255,127,.5)}main{flex:1;display:flex;flex-direction:column;align-items:center;padding:20px;width:100%;max-width:1000px}#dos-container{width:100%;max-width:800px;aspect-ratio:4/3;background:#000;border:3px solid #2d5a2d;border-radius:8px}#dos{width:100%;height:100%}.controls{margin-top:20px;display:flex;gap:10px}button{background:linear-gradient(135deg,#2d5a2d,#1e3a1e);color:#7fff7f;border:2px solid #7fff7f;padding:10px 20px;border-radius:5px;cursor:pointer}button:hover{background:#7fff7f;color:#1a1a2e}.loading{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:#7fff7f}
    </style>
</head>
<body>
    <header><h1>Gizmos & Gadgets!</h1><p style="color:#aaa">Super Solvers Educational Game</p></header>
    <main>
        <div id="dos-container"><div id="dos"><div class="loading"><p>Loading...</p></div></div></div>
        <div class="controls"><button onclick="document.getElementById('\''dos-container'\'').requestFullscreen()">Fullscreen</button><button onclick="location.reload()">Restart</button></div>
    </main>
    <script src="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.js"></script>
    <link rel="stylesheet" href="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.css">
    <script>Dos(document.getElementById("dos"),{url:"game/gizmos.jsdos",autoStart:true}).catch(()=>{document.getElementById("dos").innerHTML="<div class=\"loading\"><p style=\"color:#f66\">Game not found. Add gizmos.jsdos to /var/www/gizmos-gadgets/game/</p></div>"});</script>
</body>
</html>
HTMLEOF'

    pct exec $CTID -- bash -c 'cat > /etc/nginx/sites-available/gizmos-gadgets << '\''NGINXEOF'\''
server {
    listen 80 default_server;
    root /var/www/gizmos-gadgets;
    index index.html;
    gzip on;
    gzip_types text/plain text/css application/json application/javascript application/wasm;
    location /game/ { add_header Access-Control-Allow-Origin *; }
    location / { try_files $uri $uri/ /index.html; }
}
NGINXEOF'

    pct exec $CTID -- rm -f /etc/nginx/sites-enabled/default
    pct exec $CTID -- ln -sf /etc/nginx/sites-available/gizmos-gadgets /etc/nginx/sites-enabled/
    pct exec $CTID -- systemctl enable nginx
    pct exec $CTID -- systemctl restart nginx

    msg_ok "Web server configured"
}

# Main
header_info
check_proxmox

echo -e "${YW}Configuration Options:${CL}"
echo "1) Use default settings"
echo "2) Advanced configuration"
echo ""
read -p "Select option [1-2]: " config_option

case $config_option in
    2) advanced_settings ;;
    *) default_settings ;;
esac

echo ""
read -p "Create container with these settings? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

template_path=$(download_template)
create_container "$template_path"
setup_container

sleep 3
IP=$(pct exec $CTID -- hostname -I 2>/dev/null | awk '{print $1}')

echo ""
echo -e "${GN}===========================================${CL}"
echo -e "${GN}  Gizmos & Gadgets Installation Complete!  ${CL}"
echo -e "${GN}===========================================${CL}"
echo ""
echo -e "Container ID: ${BL}$CTID${CL}"
echo -e "IP Address:   ${BL}${IP:-'DHCP - check container'}${CL}"
echo ""
echo -e "${YW}Next Steps:${CL}"
echo "1. Download the game from Archive.org:"
echo "   https://archive.org/details/msdos_Super_Solvers_Gizmos_and_Gadgets_1993"
echo ""
echo "2. Create jsdos bundle and copy to container:"
echo "   pct push $CTID gizmos.jsdos /var/www/gizmos-gadgets/game/gizmos.jsdos"
echo ""
echo "3. Access the game at:"
echo -e "   ${BL}http://${IP:-'<container-ip>'}${CL}"
echo ""
