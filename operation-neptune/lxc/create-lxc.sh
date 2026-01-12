#!/bin/bash
# Create LXC container for Operation Neptune on Proxmox
# Run this script on your Proxmox host

set -e

# Configuration - modify these as needed
CTID="${CTID:-200}"
HOSTNAME="${HOSTNAME:-operation-neptune}"
STORAGE="${STORAGE:-local-lvm}"
MEMORY="${MEMORY:-512}"
CORES="${CORES:-1}"
DISK="${DISK:-2}"
BRIDGE="${BRIDGE:-vmbr0}"
TEMPLATE="${TEMPLATE:-debian-12-standard_12.2-1_amd64.tar.zst}"

echo "=== Creating Operation Neptune LXC Container ==="
echo ""
echo "Container ID: $CTID"
echo "Hostname: $HOSTNAME"
echo "Memory: ${MEMORY}MB"
echo "Cores: $CORES"
echo "Disk: ${DISK}GB"
echo ""

# Check if running on Proxmox
if ! command -v pct &> /dev/null; then
    echo "ERROR: This script must be run on a Proxmox host"
    exit 1
fi

# Check if CTID already exists
if pct status $CTID &> /dev/null; then
    echo "ERROR: Container $CTID already exists"
    exit 1
fi

# Download template if not exists
TEMPLATE_PATH="/var/lib/vz/template/cache/$TEMPLATE"
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "Downloading Debian template..."
    pveam update
    pveam download local $TEMPLATE
fi

# Create the container
echo "Creating container..."
pct create $CTID $TEMPLATE_PATH \
    --hostname $HOSTNAME \
    --storage $STORAGE \
    --rootfs ${STORAGE}:${DISK} \
    --memory $MEMORY \
    --cores $CORES \
    --net0 name=eth0,bridge=$BRIDGE,ip=dhcp \
    --unprivileged 1 \
    --features nesting=1 \
    --onboot 1 \
    --start 0

echo "Container created successfully!"
echo ""
echo "Starting container..."
pct start $CTID

# Wait for container to be ready
echo "Waiting for container to initialize..."
sleep 10

echo ""
echo "=== Container Ready ==="
echo ""
echo "To complete setup, run:"
echo "  pct exec $CTID -- bash -c 'curl -sSL https://raw.githubusercontent.com/YOUR_REPO/main/lxc/setup-inside-lxc.sh | bash'"
echo ""
echo "Or manually enter the container and run the setup script:"
echo "  pct enter $CTID"
echo "  # Then run the setup-inside-lxc.sh script"
echo ""
echo "After setup, access the game at: http://<container-ip>:80"
echo "Find IP with: pct exec $CTID -- hostname -I"
