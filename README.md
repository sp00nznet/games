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

---

### Destruction Derby 2

Vehicular combat racing from Reflections Interactive (1996). Smash and crash your way to victory in demolition derbies and races!

- **Location:** [`destruction-derby-2/`](./destruction-derby-2/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Destruction_Derby_2_1996)
- **Port:** 8085

---

### Jagged Alliance

Turn-based tactical strategy from Sir-tech (1994). Hire mercenaries and liberate the island of Metavira in this cult classic!

- **Location:** [`jagged-alliance/`](./jagged-alliance/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Jagged_Alliance_1994)
- **Port:** 8086

---

### Syndicate Plus

Cyberpunk tactical action from Bullfrog (1994). Control cyborg agents in a dark future. Includes American Revolt expansion.

- **Location:** [`syndicate-plus/`](./syndicate-plus/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Syndicate_Plus_1994)
- **Port:** 8087

---

### Redneck Rampage Rides Again

Build Engine FPS sequel from Xatrix (1998). More redneck mayhem in Arkansas! **Mature content (17+).**

- **Location:** [`redneck-rampage-rides-again/`](./redneck-rampage-rides-again/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Redneck_Rampage_Rides_Again_1998)
- **Port:** 8088

---

### Interstate '76

Vehicular combat set in 1970s America from Activision (1997). Funky soundtrack, muscle cars, and guns!

- **Location:** [`interstate-76/`](./interstate-76/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/interstate-76-activision-1997)
- **Port:** 8089

---

### Richard Scarry's Busytown

Educational adventure for kids based on Richard Scarry's beloved books. Explore Busytown with Huckle Cat and friends!

- **Location:** [`busytown/`](./busytown/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/busytown_dos)
- **Port:** 8090

---

### Redneck Rampage

Build Engine FPS from Xatrix/Interplay (1997). Alien invasion meets Southern hospitality! **Mature content (17+).**

- **Location:** [`redneck-rampage/`](./redneck-rampage/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Redneck_Rampage_1997)
- **Port:** 8091

---

### NAM

Build Engine FPS set in Vietnam from TNT Team (1998). Tactical warfare in the jungle. **Mature content.**

- **Location:** [`nam/`](./nam/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/nam_20210413)
- **Port:** 8092

---

### Treasure MathStorm!

Educational math adventure from The Learning Company (1992). Climb the mountain and solve math puzzles to save the kingdom!

- **Location:** [`treasure-mathstorm/`](./treasure-mathstorm/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Super_Solvers_Teasure_MathStorm_1992)
- **Port:** 8093

---

### Jazz Jackrabbit (Original)

The original 1994 platformer from Epic MegaGames. PC Format's Arcade Game of the Year! Save Princess Eva Earlong from Devan Shell.

- **Location:** [`jazz-jackrabbit-original/`](./jazz-jackrabbit-original/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/msdos_Jazz_Jackrabbit_1994)
- **Port:** 8094

---

### Storybook Weaver

Creative writing software for kids from MECC (1995). Create illustrated storybooks with backgrounds, characters, and your own text!

- **Location:** [`storybook-weaver/`](./storybook-weaver/)
- **Emulation:** js-dos (DOSBox in browser)
- **Source:** [Archive.org](https://archive.org/details/storybookweaver_1995)
- **Port:** 8095

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
