# Stuff for TFS & OTC

## Question 1-3

See file `q123.lua`

## Question 4

See file `q4.lua`

## Question 5


https://github.com/keptsecret/otc-fts-mods/assets/27181108/f0c19053-285a-407f-8ec5-3e3b325a982b


The attack spell is performed as a spell combination.
The animation is done by changing the area of effect of the spell for each step in the sequence.
`addEvent` is used to stagger each step of the combo.
This uses the ice_tornado magic effect.
The animation is not exactly 1-to-1 as the given example but quite close enough.

Files added/changed in TFS:

* `blizzard.lua`: belongs in data/spells/scripts/attack
* `spells.xml`: replaced in data/spells

## Question 6


https://github.com/keptsecret/otc-fts-mods/assets/27181108/9c44a818-d752-4388-adbf-ab69f6101692


I couldn't figure out how magic effect animation sequence were defined so I chose a different method.

On the server side, two new magic effects were defined under `MagicEffectClasses` in `const.h` to inform dashing (`CONST_ME_DASH`) and stop dashing (`CONST_ME_NODASH`).
The dash itself is a support spell and moves the player forward quickly 5 tiles.

On the client side, a special trail effect is added for the player specifically when dashing.
This is done by drawing more copies with decreasing opacity of the player behind them during the dash effect.
`parseMagicEffect` is also modified to handle the new magic effects.

There seems to be a graphical bug where a drawing area towards the bottom right of the player is either cleared or undrawable.
I couldn't quite figure out the solution to this problem, so dashing to the left or up looks incomplete.

Files added/changed in TFS:

* `const.h`
* `dash.lua`: belongs in data/spells/scripts/support
* `spells.xml`
* `luascript.cpp`: registered new effect enums
* `tools.cpp`: added new effects to `magicEffectNames`, probably not needed

Files added/changed in OTC

* `protocolgameparse.cpp`: see `parseMagicEffect()`
* `localplayer.h` and `localplayer.cpp`: overrides `draw()` from parent class `Creature` and new `drawTrail()`

## Question 7


https://github.com/keptsecret/otc-fts-mods/assets/27181108/52e77e42-5332-419a-8511-69b00e8db7b7


This is done as a module for otclient.
There is a `MiniWindow` with a `Button`.
The button is moved across the window by setting a `periodicalEvent` that executes at intervals to provide the effect.

Files added in OTC (all go into a `game_movingbutton` folder in modules):

* `movingbutton.lua`
* `movingbutton.otmod`
* `movingbutton.otui`

## Other notes

For TFS 1.4, `fmt` library required causes errors during compilation with version 10.0 (the latest version).
There is a fix for the current version of TFS [in PR#4491](https://github.com/otland/forgottenserver/pull/4491) that works with C++20, but TFS 1.4 is on C++17.
I had to make modifications to `tools.h`, `iomarket` and `iomapserialize` based on the linked PR for it to work.

Also, for some reason, the otclient from edubart on the latest version doesn't render the ice_tornado effect correctly. See [here](https://otland.net/threads/issue-on-the-animation-of-eternal-winter.281595/).
So the video is recorded using mehah's otclient.
This effect can be seen when using the eternal winter spell as well as the new AOE spell for this.
