#!/usr/bin/env bash
# Operation Neptune LXC Installation Script for Proxmox
# Based on community helper script patterns
#
# Usage: bash -c "$(wget -qLO - https://raw.githubusercontent.com/YOUR_REPO/main/lxc/proxmox-install.sh)"

set -euo pipefail

# Colors
RD=$(echo "\033[01;31m")
GN=$(echo "\033[1;32m")
CL=$(echo "\033[m")
BL=$(echo "\033[36m")
YW=$(echo "\033[33m")

# Default values
CTID=""
HN="operation-neptune"
DISK_SIZE="2"
CORE_COUNT="1"
RAM_SIZE="512"
BRG="vmbr0"
NET="dhcp"
GATE=""
DISABLEIP6="no"
MTU=""
SD=""
NS=""
MAC=""
VLAN=""
SSH="no"
VERB="no"
APP="Operation Neptune"
var_os="debian"
var_version="12"

# Header
function header_info {
    clear
    echo -e "${BL}
   ____                       __  _                _   __           __
  / __ \____  ___  _________ _/ /_(_)___  ____     / | / /__  ____  / /___  ______  ___
 / / / / __ \/ _ \/ ___/ __ \`/ __/ / __ \/ __ \   /  |/ / _ \/ __ \/ __/ / / / __ \/ _ \\
/ /_/ / /_/ /  __/ /  / /_/ / /_/ / /_/ / / / /  / /|  /  __/ /_/ / /_/ /_/ / / / /  __/
\____/ .___/\___/_/   \__,_/\__/_/\____/_/ /_/  /_/ |_/\___/ .___/\__/\__,_/_/ /_/\___/
    /_/                                                   /_/
${CL}"
    echo -e "${GN}Self-Hosted DOS Game via js-dos${CL}"
    echo ""
}

function msg_info() {
    local msg="$1"
    echo -e "${BL}[INFO]${CL} ${msg}"
}

function msg_ok() {
    local msg="$1"
    echo -e "${GN}[OK]${CL} ${msg}"
}

function msg_error() {
    local msg="$1"
    echo -e "${RD}[ERROR]${CL} ${msg}"
}

# Check if running on Proxmox
function check_proxmox() {
    if ! command -v pveversion &> /dev/null; then
        msg_error "This script must be run on a Proxmox VE host"
        exit 1
    fi
    msg_ok "Proxmox VE detected"
}

# Get next available CTID
function get_next_ctid() {
    local ctid=100
    while pct status $ctid &> /dev/null; do
        ((ctid++))
    done
    echo $ctid
}

# Configuration prompts
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

# Download template
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

# Create container
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

# Setup container internals
function setup_container() {
    msg_info "Starting container..."
    pct start $CTID
    sleep 5

    msg_info "Installing packages inside container..."
    pct exec $CTID -- bash -c "apt-get update && apt-get install -y nginx curl unzip wget" &>/dev/null

    msg_info "Configuring web server..."

    # Create web directory
    pct exec $CTID -- mkdir -p /var/www/operation-neptune/game

    # Copy the index.html content
    pct exec $CTID -- bash -c 'cat > /var/www/operation-neptune/index.html << '\''HTMLEOF'\''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operation Neptune</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}body{background:#1a1a2e;color:#eee;font-family:sans-serif;min-height:100vh;display:flex;flex-direction:column;align-items:center}header{text-align:center;padding:20px;background:linear-gradient(135deg,#16213e,#0f3460);width:100%}h1{color:#00d9ff;text-shadow:0 0 10px rgba(0,217,255,.5)}main{flex:1;display:flex;flex-direction:column;align-items:center;padding:20px;width:100%;max-width:1000px}#dos-container{width:100%;max-width:800px;aspect-ratio:4/3;background:#000;border:3px solid #0f3460;border-radius:8px}#dos{width:100%;height:100%}.controls{margin-top:20px;display:flex;gap:10px}button{background:linear-gradient(135deg,#0f3460,#16213e);color:#00d9ff;border:2px solid #00d9ff;padding:10px 20px;border-radius:5px;cursor:pointer}button:hover{background:#00d9ff;color:#1a1a2e}.loading{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:#00d9ff}
    </style>
</head>
<body>
    <header><h1>Operation Neptune</h1><p style="color:#aaa">Super Solvers Educational Game</p></header>
    <main>
        <div id="dos-container"><div id="dos"><div class="loading"><p>Loading...</p></div></div></div>
        <div class="controls"><button onclick="document.getElementById('\''dos-container'\'').requestFullscreen()">Fullscreen</button><button onclick="location.reload()">Restart</button></div>
    </main>
    <script src="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.js"></script>
    <link rel="stylesheet" href="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.css">
    <script>Dos(document.getElementById("dos"),{url:"game/neptune.jsdos",autoStart:true}).catch(()=>{document.getElementById("dos").innerHTML="<div class=\"loading\"><p style=\"color:#f66\">Game not found. Add neptune.jsdos to /var/www/operation-neptune/game/</p></div>"});</script>
</body>
</html>
HTMLEOF'

    # Configure nginx
    pct exec $CTID -- bash -c 'cat > /etc/nginx/sites-available/operation-neptune << '\''NGINXEOF'\''
server {
    listen 80 default_server;
    root /var/www/operation-neptune;
    index index.html;
    gzip on;
    gzip_types text/plain text/css application/json application/javascript application/wasm;
    location /game/ { add_header Access-Control-Allow-Origin *; }
    location / { try_files $uri $uri/ /index.html; }
}
NGINXEOF'

    pct exec $CTID -- rm -f /etc/nginx/sites-enabled/default
    pct exec $CTID -- ln -sf /etc/nginx/sites-available/operation-neptune /etc/nginx/sites-enabled/
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

# Confirm
echo ""
read -p "Create container with these settings? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Execute
template_path=$(download_template)
create_container "$template_path"
setup_container

# Get IP
sleep 3
IP=$(pct exec $CTID -- hostname -I 2>/dev/null | awk '{print $1}')

echo ""
echo -e "${GN}============================================${CL}"
echo -e "${GN}  Operation Neptune Installation Complete!  ${CL}"
echo -e "${GN}============================================${CL}"
echo ""
echo -e "Container ID: ${BL}$CTID${CL}"
echo -e "IP Address:   ${BL}${IP:-'DHCP - check container'}${CL}"
echo ""
echo -e "${YW}Next Steps:${CL}"
echo "1. Download the game from Archive.org:"
echo "   https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990"
echo ""
echo "2. Create jsdos bundle and copy to container:"
echo "   pct push $CTID neptune.jsdos /var/www/operation-neptune/game/neptune.jsdos"
echo ""
echo "3. Access the game at:"
echo -e "   ${BL}http://${IP:-'<container-ip>'}${CL}"
echo ""
