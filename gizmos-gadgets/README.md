# Gizmos & Gadgets - Self-Hosted Browser Game

Play the classic DOS educational game **Super Solvers: Gizmos & Gadgets!** (The Learning Company, 1993) directly in your web browser using js-dos emulation.

## About the Game

Race against Morty Maxwell by building vehicles at the Shady Glen Technology Center! Collect parts from warehouses by solving science puzzles about:
- Simple machines
- Magnets
- Basic electronics
- Forms of energy

Watch out for the Cyberchimps - throw bananas to stop them from stealing your parts!

## Features

- Browser-based DOS emulation via [js-dos](https://js-dos.com/)
- Containerized deployment (Docker & LXC/Proxmox)
- Responsive web interface with fullscreen support
- No client-side installation required

## Quick Start

### Option 1: Docker

```bash
# Enter directory
cd gizmos-gadgets

# Download and prepare the game
./scripts/download-game.sh

# Start with Docker Compose
docker-compose up -d

# Access at http://localhost:8081
```

### Option 2: Docker (Manual)

```bash
# Build the image
docker build -t gizmos-gadgets .

# Run the container
docker run -d -p 8081:80 \
  -v $(pwd)/game:/usr/share/nginx/html/game:ro \
  --name gizmos-gadgets \
  gizmos-gadgets

# Access at http://localhost:8081
```

### Option 3: Proxmox LXC

Run the installer script directly on your Proxmox host:

```bash
bash -c "$(wget -qLO - https://raw.githubusercontent.com/YOUR_REPO/main/gizmos-gadgets/lxc/proxmox-install.sh)"
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

1. Visit: https://archive.org/details/msdos_Super_Solvers_Gizmos_and_Gadgets_1993
2. Download the ZIP file
3. Use the provided script to create a js-dos bundle:

```bash
./scripts/download-game.sh
```

Or manually create the bundle:

1. Extract the game files
2. Create a `dosbox.conf` with autoexec commands
3. ZIP everything into `gizmos.jsdos`
4. Place in `game/` directory

## File Structure

```
gizmos-gadgets/
├── index.html              # Web interface
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose config
├── nginx.conf              # Nginx configuration
├── game/                   # Game files directory
│   └── gizmos.jsdos        # Game bundle (you provide this)
├── scripts/
│   └── download-game.sh    # Game download helper
└── lxc/
    ├── create-lxc.sh       # LXC creation script
    ├── setup-inside-lxc.sh # In-container setup
    └── proxmox-install.sh  # One-line Proxmox installer
```

## Controls

- **Arrow Keys** - Move character
- **Spacebar** - Jump / Action
- **Enter** - Confirm
- **Esc** - Menu / Pause
- **Click the game** - Capture keyboard/mouse

## Troubleshooting

### Game won't load

- Ensure `gizmos.jsdos` exists in the `game/` directory
- Check browser console for errors
- Verify the jsdos bundle structure is correct

### Performance issues

- Use a modern browser (Chrome, Firefox, Edge)
- js-dos requires significant CPU resources
- Consider allocating more CPU cores to the container

## Resources

- [Archive.org - Gizmos & Gadgets (DOS)](https://archive.org/details/msdos_Super_Solvers_Gizmos_and_Gadgets_1993)
- [Archive.org - Gizmos & Gadgets (Alt)](https://archive.org/details/gizmos__gadgets)
- [js-dos Documentation](https://js-dos.com/v7/build/)
- [DOSBox Configuration](https://www.dosbox.com/wiki/Dosbox.conf)

## License

This project provides the infrastructure to run DOS games in browsers. The game itself (Gizmos & Gadgets) is copyrighted by The Learning Company. Download from Archive.org for personal/educational use.
