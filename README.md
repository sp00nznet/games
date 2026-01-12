# 🎮 Self-Hosted Retro Games

> **Play classic DOS games directly in your browser!** A curated collection of 27 containerized retro games using js-dos emulation. Deploy instantly via Docker or Proxmox LXC.

[![Games](https://img.shields.io/badge/Games-27-brightgreen)]()
[![Docker](https://img.shields.io/badge/Docker-Ready-blue)]()
[![Proxmox](https://img.shields.io/badge/Proxmox-LXC-orange)]()
[![js-dos](https://img.shields.io/badge/Emulator-js--dos-purple)]()

---

## 📚 Table of Contents

- [Quick Start](#-quick-start)
- [Game Library](#-game-library)
  - [Educational](#-educational)
  - [Platformers](#-platformers)
  - [Racing](#-racing)
  - [Strategy & Tactical](#-strategy--tactical)
  - [First-Person Shooters](#-first-person-shooters)
  - [Fighting & Action](#-fighting--action)
  - [Puzzle & Simulation](#-puzzle--simulation)
- [Deployment](#-deployment)
- [Adding Games](#-adding-games)

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repo-url>
cd games

# Pick a game and run it
cd jazz-jackrabbit
./scripts/download-game.sh
docker-compose up -d

# Play at http://localhost:8082
```

---

## 🎯 Game Library

### 📖 Educational

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_Super_Solvers_Operation_Neptune_1990" width="100"> | **[Operation Neptune](./operation-neptune/)**<br>The Learning Company | 1991 | Underwater math adventure - solve problems to navigate your submarine! | `8080` |
| <img src="https://archive.org/services/img/gizmos__gadgets" width="100"> | **[Gizmos & Gadgets](./gizmos-gadgets/)**<br>The Learning Company | 1993 | Build vehicles by solving science puzzles about machines & magnets | `8081` |
| <img src="https://archive.org/services/img/msdos_Super_Solvers_Teasure_MathStorm_1992" width="100"> | **[Treasure MathStorm!](./treasure-mathstorm/)**<br>The Learning Company | 1992 | Climb the mountain solving math puzzles to save the kingdom | `8093` |
| <img src="https://archive.org/services/img/msdos_Super_Solvers_Midnight_Rescue_1989" width="100"> | **[Midnight Rescue!](./midnight-rescue/)**<br>The Learning Company | 1989 | Reading adventure - save Shady Glen School from paint robots! | `8098` |
| <img src="https://archive.org/services/img/TYPING_EGA" width="100"> | **[Mario Teaches Typing](./mario-teaches-typing/)**<br>Interplay / Nintendo | 1992 | Learn typing with Mario, Luigi & Princess Toadstool | `8101` |
| <img src="https://archive.org/services/img/busytown_dos" width="100"> | **[Richard Scarry's Busytown](./busytown/)**<br>Novotrade | 1994 | Explore Busytown with Huckle Cat and friends | `8090` |
| <img src="https://archive.org/services/img/storybookweaver_1995" width="100"> | **[Storybook Weaver](./storybook-weaver/)**<br>MECC | 1995 | Create your own illustrated storybooks | `8095` |

---

### 🏃 Platformers

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_Jazz_Jackrabbit_1994" width="100"> | **[Jazz Jackrabbit](./jazz-jackrabbit-original/)**<br>Epic MegaGames | 1994 | PC's answer to Sonic! *PC Format Arcade Game of the Year* | `8094` |
| <img src="https://archive.org/services/img/msdos_Jazz_Jackrabbit_-_Holiday_Hare_1995_1995" width="100"> | **[Jazz Jackrabbit: Holiday Hare](./jazz-jackrabbit/)**<br>Epic MegaGames | 1995 | Festive platforming on planet Candion | `8082` |
| <img src="https://archive.org/services/img/msdos_Oddworld_-_Abes_Oddysee_1997" width="100"> | **[Oddworld: Abe's Oddysee](./oddworld-abes-oddysee/)**<br>Oddworld Inhabitants | 1997 | Cinematic platformer masterpiece - escape RuptureFarms! | `8103` |

---

### 🏎️ Racing

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_Carmageddon_Max_Pack_1998" width="100"> | **[Carmageddon Max Pack](./carmageddon/)**<br>Stainless Games | 1998 | Vehicular mayhem! *PC Zone GOTY 1997* ⚠️ 18+ | `8084` |
| <img src="https://archive.org/services/img/msdos_Destruction_Derby_2_1996" width="100"> | **[Destruction Derby 2](./destruction-derby-2/)**<br>Reflections Interactive | 1996 | Smash and crash your way to victory! | `8085` |
| <img src="https://archive.org/services/img/interstate-76-activision-1997" width="100"> | **[Interstate '76](./interstate-76/)**<br>Activision | 1997 | 70s muscle cars with guns & funky soundtrack | `8089` |
| <img src="https://archive.org/services/img/msdos_Whiplash_1995" width="100"> | **[Whiplash](./whiplash/)**<br>Gremlin Interactive | 1995 | Futuristic racing with weapons | `8099` |
| <img src="https://archive.org/services/img/POD20_201808" width="100"> | **[P.O.D.: Planet of Death](./pod/)**<br>Ubisoft | 1997 | Race to escape a dying planet! Bundled with Pentium MMX | `8102` |
| <img src="https://archive.org/services/img/hover_20240305" width="100"> | **[Hover!](./hover/)**<br>Microsoft | 1995 | Classic Windows 95 hovercraft maze game | `8097` |

---

### 🎖️ Strategy & Tactical

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_Jagged_Alliance_1994" width="100"> | **[Jagged Alliance](./jagged-alliance/)**<br>Sir-tech | 1994 | Hire mercenaries, liberate Metavira - cult classic! | `8086` |
| <img src="https://archive.org/services/img/msdos_Syndicate_Plus_1994" width="100"> | **[Syndicate Plus](./syndicate-plus/)**<br>Bullfrog | 1994 | Cyberpunk tactical action + American Revolt expansion | `8087` |
| <img src="https://archive.org/services/img/mechwarrior_1989" width="100"> | **[MechWarrior](./mechwarrior/)**<br>Dynamix / Activision | 1989 | Pilot BattleMechs in the 31st century | `8105` |

---

### 🔫 First-Person Shooters

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_Redneck_Rampage_1997" width="100"> | **[Redneck Rampage](./redneck-rampage/)**<br>Xatrix / Interplay | 1997 | Build Engine FPS - aliens meet Arkansas! ⚠️ 17+ | `8091` |
| <img src="https://archive.org/services/img/msdos_Redneck_Rampage_Rides_Again_1998" width="100"> | **[Redneck Rampage Rides Again](./redneck-rampage-rides-again/)**<br>Xatrix / Interplay | 1998 | More redneck mayhem! ⚠️ 17+ | `8088` |
| <img src="https://archive.org/services/img/nam_20210413" width="100"> | **[NAM](./nam/)**<br>TNT Team / GT Interactive | 1998 | Build Engine Vietnam warfare | `8092` |

---

### 👊 Fighting & Action

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/msdos_One_Must_Fall_2097_1994" width="100"> | **[One Must Fall 2097](./one-must-fall-2097/)**<br>Diversions / Epic | 1994 | Giant robot fighting tournament - now freeware! | `8096` |
| <img src="https://archive.org/services/img/WEIRD_VGA" width="100"> | **[Weird Dreams](./weird-dreams/)**<br>Rainbird Software | 1989 | Surreal nightmare action - fight killer lawn mowers! | `8104` |

---

### 🧩 Puzzle & Simulation

| | Game | Year | Description | Port |
|---|------|------|-------------|:----:|
| <img src="https://archive.org/services/img/epicpin_202406" width="100"> | **[Epic Pinball](./epic-pinball/)**<br>Digital Extremes | 1993 | 3rd best-selling shareware ever! Funded Unreal Engine | `8083` |
| <img src="https://archive.org/services/img/the_even_more_incredible_machine_1993" width="100"> | **[The Incredible Machine](./incredible-machine/)**<br>Sierra / Dynamix | 1993 | Rube Goldberg puzzle perfection | `8100` |
| <img src="https://archive.org/services/img/catz_april1998" width="100"> | **[Catz](./catz/)**<br>PF Magic | 1998 | Adopt and raise virtual kittens | `8106` |

---

## 📦 Deployment

### 🐳 Docker (Recommended)

Each game is fully containerized:

```bash
cd <game-directory>
./scripts/download-game.sh    # Download from Archive.org
docker-compose up -d          # Start the container
```

### 📦 Proxmox LXC

One-liner installer for Proxmox hosts:

```bash
bash lxc/proxmox-install.sh
```

### 🎮 Run Multiple Games

```bash
# Start several games at once
for game in jazz-jackrabbit carmageddon mechwarrior; do
  (cd $game && docker-compose up -d)
done
```

---

## 🔢 Quick Port Reference

| Port | Game | Port | Game |
|:----:|------|:----:|------|
| `8080` | Operation Neptune | `8094` | Jazz Jackrabbit |
| `8081` | Gizmos & Gadgets | `8095` | Storybook Weaver |
| `8082` | Jazz: Holiday Hare | `8096` | One Must Fall 2097 |
| `8083` | Epic Pinball | `8097` | Hover! |
| `8084` | Carmageddon | `8098` | Midnight Rescue! |
| `8085` | Destruction Derby 2 | `8099` | Whiplash |
| `8086` | Jagged Alliance | `8100` | Incredible Machine |
| `8087` | Syndicate Plus | `8101` | Mario Teaches Typing |
| `8088` | Redneck Rampage 2 | `8102` | P.O.D. |
| `8089` | Interstate '76 | `8103` | Oddworld |
| `8090` | Busytown | `8104` | Weird Dreams |
| `8091` | Redneck Rampage | `8105` | MechWarrior |
| `8092` | NAM | `8106` | Catz |
| `8093` | Treasure MathStorm | | |

---

## ➕ Adding New Games

1. **Create directory:**
   ```bash
   mkdir -p new-game/{game,scripts,lxc}
   ```

2. **Copy template** from any existing game

3. **Customize:**
   - `index.html` — Web interface & js-dos config
   - `scripts/download-game.sh` — Archive.org URL
   - `docker-compose.yml` — Unique port

4. **Bundle format:** ZIP containing game files + `.jsdos/dosbox.conf`

---

## 📜 License

Infrastructure code provided as-is under MIT license. Individual games retain their original copyrights — sourced from [Internet Archive](https://archive.org) for preservation and personal/educational use.

---

<div align="center">

**Powered by [js-dos](https://js-dos.com)** | **Games from [Internet Archive](https://archive.org)**

Made with ❤️ for retro gaming enthusiasts

</div>
