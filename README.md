# Self-Hosted Games

A collection of self-hosted, browser-playable classic games using web-based emulation. Deploy via Docker or LXC (Proxmox).

## Available Games

### Operation Neptune

Classic DOS educational game from The Learning Company (1991). Solve math problems while navigating an underwater submarine adventure.

- **Location:** [`operation-neptune/`](./operation-neptune/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990)
- **Port:** 8080

**Quick Start:**
```bash
cd operation-neptune
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8080
```

---

### Gizmos & Gadgets

Classic DOS educational game from The Learning Company (1993). Build vehicles and race against Morty Maxwell by solving science puzzles about machines, magnets, and electronics.

- **Location:** [`gizmos-gadgets/`](./gizmos-gadgets/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/gizmos__gadgets)
- **Port:** 8081

**Quick Start:**
```bash
cd gizmos-gadgets
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8081
```

---

### Jazz Jackrabbit: Holiday Hare 1995

Holiday-themed platformer from Epic MegaGames (1995). Designed by Cliff Bleszinski, race through festive levels on planet Candion with your blaster!

- **Location:** [`jazz-jackrabbit/`](./jazz-jackrabbit/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Jazz_Jackrabbit_-_Holiday_Hare_1995_1995)
- **Port:** 8082

**Quick Start:**
```bash
cd jazz-jackrabbit
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8082
```

---

### Epic Pinball

Classic pinball simulation from Digital Extremes (1993). Third best-selling shareware game ever - revenue helped fund Unreal Engine development!

- **Location:** [`epic-pinball/`](./epic-pinball/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/epicpin_202406)
- **Port:** 8083

**Quick Start:**
```bash
cd epic-pinball
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8083
```

---

### Carmageddon Max Pack

Vehicular combat racing from Stainless Games (1998). PC Zone's "Game of the Year" 1997. Includes original game + Splat Pack expansion. **Mature content (18+).**

- **Location:** [`carmageddon/`](./carmageddon/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Carmageddon_Max_Pack_1998)
- **Port:** 8084

**Quick Start:**
```bash
cd carmageddon
./scripts/download-game.sh
docker-compose up -d
# Access at http://localhost:8084
```

## Deployment Options

### Docker

Each game includes a `Dockerfile` and `docker-compose.yml`:

```bash
cd <game-directory>
docker-compose up -d
```

### Proxmox LXC

One-line installer scripts are provided for Proxmox:

```bash
bash -c "$(wget -qLO - <installer-url>)"
```

Or use the manual LXC scripts in each game's `lxc/` directory.

## Adding More Games

The framework supports adding more DOS games. To add a new game:

1. Create a new directory under the repo root
2. Copy the structure from `operation-neptune/`
3. Modify the HTML, configs, and scripts for the new game
4. Create the appropriate jsdos bundle

## License

Infrastructure code is provided as-is. Individual games have their own licensing - check Archive.org for terms.
