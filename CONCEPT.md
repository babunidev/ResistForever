# ResistForever — concept and creative direction

**Human creator and creative director:** Babuni.dev  
**Environment:** World of Warcraft: Forever 1.60.1 / UI interface 16001.

## Numbers the character sheet hints at, but does not explain

Resistance is one of those statistics players can invest in without easily reading what it means in a fight. A Fire resistance number on the character sheet is not intuitively equal to a chance to resist a spell, nor does it say how much damage a successful spell might lose. And the question grows more complicated when the enemy is several levels above or below the defender.

The creative purpose of Resist Forever is to make this **existing character-sheet information** understandable exactly where the player already looks. Instead of opening a calculator, external guide or unrelated addon window, hovering a resistance row extends the same tooltip with a breakdown: **what amount of direct spell damage could be resisted, and how likely is each amount?**

The feature is intentionally small. Its ambition is not to build a DPS meter, automatic gearing adviser or comprehensive boss-spell simulator. It gives a player a readable interpretation of their own—or their pet's—defensive statistic and allows them to decide what it means for their equipment and encounters.

## Protect the game interface's continuity

The extension **doesn't replace Blizzard's tooltip**. It appends a clearly titled **Resist Forever** section under the native resistance explanation, using the game's own font color system and left/right rows. The same five resistance schools—Fire, Nature, Frost, Shadow and Arcane—are recognizable from their existing atlas icons.

A new context appears if the player has selected a target at a different level. The target supplies the **hypothetical attacker level**, not a source of resistance values. This lets the user see how the same armor/resistance statistic reads against a more or less powerful caster while retaining the character/pet as the defender.

In October 2026, pet resistances were included too. This extended the idea from the player's own character sheet to companions without inventing a second visual language.

## Honor uncertainty rather than sell false precision

This particular client builds some values as **secret/protected UI numbers**, so the addon checks whether it can safely read and calculate with them. If only the last-known valid resistance or level is available, the tooltip says so. If no reliable value exists, the extension omits the calculation.

The same restraint applies to mechanics. Spell hit and penetration of an unseen enemy aren't known from the resistance row. Binary spells, periodic ticks and channels are not modeled by the direct-damage distribution. A target with an unknown/skull level isn't silently guessed as “+3.”

This is part of the authored interaction idea: **context-rich estimates, explicitly labeled as estimates**, make resistance easier to learn without turning the addon into an oracle.

## The actual creative iteration

The current program is shaped by a visible calculation evolution. The initial late-September release used historical Classic-style partial outcomes. Version 1.0.1 refined different miss curves for players and pets and added the pet sheet. On **October 20, 2026**, version **1.0.2** adopted a documented Forever beta model with **10% partial-resist steps**, average `R/(R+9L)` and a single base spell-miss function rather than the earlier Classic PvP/PvE split.

That last change is not merely a formatting update: it changed what the numbers *mean*. The source and changelog establish the revision; they don't expose every discussion or prove the underlying combat model against a live test in this review.

**Authorship:** Babuni.dev retains original direction and creative authority. The current assistant wrote this retrospective concept summary from actual code/Git evidence; proposed future enhancements are not approved by that act.
