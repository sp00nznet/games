# Epic Pinball - Self-Hosted Browser Game

Play the classic DOS pinball game **Epic Pinball** (Digital Extremes/Epic MegaGames, 1993) directly in your web browser using js-dos emulation.

## About the Game

The third best-selling shareware game of all time! Created by James Schmalz and programmed entirely in x86 assembly language. Revenue from this game helped fund the development of Unreal Engine.

- **Developer:** Digital Extremes / James Schmalz
- **Publisher:** Epic MegaGames
- **Year:** 1993
- **Genre:** Pinball simulation

## Quick Start

### Docker
```bash
cd epic-pinball
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8083
```

### Proxmox LXC
```bash
bash lxc/proxmox-install.sh
```

## Controls

- **Left Shift / Z** - Left flipper
- **Right Shift / /** - Right flipper
- **Space / Down Arrow** - Launch ball / Plunger
- **X** - Nudge table left
- **.** - Nudge table right
- **Esc** - Menu

## Resources

- [Archive.org](https://archive.org/details/epicpin_202406)
- [js-dos Documentation](https://js-dos.com/v7/build/)

## License

Infrastructure code provided as-is. Epic Pinball is copyrighted by Epic Games.
