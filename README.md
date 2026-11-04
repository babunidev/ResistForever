# Resist Forever

**Creative:** Babuni · **Current CurseForge release:** 1.0.3 · **Latest Git tag:** v1.0.3 · **Latest GitHub Release object:** v1.0.2 · **Target:** World of Warcraft: Forever 1.60.1 · **TOC interface:** 16001 · **License:** [MIT](LICENSE)

**Resist Forever** explains how a character's or pet's magical resistance might affect **direct spell damage**. Hover **Fire, Nature, Frost, Shadow or Arcane resistance** in the character/pet panel to see the chance of each **10% damage-resisted outcome**, together with **base spell miss** against an attacker of a given level.

It extends the existing Blizzard tooltip instead of replacing it, so the game's original resistance information stays visible.

## Launch compatibility review

On **November 4, 2026**, the addon was reviewed against the public WoW Forever UI source snapshot for **1.60.1.70790 / Interface 16001**. The Blizzard structures Resist Forever depends on are still present: `PaperDollStatTooltip`, `CharacterStatFrameScrollBoxIconElementMixin:Init`, the player and pet stat panes, resistance-row `numericValue`, and the four-value `UnitResistance` API. The current API documentation also retains secret-value restrictions, so the addon's guarded reads and cache fallback remain relevant.

The current [wowsims/forever](https://github.com/wowsims/forever) model still uses the same **10%-step direct-spell resistance distribution**, **`R/(R+9L)`** average and **zero-floor level-based spell miss** adopted in 1.0.2. That is supporting research, not Blizzard server source. This review was **source-level only**: it does not claim a successful launch-client in-game test or combat-log validation.

## Install

The normal player install is through the [ResistForever CurseForge project](https://www.curseforge.com/wow/addons/resistforever). For a manual install, place a folder named `ResistForever` under `Interface/AddOns`.

The packaged addon is intentionally minimal:

```text
Interface/
└── AddOns/
    └── ResistForever/
        ├── ResistForever.toc
        ├── ResistForever.lua
        └── LICENSE
```

Only the TOC and Lua are loaded by WoW; the MIT `LICENSE` accompanies the distributed source as required by the license. Repository-only files such as `AGENTS.md`, README/concept/roadmap, `CHANGELOG.md`, `docs/`, and `tests/` are excluded from release ZIPs by `.pkgmeta`.

Enable **Resist Forever** in the game's addon list and open your character sheet. Hover a resistance row, or open the **pet character panel** and hover its corresponding resistance row. No slash commands or settings screen are defined by the current source; the addon does not write SavedVariables.

**Release status, November 4, 2026:** annotated tag **v1.0.3** points to release commit `8c2856e8600432ae44622c5c70d9e89405ffd466`. CurseForge shows **v1.0.3** as an **Approved Release** for **WoW Forever 1.60.1**. A separate GitHub Release object for v1.0.3 has not been created; the latest GitHub Release object remains v1.0.2. The published CurseForge file itself has not yet been opened and inspected byte-for-byte, so the intended three-file package is documented from `.pkgmeta`, not claimed as a verified archive listing.

This build targets the Forever UI conventions used by `CharacterStatFrameScrollBoxIconElementMixin`, `PaperDollStatTooltip` and interface 16001—not ordinary Vanilla 1.12 or modern retail WoW.

## How to read the tooltip

The addon appends a **Resist Forever** section below Blizzard's native tooltip. It can show two contexts:

- **Against level N**: the hypothetical attacker's level equals the displayed **player/pet's level**.
- **Current target · Level N**, or the **target's name · Level N**: the **selected target's level** is used as the hypothetical attacker's level when it differs from the defender's level. The target's *resistance* is **never** substituted for yours.

For each context it lists only non-negligible, non-zero **10%, 20%, ... 100% damage resisted** probabilities. The **0% damage resisted** outcome exists internally but is intentionally hidden in the tooltip. Percentages are rounded to one decimal; suppressed/rounded-zero rows mean the visible rows do **not** necessarily sum to 100%.

The final **Base spell miss** row is a level-difference estimate **before any enemy spell-hit bonuses**. It is separate from resistance-based partial damage reduction: a missed spell is not the same as a landed spell suffering a partial resist.

A simple *model illustration*, **not an observed client combat test**: 90 resistance against a level-10 attacker has an average resisted fraction of `90 / (90 + 9 × 10) = 0.5`. Under the middle-range triangular distribution, its visible nonzero outcomes are **40% damage resisted: 25% chance; 50%: 50%; 60%: 25%**. At equal attacker/defender level, modeled base spell miss is **4%**. Actual gameplay differs with spell-specific mechanics and unobserved enemy stats.

## Current Forever model used by 1.0.3

The released 1.0.3 build keeps the resistance formulas adopted in **v1.0.2**; the launch-polish changes do not alter the mathematical model:

| Quantity | Current behavior |
| --- | --- |
| Average fraction of *direct spell* damage resisted | `a = R / (R + 9L)`, for positive readable defender resistance `R` and attacker level `L` |
| Partial outcomes | **0%, 10%, 20%, ... 100%** resisted; 0% is calculated but not shown |
| Middle of distribution | `P(x) = max(0, 0.5 - 2.5 × abs(x - a))`, for discrete steps `x` |
| Near the 0% / 100% edges | Separate closed-form three-bucket distributions prevent edge loss |
| Base spell miss, defender minus attacker level **d ≥ 3** | **17%**, under this current Forever model |
| Base spell miss, **d < 3** | `max(0, 4% + d × 1%)` |
| Minimum unavoidable miss chance | **None assumed**: a calculated 0% is allowed and omitted from visible rows |

These formulas reflect the **Forever research model adopted in v1.0.2 and rechecked against current public research on November 4, 2026**. They aren't Blizzard server-source guarantees for every state, spell or future patch. In particular:

- This is for **direct magical spell damage**, not binary resist checks, non-channeled periodic ticks, channel damage, or a spell-specific damage model. Source comments note those behave differently.
- Enemy **spell penetration** and **spell-hit bonuses** are unknown, so displayed resistance/miss odds are baseline estimates, not exact personalized probabilities.
- A nonpositive/unknown resistance does not cause invented partial-resist probabilities; base spell miss may still appear.
- Some special/unknown target levels may return no valid `UnitLevel`; the addon omits that target comparison instead of guessing a boss's level.

## Player, pet, live values and safe fallbacks

The source recognizes resistance rows by their **Fire/Nature/Frost/Shadow/Arcane atlases** and classifies them under the **player** or **pet** statistics scroll box. For resistance it prefers the frame's already-readable `numericValue`; otherwise it reads `UnitResistance` (effective value first, then real). It separately obtains the defender's level.

Forever's UI can present **secret/protected values**. The addon checks value accessibility before calculating and maintains a small session-only cache of previously readable player/pet levels and resistance. Target names are rejected as secret before any string comparison. When the player's pet changes, the old pet cache is cleared before new values are read. If a valid last-known value is used, the tooltip marks it with **“Using last available resistance value”**. No persistent data or private combat logs are stored.

Changes in target, auras, pet state, equipment, resistance or level trigger attempts to refresh the cache/open tooltip. Hooks are installed through `hooksecurefunc` rather than wholesale replacement of Blizzard's original tooltip routine. There may be updates delayed by the client or missing when data is inaccessible; stale results are identified instead of silently treated as fresh.

## History and limitations

**September 28 — 1.0.0:** First implementation, initially using Classic-style resist outcome buckets. **October 12 — 1.0.1:** Pet support and an updated Classic PvP/PvE split for level-based misses. **October 20 — 1.0.2:** Replaced those estimates with the then-current Forever beta **10%-step resist and base spell miss** models. Those are genuine modeling revisions, not three simultaneous calculation modes.

The runtime remains one Lua file plus the TOC, with a [.pkgmeta](.pkgmeta) pointer to the manual changelog. The repository also contains `tests/math.lua`, a pure-Lua regression harness for the production resistance and base-miss functions; it is excluded from player packages. Source/API compatibility, automated math checks and confirmed CurseForge publication are separate from live game verification; no launch-client combat-log validation is claimed. The [MIT license](LICENSE) is preserved.

## Portfolio and development documentation

- [Creative concept](CONCEPT.md) · [Testing/roadmap](ROADMAP.md) · [Version and Git changelog](CHANGELOG.md)
- [Architecture](docs/ARCHITECTURE.md) · [Tooltip design](docs/DESIGN.md) · [Text/formula content](docs/CONTENT.md)
- [Design decisions and alternatives](docs/DECISIONS.md) · [Narrative development journal](docs/DEVLOG.md)
- [Human–AI collaboration](docs/AI_COLLABORATION.md) · [Developer/AI rules](AGENTS.md)

The original project idea and its creative direction belong to **Babuni**. Documentation and AI-assisted implementation are recorded separately from that human creative direction; source review is not presented as verified combat behavior.
