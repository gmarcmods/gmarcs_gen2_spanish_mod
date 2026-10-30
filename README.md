# Gmarc's Gen 2 Spanish — Oro, Plata y Cristal (1.1.2)

Install the release ZIP (**GEN2_ES-1.1.2.zip**) through the gen1recomp mod importer. Enable GEN2_ES
for Gold, Silver and Crystal. Disable/remove the older GOLD_ES and SILVER_ES
mods; the manifest declares conflicts to prevent mixed translations.

This is one installable mod, with one manifest and automatic edition
selection. Its three catalogs retain the original Spanish cartridge wording,
names, descriptions, metric Pokédex data and name presets. The graphics shared
by all three cartridges are verified identical. Edition-specific title art
and font differences remain separate. No ROM is included or needed at install.

Native nonempty source-record coverage:

| Edition | Dialogue | System texts | Untranslated |
| --- | ---: | ---: | ---: |
| Gold | 3,042 | 882 | 0 |
| Silver | 3,042 | 882 | 0 |
| Crystal | 4,000 | 1,004 | 0 |

Crystal's phone fields retain distinct trainer/Pokémon names. Its National
Park gates retain their two original Spanish versions, using named and numeric
native map contexts. Seer field reordering and original abbreviated times are
preserved. The trainer card uses its original blank name caption and DIN.
label, and its status plaque and diploma use original Spanish graphics.

Port additions such as settings and saving printer output use separately
reviewed Spanish UI wording. The original move RAGE is FURIA. This mod does
not alter voxel geometry, controls or gameplay rules. Its engine-internals
permission serves game identification and scoped presentation adapters for
cards, phone calls, mail and NPC trades; no engine files or another mod's
files are changed.

Tests cover the shared entry, all native source records, distinct name fields,
map-specific rules, graphics/source provenance, menu layouts and one-manifest
packaging. Live probes cover all three games, including the full Gold UI
audit. Source coverage is not a claim that every possible playthrough was run.

Rebuild the three catalogs with `tools/spanish/build.py --game <edition>`,
then run `tools/spanish/assemble_unified.py` and
`python3 scripts/export-mods.py GEN2_ES` from the workspace root. The workspace
catalog exports this product instead of the legacy edition-specific mods.

Version 1.0.1 also corrects the caller ID on Mom's special shopping call.
That engine path supplies an English constant instead of the localized contact
record. The compatibility wrapper substitutes the original edition catalog's
`MAMÁ` only for that default label, without changing the script, custom names,
or the disabled-mod behavior. Tested with all three native catalogs and an
actual Gold shopping call/caller-ID capture.

Release 1.0.1 includes the native MAMÁ caller label for shopping calls on all
three editions; the original script body is unchanged.

## NPC trade dialogue (1.0.3)

NPC trade screens read `events.tradeTexts`, independently of the shared
system-text registry. The mod now supplies a copied event-text view to both
native TradeMenu and TradeAnim. Intro, refusal, wrong-mon, completion and
post-trade lines use the existing original Spanish catalogs. This includes
Crystal's fourth dialogue personality. Species, trainer and player arguments
follow the original Spanish buffer order, including the reversed animation
sender/species wording and Crystal's reordered trade receipt.

The original event tables, trade definitions, flags, party and save are not
changed by localization. Disable the translation and newly opened screens
receive the native event data again. The single GEN2_ES ZIP covers all three
editions; no cache extraction is required for this fix.

Validation from the workspace root:

```sh
luajit mods/gen2/voxel-runtime/tests/test_spanish_npc_trade.lua
python3 mods/gen2/voxel-runtime/tests/test_spanish_npc_trade_sources.py
luajit mods/gen2/voxel-runtime/tests/spanish_unified_test.lua
```

The source test verifies the displayed wording and placeholder order against
all three original Spanish ROMs using the catalog's recorded provenance.
`tests/gold_spanish_npc_trade_probe.lua` supports all three editions and
checks 30 native NPC dialogue paths in Gold/Silver, 35 in Crystal, all six
animation text beats, and screenshots of the Krabby–Voltorb offer in Tim's
house. It uses separate trade saves and does not perform a real party trade.
These are desktop Love checks, not physical Android-device tests.

## Optional mod translations (1.1.0)

Spanish for our gameplay mods now belongs here, in `companions/strings.lua`,
using the engine's contextual string registry. Celebi's authored Spanish
quest lives in `companions/celebi.lua` and overrides stable English text IDs
only when the optional quest mod is loaded. Original cartridge catalogs and
provenance remain separate. Update changed gameplay ZIPs together with this
language ZIP; English fallback works when Spanish is disabled.

The catalog covers Moveset Plus, Useful Bag, Happiness, HM Anywhere,
Widescreen Menus, Run Mode, Trade Evolutions, voxel/JIFP settings, Touch Tools
and the maintained shared forks. Names, stats, option storage and graphics
remain with their owning mods or native game data. Developer/editor text is
not claimed fully translated. See `docs/translation-protocol.md` in the
runtime repository and the workspace translation policy for the full audit.

`language: true` now classifies this product. The existing scoped adapters
still require `engine_internals`, and `affects_link: true` remains intact.
An options-label adapter supports older app builds; engines declaring native
contextual schema support skip it. No engine rebuild is needed for that
in-game compatibility path. Install the individual lowercase `gen2_es.zip`.
