# Jazz Jackrabbit: Holiday Hare 1995 - Self-Hosted Browser Game

Play the classic DOS platformer **Jazz Jackrabbit: Holiday Hare 1995** (Epic MegaGames, 1995) directly in your web browser using js-dos emulation.

## About the Game

A holiday-themed edition of the award-winning platformer designed by Cliff Bleszinski. Race through festive levels on planet Candion, blast enemies with your blaster, and enjoy the iconic rap version of Little Drummer Boy!

- **Developer:** Epic MegaGames
- **Designer:** Cliff Bleszinski
- **Year:** 1995
- **Genre:** Side-scrolling platformer

## Quick Start

### Docker
```bash
cd jazz-jackrabbit
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8082
```

### Proxmox LXC
```bash
bash lxc/proxmox-install.sh
```

## Controls

- **Arrow Keys** - Move Jazz
- **Alt** - Jump
- **Ctrl** - Shoot
- **Space** - Special weapon
- **Esc** - Menu / Pause

## Resources

- [Archive.org](https://archive.org/details/msdos_Jazz_Jackrabbit_-_Holiday_Hare_1995_1995)
- [js-dos Documentation](https://js-dos.com/v7/build/)

## License

Infrastructure code provided as-is. Jazz Jackrabbit is copyrighted by Epic Games.
