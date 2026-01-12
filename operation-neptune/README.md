# Operation Neptune - Self-Hosted Browser Game

Play the classic DOS educational game **Operation Neptune** (Super Solvers series by The Learning Company, 1991) directly in your web browser using js-dos emulation.

## Features

- Browser-based DOS emulation via [js-dos](https://js-dos.com/)
- Containerized deployment (Docker & LXC/Proxmox)
- Responsive web interface with fullscreen support
- No client-side installation required

## Quick Start

### Option 1: Docker

```bash
# Clone and enter directory
cd operation-neptune

# Download and prepare the game
./scripts/download-game.sh

# Start with Docker Compose
docker-compose up -d

# Access at http://localhost:8080
```

### Option 2: Docker (Manual)

```bash
# Build the image
docker build -t operation-neptune .

# Run the container
docker run -d -p 8080:80 \
  -v $(pwd)/game:/usr/share/nginx/html/game:ro \
  --name operation-neptune \
  operation-neptune

# Access at http://localhost:8080
```

### Option 3: Proxmox LXC

Run the installer script directly on your Proxmox host:

```bash
bash -c "$(wget -qLO - https://raw.githubusercontent.com/YOUR_REPO/main/lxc/proxmox-install.sh)"
```

Or manually:

```bash
# On Proxmox host - create container
./lxc/create-lxc.sh

# Inside the container - run setup
./lxc/setup-inside-lxc.sh
```

## Getting the Game Files

The game must be downloaded separately from Archive.org due to licensing:

1. Visit: https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990
2. Download the ZIP file
3. Use the provided script to create a js-dos bundle:

```bash
./scripts/download-game.sh
```

Or manually create the bundle:

1. Extract the game files
2. Create a `dosbox.conf` with autoexec commands
3. ZIP everything into `neptune.jsdos`
4. Place in `game/` directory

### Manual jsdos Bundle Creation

```bash
# Create directory structure
mkdir -p bundle/.jsdos
cd bundle

# Copy game files
cp -r /path/to/neptune/* .

# Create dosbox config
cat > .jsdos/dosbox.conf << 'EOF'
[autoexec]
mount c .
c:
neptune.exe
EOF

# Create the bundle
zip -r ../neptune.jsdos .
```

## File Structure

```
operation-neptune/
├── index.html              # Web interface
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose config
├── nginx.conf              # Nginx configuration
├── game/                   # Game files directory
│   └── neptune.jsdos       # Game bundle (you provide this)
├── scripts/
│   └── download-game.sh    # Game download helper
└── lxc/
    ├── create-lxc.sh       # LXC creation script
    ├── setup-inside-lxc.sh # In-container setup
    └── proxmox-install.sh  # One-line Proxmox installer
```

## Configuration

### Docker Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Host port mapping |

### LXC Configuration

Edit `lxc/create-lxc.sh` to customize:

| Variable | Default | Description |
|----------|---------|-------------|
| `CTID` | `200` | Container ID |
| `HOSTNAME` | `operation-neptune` | Container hostname |
| `MEMORY` | `512` | RAM in MB |
| `CORES` | `1` | CPU cores |
| `DISK` | `2` | Disk size in GB |
| `BRIDGE` | `vmbr0` | Network bridge |

## Controls

- **Arrow Keys** - Move submarine
- **Spacebar** - Select/Confirm
- **Enter** - Confirm
- **Esc** - Menu/Cancel
- **Click the game** - Capture keyboard/mouse

## Troubleshooting

### Game won't load

- Ensure `neptune.jsdos` exists in the `game/` directory
- Check browser console for errors
- Verify the jsdos bundle structure is correct

### Performance issues

- Use a modern browser (Chrome, Firefox, Edge)
- js-dos requires significant CPU resources
- Consider allocating more CPU cores to the container

### No sound

- Click on the game window to ensure it has focus
- Check your browser's audio permissions
- Sound Blaster emulation is configured by default

## Resources

- [Archive.org - Operation Neptune](https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990)
- [js-dos Documentation](https://js-dos.com/v7/build/)
- [DOSBox Configuration](https://www.dosbox.com/wiki/Dosbox.conf)

## License

This project provides the infrastructure to run DOS games in browsers. The game itself (Operation Neptune) is copyrighted by The Learning Company. Download from Archive.org for personal/educational use.
