# Carmageddon Max Pack - Self-Hosted Browser Game

Play the classic vehicular combat game **Carmageddon Max Pack** (Stainless Games, 1998) directly in your web browser using js-dos emulation.

## About the Game

The original freeform driving sensation! Winner of PC Zone's "Game of the Year" 1997. Features anarchic sandbox gameplay and over-the-top action. Includes the original game plus the Splat Pack expansion.

- **Developer:** Stainless Games
- **Publisher:** SCi Games
- **Year:** 1998
- **Genre:** Vehicular combat / Racing
- **Rating:** Mature (18+)

## Quick Start

### Docker
```bash
cd carmageddon
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8084
```

### Proxmox LXC
```bash
bash lxc/proxmox-install.sh
```

## Controls

- **Arrow Keys** - Accelerate / Brake / Steer
- **Space** - Handbrake
- **Enter** - Recover vehicle
- **Tab** - Rear view
- **Insert** - Horn
- **Esc** - Menu / Pause

## Note

This game contains mature content and was rated 18+ upon release. Player discretion advised.

## Resources

- [Archive.org](https://archive.org/details/msdos_Carmageddon_Max_Pack_1998)
- [GOG.com](https://www.gog.com/en/game/carmageddon_max_pack)
- [Steam](https://store.steampowered.com/app/282010/Carmageddon_Max_Pack/)

## License

Infrastructure code provided as-is. Carmageddon is copyrighted by Stainless Games.
