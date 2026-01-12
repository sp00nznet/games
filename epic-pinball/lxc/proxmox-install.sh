#!/usr/bin/env bash
# Epic Pinball LXC Installation Script for Proxmox
set -euo pipefail

RD=$(echo "\033[01;31m"); GN=$(echo "\033[1;32m"); CL=$(echo "\033[m"); BL=$(echo "\033[36m"); YW=$(echo "\033[33m")

CTID=""; HN="epic-pinball"; DISK_SIZE="2"; CORE_COUNT="1"; RAM_SIZE="512"; BRG="vmbr0"; NET="dhcp"

function header_info { clear; echo -e "${YW}
  _____ ____  ___ ____   ____  ___ _   _ ____    _    _     _
 | ____|  _ \|_ _/ ___| |  _ \|_ _| \ | | __ )  / \  | |   | |
 |  _| | |_) || | |     | |_) || ||  \| |  _ \ / _ \ | |   | |
 | |___|  __/ | | |___  |  __/ | || |\  | |_) / ___ \| |___| |___
 |_____|_|   |___\____| |_|   |___|_| \_|____/_/   \_\_____|_____|
${CL}"; }

function msg_info() { echo -e "${BL}[INFO]${CL} $1"; }
function msg_ok() { echo -e "${GN}[OK]${CL} $1"; }

function check_proxmox() { command -v pveversion &>/dev/null || { echo "Must run on Proxmox"; exit 1; }; msg_ok "Proxmox detected"; }
function get_next_ctid() { local ctid=100; while pct status $ctid &>/dev/null; do ((ctid++)); done; echo $ctid; }

function default_settings() {
    CTID=$(get_next_ctid)
    msg_ok "Container ID: ${BL}$CTID${CL}, Hostname: ${BL}$HN${CL}, RAM: ${BL}${RAM_SIZE}MB${CL}"
}

function download_template() {
    local template="debian-12-standard_12.2-1_amd64.tar.zst"
    local template_path="/var/lib/vz/template/cache/$template"
    [ ! -f "$template_path" ] && { msg_info "Downloading template..."; pveam update &>/dev/null; pveam download local $template &>/dev/null; }
    echo "$template_path"
}

function create_container() {
    msg_info "Creating LXC container..."
    pct create $CTID "$1" --hostname $HN --rootfs local-lvm:${DISK_SIZE} --memory $RAM_SIZE --cores $CORE_COUNT \
        --net0 name=eth0,bridge=$BRG,ip=$NET --unprivileged 1 --features nesting=1 --onboot 1 --start 0 &>/dev/null
    msg_ok "Container $CTID created"
}

function setup_container() {
    msg_info "Starting and configuring container..."
    pct start $CTID; sleep 5
    pct exec $CTID -- bash -c "apt-get update && apt-get install -y nginx curl unzip" &>/dev/null
    pct exec $CTID -- mkdir -p /var/www/epic-pinball/game

    pct exec $CTID -- bash -c 'cat > /var/www/epic-pinball/index.html << '\''EOF'\''
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Epic Pinball</title>
<style>*{margin:0;padding:0;box-sizing:border-box}body{background:#1a1a2e;color:#eee;font-family:sans-serif;min-height:100vh;display:flex;flex-direction:column;align-items:center}header{padding:20px;background:linear-gradient(135deg,#1a1a3a,#2a2a5a);width:100%;text-align:center}h1{color:#ffcc00}main{flex:1;padding:20px;width:100%;max-width:900px;display:flex;flex-direction:column;align-items:center}#dos-container{width:100%;max-width:800px;aspect-ratio:4/3;background:#000;border:3px solid #2a2a5a;border-radius:8px}#dos{width:100%;height:100%}.controls{margin-top:20px}button{background:#2a2a5a;color:#ffcc00;border:2px solid #ffcc00;padding:10px 20px;border-radius:5px;cursor:pointer;margin:5px}button:hover{background:#ffcc00;color:#1a1a2e}.loading{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:#ffcc00}</style>
</head><body><header><h1>Epic Pinball</h1><p style="color:#aaa">Digital Extremes / Epic MegaGames (1993)</p></header>
<main><div id="dos-container"><div id="dos"><div class="loading"><p>Loading...</p></div></div></div>
<div class="controls"><button onclick="document.getElementById('\''dos-container'\'').requestFullscreen()">Fullscreen</button><button onclick="location.reload()">Restart</button></div></main>
<script src="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.js"></script>
<link rel="stylesheet" href="https://js-dos.com/v7/build/releases/latest/js-dos/js-dos.css">
<script>Dos(document.getElementById("dos"),{url:"game/epicpin.jsdos",autoStart:true}).catch(()=>{document.getElementById("dos").innerHTML="<div class=\"loading\"><p style=\"color:#f66\">Game not found</p></div>"});</script>
</body></html>
EOF'

    pct exec $CTID -- bash -c 'cat > /etc/nginx/sites-available/epic-pinball << '\''EOF'\''
server { listen 80 default_server; root /var/www/epic-pinball; index index.html; gzip on; location /game/ { add_header Access-Control-Allow-Origin *; } location / { try_files $uri $uri/ /index.html; } }
EOF'

    pct exec $CTID -- rm -f /etc/nginx/sites-enabled/default
    pct exec $CTID -- ln -sf /etc/nginx/sites-available/epic-pinball /etc/nginx/sites-enabled/
    pct exec $CTID -- systemctl enable nginx && pct exec $CTID -- systemctl restart nginx
    msg_ok "Setup complete"
}

header_info; check_proxmox; default_settings
read -p "Create container? [y/N]: " confirm; [[ ! "$confirm" =~ ^[Yy]$ ]] && exit 0

template_path=$(download_template); create_container "$template_path"; setup_container
IP=$(pct exec $CTID -- hostname -I 2>/dev/null | awk '{print $1}')

echo -e "\n${GN}=== Epic Pinball Installation Complete ===${CL}"
echo -e "Container: ${BL}$CTID${CL} | IP: ${BL}${IP:-DHCP}${CL}"
echo -e "Copy game: pct push $CTID epicpin.jsdos /var/www/epic-pinball/game/epicpin.jsdos"
echo -e "Access: ${BL}http://${IP:-<ip>}${CL}\n"
