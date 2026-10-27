# ResistForever — information and tooltip interaction design

**Creator and creative director:** Babuni.dev.

## The player is already looking at the right place

Instead of a new window, options panel, minimap button or graph, Resist Forever starts with the game's **character sheet**. The player hovers a resistance row—Fire, Nature, Frost, Shadow or Arcane—and reads more detail in the tooltip already displayed by Blizzard.

That restraint is the core visual decision. The native tooltip still holds the stat's familiar context; the addon simply appends a separated **Resist Forever** heading and a small table of outcome/chance pairs. Nothing about enchant values, character appearance or equipment changes.

The approach extends to the **pet character panel**, so the visual vocabulary remains the same whichever defender the player is examining.

## Rows that say exactly what they mean

A label such as **“50% damage resisted”** is distinct from **“50% chance”**. The former is an *outcome* (how much of a direct spell is reduced) and the right-hand number is the *probability of that outcome*. Keeping those concepts in separate columns reduces confusion.

The addon lists only meaningful positive-resist outcomes in steps of 10%. It intentionally does **not** show the 0% resisted outcome even though that bucket is used in the probability distribution. Very small probabilities that would round to 0.0% are suppressed, keeping the display manageable. As a consequence, the visible row chances need not add to 100%; explaining this in README prevents a false impression of bad math.

**Base spell miss** has its own row, rather than being folded into the partial-resistance distribution. Miss happens before resistance is considered for a hit and additionally depends on unobserved spell-hit bonuses, so this output is explicitly a **baseline**, not a promise about every spell.

## Context without a separate level picker

The default subsection is **“Against level [defender level]”**, a simple same-level comparison that works without a selected target. If the player targets someone of another known level, an additional subsection uses that unit's level as a hypothetical attacker.

This is contextual exploration: a player may hover the same Fire resistance and watch the estimated distribution shift when facing a higher-level spellcaster. The target's own resistance isn't mixed into this calculation.

An unknown-level enemy isn't assigned a plausible-sounding guess. It simply doesn't receive a dedicated level comparison.

## Honesty about stale data

Protected client values can be unreadable during some UI states. Resist Forever keeps the last readable player/pet resistance/level during the session and adds the visibly muted note **“Using last available resistance value”** when that fallback is actually used.

This is a micro-interaction with a meaningful ethical purpose: the display communicates **the freshness of its basis**, rather than quietly presenting an old number as current.

## Future visual research

The actual client should be tested for crowding when many 10% rows appear, narrow tooltip width with long target names, localization of English labels, contrast/accessibility of the appended section, and the stability of tooltips when stats or targets update. These are proposed tests, not features designed or approved in the October 27 audit.
