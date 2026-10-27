# ResistForever — content inventory, formulas and player data

**Creator:** Babuni.dev · **Current release:** 1.0.2.

## The five resistance subjects

The addon has no author-maintained database of gear, enemies, boss spells or item names. Its five recognized content categories are the built-in character and pet resistance rows:

| Magic school | Preferred atlas | Fallback enum |
| --- | --- | ---: |
| Fire | `UI-Character-Info-Resistance-Fire` | 2 |
| Nature | `UI-Character-Info-Resistance-Nature` | 3 |
| Frost | `UI-Character-Info-Resistance-Frost` | 4 |
| Shadow | `UI-Character-Info-Resistance-Shadow` | 5 |
| Arcane | `UI-Character-Info-Resistance-Arcane` | 6 |

The numeric school ID is read from `Enum.Damageclass` when available, otherwise from these fallbacks. Atlas association identifies the actual hovered row rather than selecting one school arbitrarily.

## Authored tooltip strings

- Section heading: **Resist Forever**.
- Default subsection: **Against level [N]**.
- Additional subsection: **[Target name] · Level [N]** or **Current target · Level [N]**.
- Ten possible visible outcome labels: **10% / 20% / 30% / 40% / 50% / 60% / 70% / 80% / 90% / 100% damage resisted**.
- Baseline metric: **Base spell miss**.
- Fallback note: **Using last available resistance value**.

These authored strings are currently in **English**. The source has no localization table; the native Blizzard tooltip may follow its own client language.

## Model values and omission rules

Data sources are a readable stat-row `numericValue`, `UnitResistance`, `UnitLevel`, and optionally selected target `UnitLevel`/`UnitName`. No other person's private record is queried or stored.

Current modeled average `a=R/(R+9L)`. Distribution is **0%,10%,...,100%**, with edge formulas and a centered triangular model. Only **10–100%** are offered as positive reduction rows; any exact 0% outcome is deliberately invisible. A row must also meet a **0.0005 fraction** threshold and not round to **0.0%** at one decimal.

Base miss depends on the **defender minus attacker** level: `17%` if the defender is at least 3 levels higher; else `max(0,4%+diff%)`. Unlike older versions there is no separate player-vs-pet miss curve.

The source doesn't model enemy spell penetration, actual attacker spell hit, binary spells, channels or DoT ticks. Any public portfolio description must keep those limitations attached to percentages.

## In-memory versus persisted content

The program uses an in-memory `cache.level` table and school-indexed player/pet resistances; this is **not saved to disk**. There is **no SavedVariables declaration**, combat-log archive, network transmission, telemetry, or stored list of player names. An open tooltip can contain the **current target's name**, but that name is only used locally for its label.

## Source and licensing inventory

- [`ResistForever.lua`](../ResistForever.lua): entire runtime/UI and current formula.
- [`ResistForever.toc`](../ResistForever.toc): interface 16001, version 1.0.2 and author credit.
- [`CHANGELOG.md`](../CHANGELOG.md): original version sequence plus audit chronology.
- [`.pkgmeta`](../.pkgmeta): manual-changelog metadata.
- [`LICENSE`](../LICENSE): existing **MIT License**, copyright Babuni.dev.

No image/font/sound files or automated tests are included in the inspected repository tree. The source uses Blizzard's existing stat atlases and tooltip fonts rather than bundled original media. GitHub v1.0.1 and v1.0.2 release entries have **no attached ZIP assets**.
