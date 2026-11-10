# Resist Forever

Resist Forever makes the magical resistance values in your **World of Warcraft Forever** character sheet easier to understand. Hover a resistance to see the estimated chances of partial spell-damage reduction—and the base chance that a spell misses altogether.

**Creative:** Babuni · **Target:** Forever 1.60.1 / Interface `16001` · **Documented CurseForge version:** 1.0.3 · **License:** [MIT](LICENSE)

## What it shows

Open the character panel, or your pet's statistics panel, and hover **Fire, Nature, Frost, Shadow or Arcane resistance**. The addon adds a section to Blizzard's existing tooltip rather than replacing it.

The probabilities are displayed in **10% damage-resisted steps**, from 10% through 100%, with a separate base spell-miss estimate. Results can compare an attacker at your own level with the selected target's level. They never substitute your target's resistance for your own.

These numbers are **model-based estimates**, not predictions of every real combat outcome. They do not include unknown enemy spell-hit bonuses or spell penetration. The 0%-resisted bucket is part of the calculation but is not printed, so the displayed entries need not sum to 100%.

## Install and use

Install via [CurseForge](https://www.curseforge.com/wow/addons/resistforever) or copy the addon into `Interface/AddOns/ResistForever/`:

```text
ResistForever/
  ResistForever.toc
  ResistForever.lua
  LICENSE
```

Enable the addon from the game's addon list and hover a resistance row. No slash commands, settings window or persistent SavedVariables are required.

## How reliable is the estimate?

The model used in v1.0.3 is based on Forever-specific research into direct magical damage, including an average resisted fraction of `R / (R + 9L)` for resistance `R` and attacker level `L`. The research was rechecked against public Forever UI and simulation sources on **4 November 2026**.

The addon takes care with values that Forever marks inaccessible or secret. It may use a session-only previously readable value, clearly marked in the tooltip, rather than silently inventing a new reading.

**Important boundaries:**

- Direct spell damage is the target model. Binary resists, periodic effects and specialized spell mechanics may differ.
- Source-level API compatibility and simulation research are not a substitute for launch-client or combat-log verification.
- Unreadable values, unknown targets and unavailable information are skipped or marked, not guessed.

All mathematical assumptions, edge cases, tooltip examples, hook behavior and version-specific testing limits are in the [technical model reference](docs/MODEL_REFERENCE.md).

## Release status

The documented CurseForge release **1.0.3** was approved for Forever 1.60.1, with Git tag `v1.0.3`. The source review also recorded that the GitHub Release object had not yet been updated from `v1.0.2` and the exact CurseForge ZIP contents had not been inspected byte for byte. These are separate publication checks, not gameplay features.

Consult the [changelog](CHANGELOG.md) and [technical reference](docs/MODEL_REFERENCE.md) for dated release evidence rather than treating an older metadata snapshot as live service status.

## Documentation

| Topic | Document |
| --- | --- |
| Why the addon exists | [Concept](CONCEPT.md) |
| Detailed math and API research | [Model reference](docs/MODEL_REFERENCE.md) · [Architecture](docs/ARCHITECTURE.md) |
| Decisions and trade-offs | [Decisions](docs/DECISIONS.md) |
| Progress and verified changes | [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md) |
| Project history | [Development journal](docs/DEVLOG.md) · [AI collaboration](docs/AI_COLLABORATION.md) |
| Working on the source | [AGENTS.md](AGENTS.md) · [Documentation standard](docs/DOCUMENTATION.md) |

Resist Forever is made specifically for WoW Forever. Its research model should not be presented as interchangeable with the earlier WoW 1.12 project ResistInsight.
