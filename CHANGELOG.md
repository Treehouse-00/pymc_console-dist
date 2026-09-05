# Changelog

All notable changes to waev:outpost (the `pymc_console` repository) are documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html) with rapid patch releases.

---

## [0.9.378] - 2026-09-05
### Added
- **Neighbour Links page.** Under Statistics: every peer the repeater hears directly, with how many packets it heard and how many were repeats, when it was last heard, and its smoothed RSSI, SNR and RX score. Pick a link for its history over the last hour to seven days on three LED screens, each packet a point where it was heard, with the repeater's own smoothing drawn through. Needs a repeater from August 2026; older ones show a note.
- **Direct adverts.** A Direct key beside Send Advert reaches only the neighbours that hear this repeater first-hand; the terminal takes `advert direct`. The Configuration page gains a Direct Advert Interval field and room servers gain both interval fields, shown only when the repeater supports them.
- **TX power checklist.** Raising TX power pauses on a short checklist (antenna, regional limit, duty cycle, supply, neighbours) before it applies. Lowering it applies at once.
- **Discovered regions and a node's scopes.** The Regions module lists the regions neighbours say they serve, with a count and a plus to add one. A node's map popup shows the regions it reports and an ask-now key.
- **MQTT neighbours table.** The MQTT page shows the publication's phase, next run, interval and last publish, with a Publish now key and a per-broker Publish neighbours table switch.
- **Manual CAD check.** The CAD Calibration page runs eight live detections at the current thresholds, or at a sweep's best, and prints the rate.
- **Terminal search.** A search key on the terminal: type to find in the output, Enter for the next match, Shift+Enter for the previous, Escape to close.
- **Multi-radio selector.** On a repeater with several radios, a Radio selector on the Configuration page's Radio module and the Radio Hardware page picks which one is edited; the others are left as they are.
- **Reduce-glare key.** In the map's View gang: every screen in the console drops to the matte level the chat screens use, in one half-second fade, and the choice is remembered. If your system reduces transparency, the glass comes off entirely.
- **A face on the map's screen.** A faint graph-paper grid fixed to the glass with a gentle barrel bow, shown on its own while the map loads or when no contact has a position.
- **Modes band as a corner sheet.** Deep Analysis and Live Trace sit in a small ringed sheet at the top-left of the screen; the position readout rises level with it.
- **Keys spring back.** Mode keys (3D terrain, light basemap, reduce glare, the class selectors, the companion's round keys) depress only under your finger; the lamp says the mode is on.
- **Edge shading on the map.** A soft second shading from the left and right edges, deepest at the corners, that fades with the rest under reduce-glare.
- **Cleaner, sharper glass.** The reflection is dithered against banding, the room behind it is stored losslessly, and it is drawn at up to 3× device pixels, all paid once when the glass is baked.
- **The companion's screens on the same glass.** Their faint room reflection is baked with the edge lamps, so the panels read as smooth black glass instead of blotches.
- **One glass for every screen.** The map's picture screen is the reflective kind; the chat panels, the I/O charts, the terminal, the logs and every other flat screen are the matte kind. Each housing mounts its own glass, so no screen draws its own lamps or sheen.
- **The terminal on a tube.** Its screen takes the reflective glass; the command line and foot sit on the plate under the bezel, outside the glass; the header bank is the compact height.
- **A terminal greeting.** WELCOME / EXPLORER in a block-and-shadow face, drawn in letter by letter with a scanline and a sheen, then held in the shell's green. Printed straight away with reduced motion on.
- **The openhop egg.** Type `openhop` (or `bunny`) at the prompt: the screen shimmers away pixel by pixel, a dithered rabbit hops across the bare glass, and the screen comes back exactly as it was. Ctrl+C ends it early.
- **A larger map key.** The legend along the bottom edge prints at the pixel face's own 16px; its group titles step down so the entries carry the line.

### Changed
- **Live log stream.** The Logs page listens to the repeater's log stream, so a line appears the moment it is written instead of on the next two-second poll. A repeater without the stream is polled as before.

### Fixed
- **The map is quiet when idle.** A layer-ordering step after every style change repainted the map at the display's full frame rate with nobody touching it; it now moves only layers that are out of place, and an idle map shows zero frames.
- **Terrain sampling stays out of the way.** The one-time elevation sampling after the map loads runs in the browser's idle time, stops if the map closes, and switches terrain back off when done instead of leaving it rendering.
- **Firefox veil.** With fingerprinting resistance on, the map was covered by a grey veil because the glass was read back from an image; it is drawn in place now and looks the same either way.
- **Safari reflection.** The reflection was a quarter dimmer and uneven on Safari; it now matches Chrome and Firefox.

### Compatibility
- No repeater database change and no schema migration. Every addition hides itself on a repeater that does not have the feature; nothing here changes what an older repeater is asked.
- Under the hood: the glass is baked with plain canvas drawing on every browser, each bake recorded as a `tui-glass-bake` performance measure, once at mount and once after a resize settles.

## [0.9.377] - 2026-09-04
### Fixed
- When the repeater is set to use the waev:outpost plugin as its main web interface, the page came up blank at the root address; only the longer `/plugins/waev.outpost/` address worked. The console now works at both, and deep links such as `/system/logs` work at both too. Nothing about the plugin package's layout or the repeater's settings changed.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.376] - 2026-09-04
### Changed
- The LUM knob on the companion plate reaches further. Up to 90 it does what it always did: it dims every screen together, from a floor you can still read up to full brightness. From 90 to 100 the screens stay where they are and only the text brightens, from the warm near-white the console ships with all the way to pure white at the top, for anyone who needs the most contrast the display has. The console ships at 90, which looks exactly as it did before, and a saved knob setting is carried over so nothing changes until you turn it.

### Compatibility
- No repeater database change and no schema migration.
- Under the hood: the check that ran after each plugin release was asking for a value that does not exist and failed every time even though the release had been published; it is fixed. A release now proposes itself to the plugin catalogue as long as its package was published, even if a check after that fails.

## [0.9.375] - 2026-09-04
### Added
- A rabbit drifts across the top-right corner of the login page's star field: in from above, a slow arc down and to the right, out through the right edge, rolling gently as it goes. It is in view for exactly the eight seconds of its clip, which starts on its first frame the instant the rabbit's first pixel appears and ends on its last frame as the last pixel leaves; then a long quiet before it comes by again. Safari gets its own copy of the clip, because it cannot play the transparent format the other browsers use. With reduced motion turned on there is no rabbit.
- Each release now proposes itself to the openHop plugin catalogue. After the plugin package is published, a workflow downloads it again, verifies it, and opens a draft pull request in the catalogue for a person to approve; nothing is approved automatically. Published plugin versions are kept rather than replaced, so a version the catalogue points at stays installable.
- A release can be sent to one public repository only, with `./release.sh "…" --targets=plugin` or `--targets=console`. The next plain release publishes to both again.

### Changed
- The product is written `waev:outpost` everywhere you read it: the browser tab, the terminal, the installer's messages, the Configuration page's frontend card, and the documentation. The install paths, archive names, and stored settings keep their old names so existing installs keep working.
- On a desktop screen the top of the sidebar is laid on a grid: the version chip and the small keys in one row, the waev wordmark under them standing on the same baseline as the page title, the Outpost paint hung under the wordmark across the column, and the first navigation entry level with the first row of the page.
- The README opens with the waev:outpost card.

### Compatibility
- No repeater database change and no schema migration.
- The release archives and the plugin package are about six megabytes larger than before: the two copies of the rabbit's clip.

## [0.9.374] - 2026-09-04
### Added
- The console can now be installed as a plugin of the openHop Repeater, alongside the repeater's own dashboard instead of replacing it. Each release now publishes a plugin package (a Python wheel) to a second repository, [waev-outpost-plugin](https://github.com/Treehouse-00/waev-outpost-plugin). Upload it on the repeater's System → Plugins page, enable it, and the console opens at `/plugins/waev.outpost/`. The repeater's plugin update check reads that repository, so later versions can be approved from the same page. The existing install through `manage.sh` is unchanged.

### Changed
- The login page shows the waev:outpost mark over a field of stars, with the username and password floating in front of it and an ENGAGE plate in place of the Continue button; the plate blinks while a login is ready to send and presses when you send it. The page follows the mouse, or the phone's tilt, with a slow drift. The header carries the Waev logo and the Outpost paint, and on a phone the Waev logo moves into the menu shelf. The loading indicator is a thin lit line along the bottom edge of the header, and the same line reports the packet history load in the sidebar; the ring around the packets chart is gone.

### Compatibility
- No repeater database change and no schema migration.
- This version was published only to the plugin repository, to prove the new lane. The `manage.sh` install path still serves 0.9.373 and picks up the next release.

## [0.9.373] - 2026-09-03
### Changed
- The channels, chat and contacts screens have their glass back. It was dropped with the pixel voice in 0.9.370 and never returned: a matte pane over each screen with a faint reflection of the room and the small lamps along the edge that show the panel is on. The reflection is a little stronger than before (a tenth of the room rather than a twentieth), and every LED screen in the console shares it.
- In the contacts list, a long name pushed the row's three-dot options key out of the row, so only contacts with short names could be right-clicked or opened for options. Long names now shorten with an ellipsis and the key stays at the right edge on every row.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.372] - 2026-09-03
### Changed
- A channel message now tells you whether the mesh has carried it. Once your radio has sent it but no repeater has repeated it yet, the row shows a single yellow check; hovering it reads "sent, not yet heard by any repeater". The first time a repeater repeats it, the mark turns into the green double check and the repeat count appears. Before this, a sent message with no repeats looked the same as one that had been carried, which read as a failed send. Direct messages are unchanged: their double check still means the other side acknowledged.
- In light mode, the labels on the path map (the node prefixes over the map, and the counter in the corner) were dark text on dark glass. They now sit on light glass with dark text; your own node's cell and the map pin stay dark with white text.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.371] - 2026-09-03
### Changed
- The advert keys are named on their caps, FLOOD and DIRECT in the keycap face, in place of the two glyphs. Each cap carries a pilot lens in its corner that blinks while the advert is on the air and holds lit once it is sent, beside the illuminated legend.
- The plate answers an advert in sequence once the radio has taken it: the top segment of the queue bar blinks once for the response itself, the TX lamp strikes as the radio keys, and the bar bursts the way a bar array answers a carrier, a short eased attack, a flickering decay, and for a flood the echoes of the repeaters on its tail, each a smaller burst; a direct advert is one short local burst. The bar snaps while the burst runs and settles back to the queue.
- The queue and status pockets are one packet monitor. The lamps stack at the left, LINK over RX over TX with small legends, and where LINKED idled the plate prints a brief of the last message heard: GRP_TXT or PRV_TXT, the channel if the console holds its key, and a preview of the text if it decrypted, else ENCRYPTED or UNKNOWN CHANNEL with the hash. The channel row's radio settings are three chips, the frequency in megahertz with its decimal in place, the spreading factor, the bandwidth, a decimal point printing tight so a figure reads as one number. The brief sits in a rigid grid: the type and the channel left-justified in their own columns, then the sender and text in a screen of their own that stands two seconds before it runs. On the handheld plate the second row reads contacts, then the bar, then channels, with the monitor on a row of its own under it so the grid keeps its columns and the lamps their legends; a short bar keeps only the end figures of its rule; on the narrowest phones the monitor's text drops to a row under the type and the channel. The roster heads fit a phone's die: the momentary keys drop their lamps, the keys and the inset come in, and the title stays whole. The contacts die starts folded to its icon column on a phone, and the fold is remembered either way once touched. The phone's foot is one row: the reset button beside the LUM knob on the knobs' own axis, the serial down on the screws' row, the tape hung just under the legends. The plate gives the monitor the larger share of a one-row bank and breaks to two rows under eleven and a half hundred pixels of plate, so the monitor's grid and the bar's run both keep their room at every width. The bar is legended RF, the pocket MONITOR; the bar itself is a quarter its old height, in the standard optics with no lit bloom, and holds its highest segment for a second after the level falls, so a busy air reads as a level rather than a light show.
- The queue bar is also an RF meter. Every message the radio hears, a channel post or a private text on any channel, strikes the bar to the level it was heard at, judged against the companion's own air settings: the SNR margin over what its spreading factor needs to demodulate and the RSSI margin over the receiver's sensitivity at its bandwidth. A strong post fills the bar; a marginal one barely lights it; overlapping receptions take the loudest. History does not strike it.
- A silkscreen rule above the RF bar, cut to the radio: the SNR a reception was heard at, in decibels, from the floor the companion's spreading factor can demodulate up through the twenty decibels of margin that fill the bar, a minor tick each decibel and a figure each five, the spreading factor at the left; every major tick lands on the segment its level lights.
- The keycaps' grain is a quarter the tile it was and a quarter dimmer, so it reads as a fine matte rather than a texture; the key wells are a pixel tighter again at the edges, between caps, and above and below them. The neutral caps take the light plate's greys and print in dark ink there, CONFIG and EXPAND included; a coloured cap is the same moulded plastic on either plate and keeps its face.
- The instrument no longer re-renders on every packet: the stats, flood-echo and topology subscriptions moved from the page model into the contacts column, the timeline and the route panel that use them; the contacts fold has one owner; the timeline rebuilds its rows once a day rather than once a minute. A colour knob previews its change at one paint per frame while it turns and commits to the store on release; the pixel displays share one resize observer and measure only a line that might run long.
- The channels tally prints four ghosted digits like the contacts tally, and both tally windows fill their pockets to the right edge, the figures at the right of the glass, so a die and its pocket read as one part.
- The plate's breaks are the plate's: the bank's handheld keys, the foot's phone layout and the sheet's handheld rows all key on the chassis's own width, measured once, instead of three different viewport widths; the bank folds away behind an open conversation by the page's own mark alone. The knob size and the gang gap are tokens on the foot. A dead phone rule for the roster title, a duplicated lamp gap and a duplicated touch floor are gone.
- Under the hood: an advert's answer keeps its identity between ticks so a tick that changes nothing renders nothing; the dB rule is memoised; the reception meter no longer scans the packet list twice; a reception with only an SNR or only an RSSI still scores; the companion's channels are registered with the decoder by name, once; the monitor's grid carries a group name; the layout's live share ref is synced after render; the composer resets its mention cursor where the query opens. A held marquee now runs on its own after its hold rather than only under the hand.
- The contacts key wears the plus key's silver instead of blue; the icon stays.
- The parts kit's keycap learns a word legend and a pilot lens; its LED meter learns a snapping attack for a bar that follows a signal and a top-segment cue for a bar that answers an event.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.370] - 2026-09-03
### Changed
- The reading print is the companion screens' only voice. It shipped a release ago as a parallel mode behind an ABC key; the key is gone, the pixel voice with it, and every screen prints in GC Basic Inktrap Mono, light for copy and medium for names, with no grain or lamps behind the text. The old toggle's saved setting is cleared on start.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.369] - 2026-09-03
### Changed
- The companion screen is three dies. Channels, the conversation and contacts each sit in their own LED window set into the plate, with plate between them, in that order left to right; on a phone the channels and contacts windows share the roster page side by side and the conversation window is the page when a conversation is open. The plate between the conversation and each roster window is a grip: drag it to resize that window, arrow keys move it from the keyboard, a double click returns it, and the widths persist. The old divider inside the shared card is gone. Nothing in the model moved: the housing is a seam the skin fills, and a layout without a skin draws its own cards.
- On the light plate, an LED array at rest sits behind the same grey LCD glass as every other screen, its zone band showing as faint etches, instead of a black slot; a lit lens on that glass prints as a saturated face with a lighter core and a clean edge rather than the dark-glass lens, whose dense rim and scatter read as a dark falloff on grey. The QUEUE bar was the first to show both. The round reset button beside the colour knobs takes the light plate's own recess for its collar.
- The conversation reads in two lanes with one cluster. A peer's row starts at the left edge and its text runs to a fixed measure; your own row ends at the right edge and runs the same measure leftward, so the eye learns two edges instead of hunting for one. The name, the time and the delivery marks sit together at the lane's edge on one 14px stamp line, with the row's keys just inside them, so nothing spans the width and nothing is read across it. Runs stack: within one sender's run the rows abut, and a new sender is set off by one full text line above, the same line a day break takes with the date in it. The stamp line is 14px, the text 16px on 21px, and there is no third size in the timeline.
- The message is the largest print on the companion screen. Text prints at the pixel face's native 16px on a 21px line, up from 12px, where it had been smaller than the names above it; the stamps, times and marks keep their label sizes, so a message reads first and its furniture second. The rosters step up one notch for legibility and stay under it: names at 14px, the last line under them at 12px, the pane titles and group labels at 12px; the heads' keys rest dim until the hand reaches them. Each avatar is a square of its identity's colour laid on the glass at a fifth, no outline, the glyph in ink on top: a tint the eye passes over on its way to the conversation where a hard line was an edge to stop at; it comes up stronger on the hovered and the open row, and room servers and repeaters take the same square in ink.
- Folding the contacts window collapses it to a single column of avatars, and the fold is one clean tween of the window alone: it used to drag the channels list along with it, from the days they shared a card, and could snap on the way back.
- The board ships in a warm near-white. The display ink every readout shares defaults to the colour the knobs read as hue 78, saturation 2, brightness 100, and the reset returns there; the amber the kit was tuned at is one turn of the HUE and SAT knobs away. A colour saved by an earlier release comes back as the new default.
- The companion's three windows are matte and in the light. Each carries the same glass the map and the I/O scope wear, with the glare turned off: the photographed room lies on the panel at a twentieth so the plastic has a grain, and the LED edge lamps burn along both sides so the panel says it is on. The kit's LED stock carries this for every screen of its kind.
- The keycaps are remade. Every key on every plate, the momentary keys and the latching class keys, the compact dies and the full-height ones, is now cut from one moulded cap: a face in the finish's own tint (silver, surface, red, blue, amber, each with its light-plate shade), a grain pressed into it, a light falling down it, and a lit top edge over a dark bottom edge, standing in a hole cut into the plate with the same grain in its floor, a hard shadow under its rim and a hairline of light on its lip. Under each cap lies its cast shadow on its own layer, soft and set a little down and right, falling on the hole and out over the plate wherever the cap stands near the rim, and gone when the cap seats. Hover lifts the light; a press darkens the face, deepens the edges into a cut and drops the shadow, with no travel, as the design has it, and a latched class key sits the same way at its detent. Red and amber are the design's own reference faces on the dark plate; on the light plate every face is lifted by exactly what the silver lifts, so the two plates never share a colour. The readout pockets keep the plate's own recess: the hole is the keys' housing alone. Rounding is a system of three steps now, 4, 8 and 16: a die-cut and anything set into one is 4 (wells, pockets, windows, meters, inputs, on-screen keys), a part is 8 (bezels, seven-segment panels, module frames, dropdowns, controls), and a panel is 16 (cards, modals); the in-between sizes are gone across the app, and a moulded keycap keeps the design's own corner as the one exception. In a gang the two end caps bend a little toward the die-cut's corners, twice the cap's own radius, while the corners between keys keep the cap's, and each cap carries the hole's dark rim so the floor between keys reads as a cut rather than a lit band; a seated cap keeps half its shadow so the gap beside it never lights up. A key bank is machined a pixel closer than the plate's other wells, at its edges and between caps, and its keys stand two pixels taller for it; the hole's lower lip is the plate's own hairline, not a bright rim. The legends' print, fonts and inks are unchanged. The four keycap drawings the kit used to stretch are retired; the caps are the stylesheet's now, drawn from the community skeuomorphic-button design.
- Reading mode. An ABC key before the colour knobs latches a parallel print of the companion screens for readers who find the pixel voice hard, dyslexic readers among them: the screens print in GC Basic Inktrap Mono in two weights, in mixed case everywhere the screen printed capitals: medium names things (a sender, a title, the selected row) and light carries the body of every message, the times and previews, and the unselected list rows; set as cut, no tracking, in a measure of about sixty-six characters; sender names small and dim, a caption under the text, never boxed; a tagged name in the text prints blue on both screens, pixel voice and reading alike, and the marks borrow the indicator lamps: sent and delivered checks and repeat counts in the green, an unconfirmed delivery in the yellow, a failed send in the red, the marks beside a time that sits flush at the far edge on every row, a local row reading time then marks from the left with its name at the right; a full line between senders and only a breath within a run, the time at the far edge of the stamp line where the keys take its place on hover, each message's text on a hinted full-width shell of the display ink, ruled along its top with the date divider's line so the stamp above reads underlined, the text indented behind a right-angled chevron the way a terminal marks a line, a hash channel's hash slanted, the open row on the same hinted shell, the unread count a square chip on a hinted fill with a dull number, the radio settings as highlighted text at the right of the name line, all of it recoloured by the knobs; every hover on the screen snaps, no fade and no delay; the rosters on taller rows; and a calm panel with no grain or lamps behind the text. Silk and seven-seg keep their own faces. Peers still print from the left and you from the right. The setting persists. A press returns the pixel voice.
- The send key on the screen is a momentary action: no pilot lamp, seated close to the count, and a brighter fill under the hand that snaps. `OsdButton` learns `lamp={false}` for keys with no state to show.
- The message field knows the radio's wall. MeshCore carries 160 bytes of text, counted in UTF-8 bytes rather than characters, and a channel message spends your name and a colon of it before you type; the composer stops the draft there on every route in, typed, pasted, a reply or a mention, cutting on a whole character so a flag or a family never breaks, and shows the bytes left beside the field, in the warning lamp within twenty and the fault lamp at the wall.
- A repeater's signal bars in the contacts list stand on the open screen in their signal colours, no box behind them, with an unlit bar ghosted in the ink.
- The blue keycap takes the system blue's hue, sunk to the depth of the red and amber faces, in both modes.
- The parts kit's push button comes round, or square and latching for a mode: the ABC key is the first square one.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.368] - 2026-09-03
### Changed
- The hue fader is three knobs. HUE, SAT and LUM sit as one gang on the companion plate's foot, each a knurled cap on a spindle sweeping between two end dots; the cap turns under a light that stays in the room, and a push button at the foot's right returns the board to amber. HUE and SAT set the display ink every readout on the board shares, in OKLCH at the amber's own lightness: hue once around the wheel, saturation from grey to the most colour the display can show there, measured against the widest colour Display P3 carries so every setting reaches the screen as written, wide-gamut where the display allows and never mapped toward grey. LUM is the screens' brightness: the white, the coloured outlines, the emoji and the ink dim together as one lit surface, down to a dim screen you can still read and never to black. The three settings persist across sessions and follow you to every page; at the amber they ship at, the board's own amber stands.
- The companion screen's glass tint is a quarter dimmer.
- The parts kit gains the knob and the push button, and loses the fader.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.367] - 2026-09-03
### Added
- A hue fader on the companion plate. The display ink every readout on the board shares, the amber of the seven-segment counters, the LED screens, the pixel text and the terminal cards, is now a setting: a fader in the plate's foot sweeps it from a violet at the edge of ultraviolet to a red at the edge of infrared, with the shipped amber at rest. The sweep is written in OKLCH at the amber's own lightness and chroma, so every stop is the same phosphor at another wavelength and a wide-gamut display renders the colours sRGB cannot. The rail fills in the ink it is about to set. The setting persists across sessions and follows you to every page; a key beside the fader returns the board to amber. On a phone the fader keeps its place in the foot.
- The parts kit gains the fader: a keycap knob on a tick rail, the travel behind it filled in the display ink. The specimen route shows it.

### Fixed
- The README said a companion radio is attached. A companion is created on the repeater and speaks to the mesh from it, and the text now says so.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.366] - 2026-09-02
### Added
- The messages page is now an instrument. The companion sits on a plate in the map's family: a companion selector with an add key, a red flood-advert key and an amber zero-hop key, seven-segment channel and contact counters, an outbound queue meter, and a status pocket with LINK, RX and TX lamps and a linked/unlinked annunciator. The plate is fastened; the screen inside it is an amber LED window.
- The conversation prints on that screen in the display voice. Each message is a log line: the sender as a boxed label strip in the new caption face, the time at the far anchor, the body in the pixel face, and the delete and reply keys on the stamp line. Your own messages print from the right under the companion's own name. A run from one sender collapses to continuation rows; a new sender opens a full line; a new day rules the screen. Mentions print off-white, emoji print in their own face untinted.
- The roster is printed on the same screen. Contacts and channels are columns with on-screen header keys (Find and Fold, Import and Add) that fold to icons as the column narrows. Identities are square boxes lined in the identity's colour with the glyph in amber; room servers and repeaters are ink boxes; unread tallies print bracketed in the caption face; signal bars are amber at the column's edge, with the unlit bars ghosted.
- The screen has its own scrollbars, its own pixel loader that blinks a program while it works, square insets with one shared 14px grid, and glass over the timeline for the head and the composer. Bot cards, the detail page, the context maps and their overlays are all re-printed for the panel: no gradients, no rounding, amber labels.
- The outbound queue is metered. Messages pending or retrying on the companion light the QUEUE bar, and the TX lamp holds while anything is in flight; RX strikes on every message that arrives; LINK goes green on a good link.
- The plate fits a phone. Below the deck width the gangs share rows; on a handheld the bank wraps into three rows with the queue as a standard bar, and every key stays in its well.
- The parts kit gains an LED screen stock, a jumbo meter die that fills a well in both axes, a pixel loader, a folding legend for on-screen keys, and the caption face (Home Video, CC0). The specimen route shows each.
- The README shows the console: a features table, a product tour with current screenshots for the map plate, packet throughput and filters, the Wire Inspector, the noise floor and its anomaly tuning, detected public channels, the companion instrument, host telemetry and local network I/O, and a longer troubleshooting section.

### Fixed
- The shell chrome above and below every route is halved, giving the instruments the height back.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.365] - 2026-09-02
### Added
- Reply to a message from the companion chat. Right-click a message, or hold it on a touch screen, and a menu offers Reply; hovering a message shows a round reply key beside its bubble, in the bubble's own surface ghosted. Either addresses the composer to the sender with the mention syntax the channel already understands, `@[Name] `, and puts the cursor at the end so typing continues the reply. Replying to the same sender twice does not stack; replying to someone else re-addresses the draft and keeps its body.

### Fixed
- The messages page fits any viewport and the composer never leaves the screen. It used to size itself with viewport arithmetic and a 400px floor, so on a phone the composer sat under the browser's bars, and on any short window the page had to be scrolled to type. The page now fills the space under the header and only the timeline scrolls, at every size from a landscape phone to a large display. On a phone, while a conversation is open, the header's control rows step aside so the timeline has the room; the back arrow brings them back with the list.
- At the wider breakpoints the chat card ended one gap short of the right gridline that the header and the counters sit on, because the closed detail panel still cost the row its gap. It ends on the line now, open or closed.
- A message's time no longer stacks its meridiem on a second line under the avatar. It is smaller and tighter, and always one line.
- The channel count in the companion header follows every add and delete. It read a count the backend had reported when the companion list was last fetched, so it stood still until the next background poll while the contacts count beside it moved at once. It now reads the live channel list, which both transports keep current; a test pins that on each.
- A trace's "good" tier and the aurora widget's quiet-to-moderate band drew in a colour that was never defined, so they rendered colourless. The palette gains lime, the step between green and amber, in both sRGB and Display P3.
- The packet analyzer's node filter now treats an unconfident source resolution as the best guess it is. It matched the guessed node exactly, which silently dropped every packet whose guess landed on the wrong twin among nodes sharing a prefix; an unconfident resolution now matches on the packet's source prefix, as the pipeline rules always said.
- If the browser's saved region settings cannot be read, channel sends are blocked to protect an override, and there was no way out short of clearing site storage by hand. The Regions dialog now offers a reset that discards the saved regions on that browser and lifts the block, and says what it discards first.
- Display P3 colours apply again. The wide-gamut palette was declared before the sRGB palette in the cascade at the same specificity, so the sRGB values won on every display and the P3 layer had never taken effect. The override now outranks the declaration, and every token derived from the palette follows it.

### Compatibility
- No repeater database change and no schema migration.

## [0.9.364] - 2026-09-02
### Fixed
- A hashtag channel joined from the console is now the same channel everyone else has. The protocol derives a `#channel` key as the first 16 bytes of SHA-256 over the name as written; the console used to lowercase it and then silently strip every character outside letters, digits and hyphens, collapse hyphen runs and trim them, so any name carrying an underscore, a dot or a doubled hyphen was hashed as a different name. The device accepted that key, every send on the channel reported success, and nobody else could read it. The name is now hashed as typed, trimmed and lowercased, which is what the protocol document and every open MeshCore client agree on; `#test` derives to the documented `9cd8fcf2…`. The decryption worker shares the same rule instead of carrying its own copy.
- Setting a transport-key region from the Transport Key tab failed on every attempt since July, logged only as a console warning. The region helper returned the full 32-byte digest while the frame writer required the firmware's 16-byte key. The helper now returns the 16-byte key, as `TransportKeyStore::getAutoKeyFor` stores it and as openHop derives it.

### Changed
- The Transport Key tab no longer reports "Global (no filter)" for a state it cannot know. The device does not report a transient override, so until one is set or cleared on this connection the tab says so. It now also reads and shows the device's persisted default scope, which applies to every channel send when no override is set and can be set by any client on the Frame link.

### Compatibility
- A hashtag channel added from an earlier console under a name that the old rule altered keeps the old key on the device. Remove it and join it again to take the protocol key. Names made only of lowercase letters, digits and single hyphens were never affected.

## [0.9.363] - 2026-09-02
### Fixed
- A PATH payload is an encrypted envelope, not a hop list. The console read its first byte as a path length and the bytes after it as a route, which is the packet header's layout rather than the payload's; the repeater's own handler decrypts the remainder with a per-client shared secret before any hop list exists. The console holds no such secret, so it now reports what it can genuinely read — the destination and source hashes, the cipher MAC, and the size of the encrypted remainder — and says the route is encrypted. The packet detail, the byte breakdown, the diagnostic export and both observatory views no longer show a fabricated route or announce "0 hops" for a route they cannot see. A payload too short to hold an envelope is marked malformed instead of shown as empty.
- A companion's paused and ever-connected flags were stored under its name, so when a name was rebound to a different identity the new one inherited them: a companion the operator had paused stayed paused for whoever held the name next. Both are now scoped by public key, as the transport preference already was. Evicting another client, the one destructive action on that page without a confirmation, now asks first and names the peer it would disconnect.
- Five Configuration dialogs each drew their own overlay. They are one dialog now, so Escape, focus trapping and a labelled heading behave the same in all five, each has the close control it lacked, and dismissing by backdrop click no longer leaves a token name, a created token or an editing region stale.
- The tooltip that follows the cursor over the mesh guard chart cost two renders per mouse move in every component listening to it. Moving it now costs none. The anchored tooltip gained the accessible description it never wired, and lost a scroll-offset adjustment that was wrong on a fixed-position element.
- Switching theme rewrote a display attribute with the value it already had, and every live chart redrew for it. It no longer does. The socket also sent its token twice, once in the connect query and once as a frame the repeater has never read; the frame is gone, the query stays, and that is what keeps the socket authorized.
- Status that was carried by colour or motion alone — two live-dot modes, a widget's status word, the observatory's computing lamps — now carries text, visible or read aloud, so it survives a screen reader and a monochrome display.
- The log facet bank scrolled sideways when the plate ran out of width. It breaks onto rows now, at the kit's pitch, and the log register's screen well has its seat back.
- The terminal's own help lists what `get` and `set` actually handle: `af` under Timing, `flood.advert.interval` under Repeater, `duty.max` and `repeat` as get-only, `prv.key` as set-only, and no `log` parameter that never existed. `get mode` and the in-app guide admit `no_tx`. The Configuration page stops printing a dashboard path that is only true of a source install.
- The terminal wordmark existed twice and one copy sat off its grid; there is one now. Compact node info no longer overflows its container.
- The distribution repository's Build Validation had failed on every run since 0.9.362, because two installer-test steps ran a script that repository does not carry. They are guarded now, and a gate keeps any step from running a private script unguarded.

### Changed
- The distribution repository carries only what serves its README. The sync copies the README's screenshots by allowlist and nothing else under `docs/`, checks its own tree immediately before pushing, and the release lane runs the same gates before anything is tagged. Planning records and wireframes that had been swept along are no longer published. The release archives were never affected; they have only ever carried the built dashboard.
- The map's overlay controls are the console's own OSD buttons, with a real pressed state, in place of tinted generic buttons.
- Five components that re-rendered on any store change now subscribe to the fields they read. Two places that classified nodes on their own now use the one classifier, which also recognises an alias they missed.
- The installer guide, the README and the release guide were corrected against the code and against upstream's current layout: openHop Repeater migrates the pyMC-era paths itself on install and upgrade, so no console change is needed for that.

### Compatibility
- No repeater database change and no schema migration. The companion flags carry over once from their name-keyed form on first read, so an upgrade does not silently unpause a companion; clearing a flag afterwards drops both.

## [0.9.362] - 2026-09-01
### Fixed
- The installer wires the dashboard in on a Repeater that still runs the pyMC-era layout. `manage.sh` detected `/opt/pymc_repeater` and the `pymc-repeater` service but patched, reported and hinted at `/etc/openhop_repeater/config.yaml` only, so on a system upstream had not migrated the dashboard was installed and never reached, and the manual fix it printed named a file the running service does not read. The config file is now resolved the way the service already was: the openHop path first, then `/etc/pymc_repeater/config.yaml`, and when neither exists the expected path follows whichever Repeater is installed.
- `manage.sh uninstall` clears `web.web_path` when it still points at the dashboard, so the Repeater falls back to its own UI instead of serving a directory that no longer exists. A value set by hand to something else is left alone and named. Without `yq`, the exact command is printed.
- The installer and the publishing workflow address the distribution repository by its current owner rather than through a redirect.

### Changed
- The installer is now under test: fifteen contract tests run it against a sandboxed filesystem in every Repeater layout, with the real `tar` and `yq`, on every push. Nothing in the dashboard itself changed in this release.

### Compatibility
- No repeater database change and no schema migration. Existing installs pick up the new installer on their next `manage.sh upgrade`, which refreshes the script before it does anything else.

## [0.9.361] - 2026-09-01
### Added
- The map is a finished instrument. The screen sits in a brushed faceplate fastened at its four corners with Torx screws, with vents, a legend under every key gang, a hop analyser standing beside the picture, an RX lamp that flashes on receive, and a serial line on the foot.
- The local repeater's name is on the chassis, on an embossed tape label stuck across the frame's bottom edge and bent over it, set in the Impact Label Reversed face (shipped with its licence). The label maker cannot press an emoji, so a name like "Baldwin ⚡️ Observer" embosses as BALDWIN OBSERVER.
- Stickers on the plate: a smiley, an alien, and a holographic MESHCORE die-cut, pinned beside the pilot lamps in the reference composition. Each plate width finds its own place for them — the grille under the analyser on a console, the free spans of the masters' row and the key row on a phone — and they step aside rather than cover a control.
- The screen's glass carries a photographed room reflection under the glare, at its own alpha, above the vignette and everything the screen draws.
- The readout bank's seven-segment tallies grow with the plate: three dies, chosen by the room the rail has, so a wider plate gets taller digits rather than more empty rail.

### Changed
- The glare on the screen steps back now that the room lies under it: the four light passes sit at 40% of their former amplitude and the edge lamps at 60%, so labels under the top of the glass read better.
- Light mode: the bank's wells are pockets cut into the plate, a shadowed grey rather than black, while every key keeps its black die-cut housing, one key wide or two or three. Compact silver keys take the same light finish as the full-size ones beside the screen. Dark mode is unchanged.
- The tape bends over the frame's edge on a shoulder rather than a fold, and its embossed letters are the face's own — no effects on top.
- Stickers carry only their own baked shadow; the foil die-cut throws a soft white halo where it overlaps the plate instead of a shadow.
- No tallies on the phone's class keys.

### Fixed
- Channels that share a hash byte are all kept. The discovery cache used to hold one channel per hash, so the newest discovery replaced the others and a channel could silently stop decrypting. Firmware keeps every channel under a hash and tries each; the console now does the same.
- Legacy Frame lists channels up to the same 40-slot guard the Companion API uses on companions that do not report their capacity. It stopped at 16, so slots 17 to 40 on an older device were never listed over Frame.
- An imported hashtag channel's label and key are derived from one source, so the name written to the device can no longer disagree with the key it was derived from.

### Compatibility
- No repeater database change and no schema migration. Legacy Frame and Companion API v1 behave as before apart from the corrections above.

## [0.9.360] - 2026-09-01
### Fixed
- Adding a companion works again. Opening companion configuration replaced the page with "Page failed to render", so the main way into the feature has been unusable since dual transports landed in 0.9.347.
- A single unreadable companion catalog reply no longer ends the session. One bad response read as "this companion was removed": the connection dropped, cached contacts and history were discarded, the saved selection was deleted, and getting back required picking the companion again by hand. A missing entry now has to be confirmed by a second reading, while a changed identity key still fails closed at once.
- Legacy Frame explains its failures instead of swallowing them. Eleven actions — status, telemetry, repeater login and logout, path reset, contact removal, channel changes, ping and others — said what went wrong on Companion API and failed in silence on Frame.
- "Set Path" in the contact menu opens the path editor. It used to select the contact and stop, leaving the one control named after the action as the only route that did not reach it. It now appears only on a connection that can set a path.
- The chat archive no longer claims a message was delivered when it never found out. A channel message interrupted by a reload came back wearing a delivery tick; a direct message came back spinning forever. Both now read as unconfirmed, which is what the record actually supports.
- "Connect anyway" takes the Frame listener only when Frame is the connection in use. Answering it from a Companion API session used to move you onto the listener you had chosen to leave free.
- A malformed reply from the repeater is reported as a mismatch rather than as "temporarily unreachable" and retried forever.

### Changed
- Repeat counts on Companion API come from the repeater's own tally and the message's exact packet hash. The console previously inferred them by matching a message to a capture on its text and a thirty-second window, and kept doing so even on a connection that could answer exactly.
- Both connections describe a failure in the same words and say which kind it is: refused, outcome unknown, connection dropped, or unsupported here. Anything whose outcome is unknown is never repeated on its own, and a read that times out reports a dropped connection rather than an uncertain result.
- The per-channel region check runs only while a channel conversation is open and asks a given connection once. It previously ran on every visit to the page and every reconnect, whether or not a channel was ever opened.

### Compatibility
- No repeater database change and no schema migration. Legacy Frame and Companion API v1 behave as before apart from the corrections above, and saved per-companion connection choices are unaffected.

## [0.9.359] - 2026-09-01
### Added
- The map is now a hardware instrument. The screen sits in a machined faceplate with a silkscreen identity and pilot lamps, a key cluster beside it, and a readout bank below, and each breakpoint gets its own plate rather than a reflowed copy of the desktop one.
- Selecting a node opens a shelf inside the screen instead of a panel floating over the map. It switches on in place like a tube rather than sliding in, and moving to another node rehydrates it instead of closing and reopening.
- Display modes and class filters are banded across the top edge of the screen in the display's own amber-on-glass voice. On a handheld the five class keys share a single row.
- The key is rooted to the bottom edge, collapses when you want the map back, and never runs past two rows. It lists only what the map can actually show — each class appears once there is one on screen.
- Zero-hop edges follow the class filter: with RPTR, COMP, ROOM or HUB selected, only that class's direct edges are drawn. ALL is unchanged.
- The screen wears real glass — four graduated light passes taken from the design file, edge backlight lamps shared with the I/O scope, and a CRT vignette. The whole reflection is baked to a single image, so it costs nothing while the map is panned.
- Basemap place names read in the display's own ink: keycap red on the dark map, Casio LCD grey on the light one.

### Changed
- Keys latch. The master key is a red cap, the view cluster is square, and toggles behave as push-push hardware instead of momentary buttons.
- Everything inside the screen speaks one pixel voice — hop, repeater, backbone and room chips included. Node markers are square dies, and the key reads as a readout rather than a caption.
- The node shelf and the edge-hover reading share one readout grid, so a link and a node are measured on the same rule.
- The screen's corner rounding matches the rail directly above it.

### Fixed
- Live Trace renders again.
- Every hub wears its ring, including hubs that have gone stale.
- The readout bank takes a real track in the instrument panel, the handheld plate holds together, and the deck plate's lower row no longer leaves a dead gap.
- The 3D key can be switched off again.
- Scalability benchmarks no longer flake under suite load.

### Removed
- The deprecated wardriving coverage overlay, along with the map controls that drove it.

## [0.9.358] - 2026-08-28
### Added
- Channel headers now have a Regions button for adding, editing, removing, and selecting an outgoing region override. A green outline and checkmark indicate an enabled, supported override.
- Scoped outgoing messages show their original `#region` before the repeat counter and a green bubble outline. Local annotations survive reloads in both Frame and Companion API modes.

### Fixed
- Removing the selected region can be saved to return to the companion default, and edit cancellation is clearly separate from canceling the whole dialog.
- Region sends preserve their original scope on safe retries and never silently fall back to an ordinary send. Uncertain Frame sends are not automatically retried.
- Outgoing Companion API channel messages retain text before a colon instead of treating it as a sender prefix.

### Compatibility
- Per-message regions require a backend that explicitly advertises support. Frame support is proposed in [openHop Repeater PR #417](https://github.com/openhop-dev/openhop_repeater/pull/417); the Companion API fork includes the corresponding scoped endpoint. Ordinary sends remain compatible with older backends.
- Region choices and annotations are local to this browser. History without original region metadata remains unmarked. No repeater database migration or shared radio-setting change is required.

## [0.9.357] - 2026-08-27
### Changed
- Startup now requests a real 12 hours of packet history instead of 24 hours. Saved shorter windows are preserved; longer windows remain available on demand.
- History loads use smaller, sequential pages, and packet caching and topology analysis do less repeated work on busy meshes.

### Added
- The Packets Received chart shows a shimmer while loading, with a compact "Slow? Load 3hrs only" shortcut in the chart and sidebar progress display.
- Switching to 3 hours, 1 hour, or 20 minutes cancels the larger browser request, reuses history already received, and requests only missing coverage.

### Fixed
- Cancelled or failed history loads and topology jobs no longer leave stale progress or overwrite newer selections. Deep Analysis also reports completion and errors consistently.
- Large topology histories no longer fail when processing extensive ghost-node observations.

### Compatibility
- Existing repeater versions remain supported. Stopping database work on the server requires the cancellation API proposed in [openHop Repeater PR #416](https://github.com/openhop-dev/openhop_repeater/pull/416); until that backend update is installed, cancellation stops the browser request but cannot guarantee that an active database query stops.
- This Console update does not change the repeater database or require a schema migration.

## [0.9.356] - 2026-08-25
### Added
- The TUI Kit is now the application-wide instrument system. Manufactured keycaps and toggle keys, precise wells and filler plates, status lamps, seven-segment readouts, pixel screens, annunciators, readout racks, illuminated bar meters, scope charts, faceplates, and nameplates share one portable component vocabulary across dark and light modes.
- `/tui-kit` is the living specimen and migration reference: it now includes the canonical component sheet, interaction lab, grammar atlas, and a source-linked coverage ledger for all 27 application routes.
- Displays behave like energized hardware. P3-tuned lamps and LED bars use restrained optical scatter, cascaded level changes, bright strike and release edges, while seven-segment dies retain ghost segments and fast per-segment decay. Reduced-motion users receive the same final state without decorative movement.

### Changed
- The complete System workspace now uses the TUI hardware grammar. Resources, Sensors, Logs, Storage, Recovery, Diagnostics, and Terminal share consistent screen typography, instrument headers, compact text keycaps, semantic readouts, and responsive control banks without removing their existing actions or data.
- System Resources is organized as a telemetry console: compact CPU and memory channel controls, independently switchable frozen readouts, an analogue I/O scope, illuminated envelope meters, and pixel-aligned process and platform screens replace generic dashboard furniture.
- System Logs keeps search, level and logger controls beside the stream they affect. Its compact summary, pass/mute channel registers, and log feed now use the same readable terminal hierarchy at desktop and mobile widths.
- Card headers and application controls use the restrained Oswald silkscreen voice; Unifont remains confined to digital screens and inputs, while molded identity typography is reserved for page-level character.
- Shared confirmation dialogs now use TUI screen, key-well, and keycap patterns, including caller-specific action legends rather than generic button copy.

### Fixed
- Storage vacuum now asks for confirmation before running, reports its work through an illuminated key state instead of a spinner, and preserves the table-management workflow in a compact mobile-safe console.
- Resource channel keys, process sort keys, page-header actions, and their seven-segment companions use correctly sized shared wells; disabled channels ghost and freeze their displays instead of continuing to show live values.
- LED and seven-segment edge effects are lightweight, interruptible, and reduced-motion safe, avoiding the performance regression caused by long per-segment fades.
- Confirmation actions such as Delete and Replace Key once again keep their specific visible labels, so destructive and credential workflows remain unambiguous.

## [0.9.355] - 2026-08-20
### Added
- The System page is rebuilt as bench hardware. A new instrument kit — seven-segment displays, annunciator lamp banks, LED bar meters, pixel marquees — replaces the generic cards: LOAD / STORAGE / HEAT / I/O lead the page as segmented readouts, CPU and memory draw on an amber dot-matrix telemetry face with channel-enable keys and an uptime counter, thermals and reserves read as ganged gauge modules with capacity towers, and the process table sits behind the same glass. Light mode renders the whole board as a vintage beige machine — warm molded plastic around screens that keep honest LCD physics (dark wells stay dark; graph faces trade amber phosphor for printed LCD ink).
- The I/O card is an analogue throughput scope: a split TX/RX face whose thin trace rolls continuously right-to-left like paper under a fixed pen, with edge-lit glass, each channel's peak engraved on the face, and a since-boot odometer. Drawn ink is locked — a range change scales new ink only, so the trace never re-flows behind you.
- Messages · Companion: delete a message from your local history. A trash key surfaces in the row's corner on hover — bottom-right for incoming messages, bottom-left for your own — behind a "Delete Message?" confirmation. Removal is local to this Console: mesh recipients keep their copies.
- Page titles wear a C64-style faceplate: a molded nameplate lozenge riding a band of machined grooves, set in a new display voice.

### Changed
- Every page header follows one fixed anatomy: identity on the left, global page controls (settings, expand, refresh) in the right corner, the workspace tab rail on its own row, and page-content controls on a context rail beneath it. Nothing trades places between pages or breakpoints; on phones the corner controls drop to a fixed second deck instead of wrapping.
- The workspace tab rail is a hardware key bank: rigid die-cut keys that fill the rail edge-to-edge and hold their size as you move between tabs — the chrome never shifts underfoot.
- Header furniture shares one molded finish: selectors, advert keys, refresh, and status chips are all pressed from the same lozenge-and-track die, built purely from the house surface tokens.
- Dialogs hold still. Every modal anchors by its header at a stable position and size — switching tabs or expanding sections inside a dialog no longer moves or resizes the frame. On phones, sheets bind to the visible viewport so the keyboard can't hide the actions, the body scrolls internally, and swipe-to-dismiss lives on the header.
- Companion configuration reads in half the words: the connection-mode chooser is now a single settings row that expands on demand — and opens itself when the connection needs attention.
- Configuration's find-a-setting search and Expand all / Collapse all share one rail beneath the tabs, with the bulk actions as proper control surfaces.

### Fixed
- The CPU/memory telemetry chart hydrates like a strip chart: from the very first sample, data prints at the right edge and grows leftward at a fixed pitch. It no longer stretches a young buffer across the whole face and re-compresses on every poll for the minutes the window takes to fill.
- Header buttons on Client Access, System Logs, and Messages · Manage no longer render as ghost outlines — a paint-order bug was drawing the title's grooves above them.
- Charts reliably follow their container when it shrinks instead of holding a stale wider width.

## [0.9.354] - 2026-08-18
### Fixed
- First taps land reliably on touch devices. Packet History rows in duplicate groups or carrying trace tags — and chart legend entries — previously swallowed the first tap on iPhone/iPad (Safari consumed it as hover intent), needing a second tap to act. Hover-driven highlighting is now mouse/trackpad only, so every tap counts.

## [0.9.353] - 2026-08-18
### Added
- Configuration at a glance: every module is a collapsible bar that summarizes its key values while closed, grouped under Device / Network / Access & Security / This Console headings, with Expand all / Collapse all and a desktop section rail that follows your scroll. On phones, modules start collapsed so the page opens as a table of contents.
- Find a setting: press `/` and type — matching rows light up while everything else dims (nothing hides), matching modules open themselves, and Esc clears. Related settings cross-link with a jump-and-flash locator.
- Tap the bunny in the mobile header. Go on, tap it.
### Changed
- Module editing commits from a bar at the module's bottom edge that stays on screen while you scroll a tall module — Save and Cancel never clip at any width.
- Node Info shows each identity as its own two-line row (name, then role and full-width ID) and scrolls internally past five rows, so large fleets never stretch the page.
- API access (CORS) moved out of App Settings into its own module under Access & Security.
- The header bunny faces right now.

## [0.9.352] - 2026-08-18
### Changed
- The time-range selector has one persistent home: the top-right corner of the page title, on every page and at every screen size (compact on phones). Dashboard, Statistics, Packet History, RF Health, and Map & Contacts each return a full row to content.
- Packet History's filters are now a collapsible bar on the Filters card itself — collapsed by default on phones with the Transport/V2 quick-toggles still usable, expanded by default on larger screens (and collapsible there for the first time). The floating filter button is gone.

## [0.9.351] - 2026-08-18
### Added
- Configuration modules now edit as one unit: an Edit action per card with a single Save/Cancel for every field. Read mode is a dense settings list, and editing swaps each value to an input in place — the layout never reshuffles between modes.
### Changed
- Mobile-first density pass across the app: display text, form controls, card padding, and board gaps all step down together on phones through one token system, so screens fit noticeably more without shrinking body text.
- Unit Display and the Configuration cards follow a single label-left / value-right row grammar; the Repeat and Duty Cycle switches share one row.
### Fixed
- Mobile overflow collisions: card-header chips no longer clip at card edges, badges never wrap mid-content, widget status chips wrap below their value, and the Link Quality radar's zoom controls moved to a full-width band below the chart on phones instead of overlapping it.

## [0.9.350] - 2026-08-18
### Added
- In-app release notes: tap the version badge in the sidebar or mobile header for "What's new" — the current release's notes plus full collapsible history, bundled with the build so it works offline. A small dot marks unread notes after an upgrade.
- GitHub releases now publish each version's changelog section as the release notes, and CHANGELOG.md ships with the distribution. Bots can follow `releases.atom`, the `releases/latest` API, or the raw changelog — see "Following releases" in the README.
### Changed
- The release pipeline guarantees a changelog entry for every release (auto-generated from the release note when none is hand-written) and verifies the published tree before every push.

## [0.9.349] - 2026-08-18
### Added
- Map & Contacts are now one page: the contacts table sits below the map, and clicking a located contact flies the map to that node and opens its details. Old `/contacts` links redirect.
- The node detail sheet on phones can be dismissed by dragging its handle down.
### Changed
- Page headers use a structured grid: title, actions, controls, tabs, and status hold the same position on every page per breakpoint, with a compact headline on phones.
- Map control surfaces (toolbar, zoom, legend, tooltips, detail panels, replay timeline) moved onto a structured overlay grid — surfaces no longer collide, and the legend starts collapsed on phones.
### Fixed
- The openHop bunny mark now shows in the mobile header at every phone width (Pro Max sizes previously fell on the text-wordmark side of a breakpoint).

## [0.9.348] - 2026-08-17
### Fixed
- The login page's electric-arc burst plays again: the animation asset had been flattened to a single blank frame during an optimization pass. Rebuilt as the full 36-frame sequence, preloaded so it never races the network, and replayed when the page is restored from the back/forward cache.

## [0.9.347] - 2026-08-17
### Added
- Dual Companion transports: the legacy Frame/WebSocket path and the new Companion API (REST + SSE) work side by side, with per-identity Auto / Companion API / Legacy Frame modes and capability-aware controls.
- Messages → Manage: one surface showing live status for companions and room servers with inline configuration, plus manageable instances on the Client Access page.
- Companion selector with an add pill, and Companion / Room Server / Manage workspace tabs.
### Changed
- Messages performance overhaul: the contact list and message timeline are virtualized, so large meshes (1,000+ contacts) scroll smoothly.
### Fixed
- Manage and Client Access no longer stall on loading shimmers; mobile header controls wrap into view instead of hiding in a horizontal scroller.
### Security
- The public distribution sync now scrubs the motion-plus token before anything is published and verifies the outgoing tree contains no secrets; build workflows read the rotated token secret.

## [0.9.333 – 0.9.346] - 2026-07-08 to 2026-08-08
### Added
- Redesigned sign-in experience with the openHop identity, responsive animation, and multi-browser password-manager support.
- HOWL bot response widgets with refined parsing, improved companion tools and packet controls, and a Ko-fi support link.
### Changed
- Navigation, Dashboard, and mobile UX refresh; clarified packet table hierarchy; refined System Resources design; dashboard history aligned with the companion protocol.
### Fixed
- Companion frame reconnection, ownership handoff, and stale-client handling hardened across several releases; Companion Protocol v13 compatibility and Repeater API reliability fixes; centralized unit display preferences; dashboard chart hover correlation; dev API target detection by local subnet.

## [0.9.332] - 2026-07-07
### Added
- GPS globe zoom control (button-only) and adaptive packet-prefix conflict detection.

### Changed
- Rebranded update-modal repeater label, aligned ASCII logo rows, and removed leftover parity routes/help text from in-app help and terminal help output.
- Polished packet-prefix and radar zoom UI; prefix conflict health now reflects actual detected conflicts.
- Dashboard chat activity preview now stays in sync with the chat modal.

### Fixed
- Companion inline maps no longer get stuck/frozen after load.
- Wardriving inline map bounds hardened against bad points, and anonymous wardrive coordinates are now skipped instead of skewing the map.
- CI build-validation workflow no longer fails on pull-request runs due to an invalid artifact name.

## [0.9.294] - 2026-06-30
### Added
- openHop default WebUI parity routes and screens: first-run setup shell, GPS diagnostics, RF Health, Sensor Readings, CAD calibration, Observer/MQTT broker management, Policy Engine, Database, Memory, Backup/Restore, Radio Hardware, Room Servers, Companions, and compatibility redirects for legacy/default route names.
- openHop branding pass across login, terminal boot art, terminal prompt/help, powered-by footer, sidebar/app copy, and deployed artifact metadata.
- Manual GitHub Actions UI artifact workflow for branch-built Console deployments, including `VERSION`, `BUILD_SHA`, and `BUILD_REF` files in downloaded artifacts.
- Radio Hardware backend switcher with active radio type selection, serial/USB/TCP fields, board preset quick-apply, modem host/IP display, SX1262/CH341 settings, LoRa parameter editing, and restart-required handling.
- Configuration password-change form using the Repeater auth endpoint with inline validation and normal form-error handling.
- Packet Observatory, Signal Lab, Sources/MQTT views, SPAMGUARD/flood-loop diagnostics, CRC overlays, packet-health scoring, and advanced packet filters for transport/version/node analysis.
- MeshGraph data-range picker and expanded topology/load controls for large datasets.
- Public-channel history export and expanded companion controls, including frame-server session awareness, pause/resume, browser-session lock copy, and mobile-friendly companion layout.
- Multi-byte MeshCore path-hash compatibility throughout packet parsing, topology, browser decryption, MQTT adapters, statistics, and diagnostic exports.
- GPS satellite diagnostics with receiver map, satellite globe, sky plot/table, live stream fallback, and invalid-coordinate hardening.
- RF Health mini-graphs and CAD calibration visual workflow with progress, best-threshold reporting, export, save, and restart prompt.

### Changed
- Repositioned Console as a static openHop Console overlay only: `manage.sh` no longer manages Repeater/Core lifecycle, installs, observability, or service operations beyond Console assets.
- Updated docs, README/help text, install/deploy wording, repo links, and runtime path references for current openHop Repeater naming while preserving compatibility identifiers such as `/opt/pymc_console/web/html`, `pymc_usb`, and `pymc_tcp` where the backend still expects them.
- Reworked Dashboard Chat Activity around decoded live messages, clearer decode status/progress, known-channel backfill, and bounded refresh-survival decoded-message cache.
- Simplified Chat Activity to avoid presenting raw encrypted GRP_TXT packet counts as decoded chat messages.
- Refined Policy Engine layout and copy, including rule/group preservation, action placement, beginner-friendly formatting, and object reference handling.
- Polished Radio Hardware parity by separating backend switching from LoRa parameters and keeping preset/summary views compact.
- Improved GPS layout, globe sizing, land rendering, and map/globe balance after parity testing.
- Tightened map, topology, and statistics UI around explicit empty states, invalid coordinates, prefix conflict width controls, and stable active-range counts.
- Improved update/version display, mobile companion layout, Safari/browser compatibility fallbacks, and high-throughput pipeline rendering behavior.
- Updated terminal and login ASCII artwork to use the same openHop wordmark without clipping.

### Fixed
- GRP_TXT packet rows and Dashboard Chat Activity now preserve decoded content across live packets, historical backfill, companion-message fallbacks, and channel discovery timing.
- Decryption pipeline no longer drops queued channel decrypts while busy and syncs inline-decrypted WebSocket packets into the chat feed.
- Contacts MapLibre ignores invalid latitude/longitude values instead of crashing or blanking the map.
- Map and topology statistics stabilize around invalid-coordinate filtering, active range calculations, and path-prefix width selection.
- Packet feed and pipeline reactivity bugs that caused freezes or stale arrays under high packet throughput.
- MeshGraph initialization and loader hangs.
- Terminal xterm initialization race caused by skeleton/ref timing.
- Safari compatibility issues around `requestIdleCallback`, `crypto.subtle`, `.at()`, and `AbortSignal.timeout`.
- Companion frame-server client sessions are no longer evicted while active, and auto-connect is gated when an external frame-server client is present.
- Sensor Readings render nested `hardware_stats`/`pymc_modem` payloads instead of showing raw JSON blobs or `n/a` for valid nested values.
- Memory diagnostics now match the default UI tracing workflow rather than acting like a one-shot snapshot.
- Login branding no longer clips the openHop ASCII wordmark and no longer uses stale pyMC footer/logo links.
- Radio Hardware switching preserves required SX1262 pin configuration after backend changes.
- Built production chunks avoid previous circular dependency, minifier, and cross-chunk React/reference failures observed in earlier builds.

## [0.9.293] - 2026-02-27
### Changed
- Move GRP_TXT decoded content pipeline to main thread for reliability

## [0.9.292] - 2026-02-27
### Fixed
- Channel name (`#channel`) missing from decryption worker output

## [0.9.291] - 2026-02-27
### Fixed
- GRP_TXT decoded content pipeline — sender names, channel badges, and decoded text now display correctly in packet list rows

## [0.9.290] - 2026-02-27
### Fixed
- MapLibre font 404 errors and API token endpoint routing errors

## [0.9.289] - 2026-02-27
### Fixed
- Remove `manualChunks` to eliminate circular chunk dependencies crashing production builds

## [0.9.288] - 2026-02-26
### Fixed
- Replace Terser with esbuild minification — Terser multi-pass was reusing variable names across libraries in the same chunk, overwriting React before the export statement

## [0.9.287] - 2026-02-26
### Fixed
- Merge `@tanstack/react-virtual` into vendor-core chunk — fixes `useLayoutEffect` undefined crash from broken cross-chunk React reference

## [0.9.286] - 2026-02-26
### Fixed
- Reset initialized flag on teardown so React StrictMode re-mount restores all polling (stats, packets, hardware)

## [0.9.285] - 2026-02-26
### Changed
- Production hardening — `fetchApi` timeout, interval leak fixes, bundle surgery, auth redirect, circular dependency fix, `useStore` decomposition, `PacketCache` tier consolidation, worker resilience, dead code removal, 160 tests

## [0.9.284] - 2026-02-26
### Fixed
- Link health popup dark mode color adjustment

## [0.9.283] - 2026-02-26
### Fixed
- Mobile sparkline loader update

## [0.9.282] - 2026-02-26
### Fixed
- Minor UI enhancements

## [0.9.281] - 2026-02-26
### Fixed
- Various UI refinements

## [0.9.280] - 2026-02-25
### Fixed
- Map controls finesse and minor UI fixes

## [0.9.279] - 2026-02-25
### Changed
- Noise floor chart trendline upgraded from median-SMA to LOESS algorithm
- Added trendline toggle to noise floor chart
- Minor UI refactoring and performance improvements

## [0.9.278] - 2026-02-24
### Added
- Link-quality visualization on Contacts map

## [0.9.277] - 2026-02-17
### Fixed
- Remove glow from pyMC ASCII logo on login page

## [0.9.276] - 2026-02-16
### Changed
- General improvements and refinements

## [0.9.275] - 2026-02-16
### Fixed
- Chart rendering fix

## [0.9.274] - 2026-02-16
### Changed
- UI polish, packet cache overhaul, sidebar refinements

## [0.9.273] - 2026-02-16
### Fixed
- Mobile breakpoint finessing

## [0.9.272] - 2026-02-16
### Changed
- Stability improvements

## [0.9.271] - 2026-02-16
### Added
- Interactive ASCII wave effect on login logo

## [0.9.269] – 0.9.270 - 2026-02-16
### Changed
- Link quality radar and sidebar refinement
- Stable build checkpoint

## [0.9.268] - 2026-02-15
### Added
- "All [X]" badge added to channel filter

## [0.9.267] - 2026-02-15
### Changed
- Nicer buttons for stats chart filters

## [0.9.266] - 2026-02-15
### Fixed
- Chart memory issues at 90-day / 350K+ packet depth

## [0.9.265] - 2026-02-15
### Fixed
- Miscellaneous fixes

## [0.9.264] - 2026-02-15
### Fixed
- Stack overflow fix for large datasets

## [0.9.261] – 0.9.263 - 2026-02-15
### Fixed
- Packet analyzer filter bug when in Total Scatterplot view
- Filtering glitch in analyzer

## [0.9.260] - 2026-02-15
### Fixed
- Time window selector above 14-day range

## [0.9.259] - 2026-02-15
### Changed
- Expanded time range options

## [0.9.258] - 2026-02-15
### Added
- Packet Analyzer filter panel
- TX delay overhaul
- Chart and polar UX refinements

## [0.9.257] - 2026-02-15
### Changed
- Adjusted global flood card UX

## [0.9.256] - 2026-02-15
### Fixed
- Transport Keys global flood policy now persists across navigation via localStorage fallback
- Toggle shows red indicator dot when deny is active

## [0.9.255] - 2026-02-15
### Fixed
- System stats page mobile breakpoint refinement

## [0.9.254] - 2026-02-15
### Changed
- Sign-in page animation polish

## [0.9.253] - 2026-02-15
### Changed
- Sign-in page color adjustments

## [0.9.252] - 2026-02-15
### Fixed
- Mobile breakpoint finesse

## [0.9.251] - 2026-02-15
### Changed
- Global horizontal padding adjustment for content area

## [0.9.250] - 2026-02-14
### Added
- Netherlands hash channel decoding (source: LetsMesh forum)

## [0.9.249] - 2026-02-14
### Changed
- CSS architecture improvements

## [0.9.248] - 2026-02-14
### Changed
- Packets and contacts list refinements

## [0.9.245] – 0.9.247 - 2026-02-13
### Changed
- UI cleanup pass — consolidating style classes, general cleanup
- UI improvements and refinements

## [0.9.244] - 2026-02-12
### Changed
- Style consolidation and neomorphic adjustments

## [0.9.243] - 2026-02-12
### Fixed
- Hello animation terminal fix

## [0.9.240] – 0.9.242 - 2026-02-12
### Changed
- Terminal header design iterations (v3, v4)
- Terminal intro singularity burst implosion ASCII animation

## [0.9.237] – 0.9.239 - 2026-02-12
### Fixed
- Terminal finesse and header styling

## [0.9.236] - 2026-02-11
### Added
- Terminal easter eggs

## [0.9.235] - 2026-02-11
### Changed
- Terminal shell continued refinement — command guide, easter eggs

## [0.9.234] - 2026-02-11
### Changed
- Terminal finesse

## [0.9.233] - 2026-02-11
### Changed
- Terminal cleanup

## [0.9.232] - 2026-02-11
### Changed
- Terminal shell — full parity, enhanced function

## [0.9.231] - 2026-02-10
### Added
- Upstream terminal parity with full pyMC mesh shell experience

## [0.9.229] – 0.9.230 - 2026-02-10
### Added
- Room Server full-TUI mode system

## [0.9.227] – 0.9.228 - 2026-02-10
### Added
- Room Server support — initial implementation and refinements

## [0.9.226] - 2026-02-09
### Changed
- Circular link quality radar for more accurate reports
- Preview: CRC error card (awaiting backend support)

## [0.9.225] - 2026-02-06
### Changed
- UI kit migration work

## [0.9.224] - 2026-02-06
### Changed
- Major UI/UX upgrade pass

## [0.9.223] - 2026-02-05
### Fixed
- Bug fix

## [0.9.222] - 2026-02-05
### Added
- `window.diagnoseBulkFetch()` debug utility

## [0.9.221] - 2026-02-05
### Fixed
- DNS rate limit safety buffer

## [0.9.220] - 2026-02-05
### Fixed
- Fallback sequential packet request for systems that choke on parallel chunks

## [0.9.219] - 2026-02-05
### Changed
- Reduced packet bulk pull parallelism and chunk size — optimizing for all devices including Luckfox and older Pis

## [0.9.218] - 2026-02-05
### Added
- Discovered contacts filter
- Enhanced chat decoding (faster, less processor-heavy)
### Fixed
- Dashboard hover state

## [0.9.215] – 0.9.217 - 2026-02-03
### Changed
- Gzip compatibility with `bulk_packets` endpoint
- Miscellaneous fixes

## [0.9.214] - 2026-02-03
### Changed
- Major improvements across the board

## [0.9.213] - 2026-02-02
### Changed
- Continued µPlot migration and refinements

## [0.9.212] - 2026-02-02
### Added
- Browser tab name shows `pyMC: <nodename>`

## [0.9.211] - 2026-02-02
### Changed
- Updated dashboard homepage charts — µPlot, stacked bar

## [0.9.210] - 2026-02-01
### Changed
- Chat activity dashboard card layout, style, and padding refinements

## [0.9.209] - 2026-02-01
### Fixed
- Avatar for chat activity card

## [0.9.208] - 2026-02-01
### Added
- Data motion — beta particle animation system

## [0.9.207] - 2026-02-01
### Fixed
- Miscellaneous fixes

## [0.9.206] - 2026-02-01
### Changed
- Gzip compression enhancement for bulk loading

## [0.9.205] - 2026-02-01
### Fixed
- Crypto/channel-keys build fix

## [0.9.204] - 2026-02-01
### Fixed
- Build static channel-keys fix

## [0.9.203] - 2026-02-01
### Added
- Public channel decryption with whitelist decode step
- Striped packet history loading indicator
- Chat activity dashboard card
- Design system work
- Sidebar noise floor property
### Fixed
- Bug fixes and performance enhancements

## [0.9.202] - 2026-01-30
### Changed
- MapLibre basemap light/dark mode cleanup
- Modular architecture refactor and performance enhancements

## [0.9.201] - 2026-01-30
### Added
- MeshGraph second view

## [0.9.200] - 2026-01-30
### Fixed
- MeshGraph performance optimization

## [0.9.199] - 2026-01-30
### Changed
- MeshGraph beta v2

## [0.9.198] - 2026-01-29
### Fixed
- Bundle Recharts with React to fix production initialization race

## [0.9.197] - 2026-01-29
### Fixed
- Auth flow fix

## [0.9.196] - 2026-01-29
### Fixed
- TypeScript chunk race condition

## [0.9.194] – 0.9.195 - 2026-01-29
### Added
- MeshGraph beta — Cosmograph v2 based mesh node graph with basic topology visualization

## [0.9.193] - 2026-01-26
### Fixed
- MeshGraph initialization attempt 2

## [0.9.192] - 2026-01-26
### Added
- Truncated hash display with copy in contacts list
- Simplified KDE layer
- Mobile-responsive partition toolbox

## [0.9.191] - 2026-01-26
### Added
- UI 2.0 — Packet breakdown modals, Trace Report, packet interaction
- Tailwind Plus integration
- Motion+ animation library

## [0.9.190] - 2026-01-25
### Changed
- Packet breakdown r2 refinements

## [0.9.189] - 2026-01-25
### Fixed
- Packet modal `toHex()` display

## [0.9.188] - 2026-01-25
### Added
- Motion Plus and Tailwind Catalyst implementation (round 1)

## [0.9.187] - 2026-01-24
### Fixed
- TypeScript errors cleanup

## [0.9.186] - 2026-01-24
### Changed
- More robust packet view modal (testing)

## [0.9.185] - 2026-01-23
### Fixed
- Chunked byte-to-string conversion for cross-device compatibility

## [0.9.184] - 2026-01-23
### Changed
- Theme transition finesse

## [0.9.183] - 2026-01-23
### Fixed
- API connection timeout errors not auto-recovering

## [0.9.182] - 2026-01-23
### Fixed
- Allow terminal output text to be selected

## [0.9.181] - 2026-01-23
### Added
- New light mode theme: Ribbon

## [0.9.180] - 2026-01-23
### Fixed
- `useStealthStore.getState()` subscribes to both stores using hooks at the component level

## [0.9.179] - 2026-01-23
### Fixed
- Upstream stealth injection for full local feature compatibility

## [0.9.178] - 2026-01-23
### Changed
- UI/chart enhancements and systemizing
- Stealth mode topology test

## [0.9.177] - 2026-01-23
### Changed
- More UI adjustments

## [0.9.176] - 2026-01-23
### Changed
- UI style adjustments

## [0.9.175] - 2026-01-23
### Changed
- Mobile refinements and color refinements

## [0.9.174] - 2026-01-22
### Added
- Expanded System Stats page — network use, memory, disk, and top processes

## [0.9.173] - 2026-01-22
### Added
- Hex/Base64 ID key converter in terminal for private key generation
- System colors for light/dark mode cross-compatibility — semantic and utility use decoupled from themes

## [0.9.172] - 2026-01-21
### Added
- Base64/hex forward and backward conversion in Terminal

## [0.9.171] - 2026-01-21
### Fixed
- Simplify upgrade to binary choice menu
- Upgrade binary UI fix

## [0.9.170] - 2026-01-21
### Changed
- New manage.sh wrapper architecture — defers all Repeater and Core tasks to upstream manage.sh
- Tested on Zero 2W with standard installation folders

## [0.9.169] - 2026-01-21
### Fixed
- Uninstall always works — shows detected components, removes self

## [0.9.168] - 2026-01-21
### Fixed
- Uninstall now removes console, clone, and self

## [0.9.167] - 2026-01-21
### Added
- Upgrade now offers component selection checklist

## [0.9.165] – 0.9.166 - 2026-01-21
### Added
- Experimental wrapper installer (manage.sh.new)

## [0.9.164] - 2026-01-21
### Changed
- manage.sh.new script testing

## [0.9.163] - 2026-01-20
### Fixed
- `get_repeater_version()` uses pip; add version summary to TUI menu

## [0.9.162] - 2026-01-20
### Added
- Full installer `print_completion()` includes version and branch for pyMC_Repeater

## [0.9.161] - 2026-01-20
### Fixed
- Map rendering fix

## [0.9.160] - 2026-01-20
### Fixed
- Basemap map initialization timing

## [0.9.159] - 2026-01-20
### Added
- Light mode map (auto-switch with theme)

## [0.9.158] - 2026-01-20
### Fixed
- Ghost packet accumulation fix

## [0.9.157] - 2026-01-20
### Added
- WebSocket authentication

## [0.9.156] - 2026-01-20
### Changed
- Updated received dashboard card — total RF vs unique
- Removed deduplicated packets for more accurate dashboarding and enhanced Topology/Viterbi/GhostBuster
- Various UI/UX refinements and enhanced packet chunk loading

## [0.9.155] - 2026-01-20
### Fixed
- 126K packet stack overflow fix
- Add unique packet tracking
- Filled pills with WCAG contrast compliance

## [0.9.154] - 2026-01-19
### Changed
- Enhanced WebSocket LiveDot functionality

## [0.9.153] - 2026-01-18
### Fixed
- Reduce WebSocket activity dot size by 60%

## [0.9.152] - 2026-01-18
### Changed
- README update with animated GIF demos
- Release summary tooling

## [0.9.151] - 2026-01-18
### Changed
- Minor enhancements

## [0.9.150] - 2026-01-18
### Changed
- UI enhancements

## [0.9.149] - 2026-01-18
### Changed
- UI enhancements, data-box class, theme refinements

## [0.9.148] - 2026-01-18
### Added
- WebSocket support for near-realtime packet ingestion

## [0.9.147] - 2026-01-18
### Changed
- Enhanced session memory handling
- Lazy-load 3d/7d/14d buckets until user requests (default 24h pull)
- Enhanced loading skeleton/shimmer effects

## [0.9.146] - 2026-01-18
### Fixed
- Theme switch bug fix — P3-aware color parsing

## [0.9.145] - 2026-01-18
### Added
- Breeze-inspired color theme
- Theme management implementation
- Theme cohesion pass
- Scientific color maps with theme-aware selection

## [0.9.144] - 2026-01-17
### Changed
- Remove unused patches

## [0.9.143] - 2026-01-17
### Added
- Noise floor P10 trend monitoring
- SX1264 settings tuned RSSI/SNR reception scoring

## [0.9.142] - 2026-01-17
### Changed
- Massive Contacts + Map performance upgrade

## [0.9.141] - 2026-01-17
### Fixed
- Bug fix

## [0.9.140] - 2026-01-17
### Fixed
- Cross-platform MapLibre support

## [0.9.139] - 2026-01-16
### Changed
- Packet Analyzer chart finessing
- Significant refactor/cleanup
- Major performance efficiencies
- Map UI refresh and performance enhancements

## [0.9.138] - 2026-01-15
### Added
- API specification documentation (human-readable markdown)
- Phase 9 topology API with link symmetry and disambiguation hints
- Authentication section in API docs

## [0.9.137] - 2026-01-15
### Fixed
- Map UI update

## [0.9.136] - 2026-01-15
### Changed
- Map enhancements, topology layer enhancements, performance improvements
- Neighbor link scoring and display

## [0.9.135] - 2026-01-15
### Fixed
- Font fix and Statistics page layout update

## [0.9.134] - 2026-01-15
### Changed
- Packet analyzer, ghost buster, better thread management, packet traces
- Various performance improvements and minor design tweaks

## [0.9.133] - 2026-01-13
### Added
- Packet Analyzer card with raw packet scatter plot
- Density-aware opacity and distribution diagnostics
- Utilization threshold bands
- Heatmap-colored scatter dots by packet type
- Bottom legend with hover data support
- Time-range-aware hover highlighting and dynamic Y-axis scaling

## [0.9.132] - 2026-01-12
### Changed
- Type Distribution chart enhancements
- Link Quality clipping fix
- Noise floor chart enhancements
- Skeleton loader
- Various small performance enhancements

## [0.9.131] - 2026-01-12
### Changed
- Link quality radar accuracy improvements

## [0.9.130] - 2026-01-11
### Changed
- Performance updates, new packet type distribution graph
- Link quality radar enhancements, MapLibre performance enhancements

## [0.9.129] - 2026-01-10
### Added
- 3D map features
- Viterbi HMM path disambiguation
- Upgraded topology logic
- Synced with pyMC_Repeater upstream dev branch
- Various performance enhancements

## [0.9.128] - 2026-01-09
### Changed
- Performance enhancements

## [0.9.127] - 2026-01-07
### Changed
- Link quality radar zoom feature and cleanup work

## [0.9.126] - 2026-01-06
### Changed
- Performance upgrades to backend-frontend API calls and data crunching

## [0.9.125] - 2026-01-05
### Changed
- Mesh Health section cleanup

## [0.9.124] - 2026-01-05
### Fixed
- Fullscreen map headroom fix for desktop

## [0.9.122] - 2026-01-04
### Reverted
- Roll back to v0.9.121 — remove crypto/auth/SSL changes

## [0.9.121] - 2026-01-04
### Changed
- Minor aesthetic change — link quality accent colors

## [0.9.120] - 2026-01-04
### Fixed
- Patch UI switching issue — update `/src/types` with `web_path`

## [0.9.119] - 2026-01-04
### Added
- Comprehensive UI polish
- UI switcher
- Region/transport keys manager
- API tokens manager
- Refreshed color palette
- Enhanced deep database retrieval

## [0.9.118] - 2026-01-02
### Changed
- MapLibre contrast adjustment — text/roads, popup instantiation on contacts click-for-focus
- PrefixConflictBadge added to node popup

## [0.9.116] – 0.9.117 - 2026-01-02
### Changed
- MapLibre CARTO Dark Matter contrast adjustments (multiple iterations)

## [0.9.115] - 2026-01-02
### Fixed
- manage.sh fix

## [0.9.114] - 2026-01-02
### Changed
- manage.sh update — installer/upgrade defaults to `feat/dmg` branch
- Revised README.md

## [0.9.113] - 2026-01-02
### Changed
- Map accessibility/sizing update, login background and fonts

## [0.9.112] - 2026-01-02
### Added
- Wave background on login screen

## [0.9.111] - 2026-01-02
### Fixed
- Move collab credit below login card
- Match WCM text style to pyMC, enlarge WCM logo

## [0.9.110] - 2026-01-02
### Added
- Redesigned login screen with new branding, powered-by card, MeshCore wordmark SVG, and mono font

## [0.9.109] - 2026-01-02
### Added
- Replace plaintext logo with SVG in sidebar and login

## [0.9.107] – 0.9.108 - 2026-01-02
### Fixed
- WCM logo fills container, larger with soft stroke on login
- Larger WCM logo with glass card border and shadow

## [0.9.106] - 2026-01-02
### Added
- Updated WCM logo and link to wcmesh.com

## [0.9.105] - 2026-01-02
### Changed
- Updated WCMesh logo

## [0.9.104] - 2026-01-02
### Added
- PrefixConflictBadge on Contacts list
- Release automation script (`release.sh`) for private repo

## [0.9.103] - 2026-01-02
### Fixed
- Airtime Utilization chart fills card height with proper legend spacing

## [0.9.102] - 2026-01-02
### Changed
- Enterprise-grade documentation and accessibility for chart components

## [0.9.101] - 2026-01-02
### Fixed
- Remove `position:relative` from glass-sidebar, add to desktop sidebar

## [0.9.100] - 2026-01-02
### Fixed
- Restore `w-64` to desktop sidebar, remove CSS width override

## [0.9.99] - 2026-01-02
### Fixed
- Desktop sidebar width CSS — Tailwind 4 JIT workaround
- Mobile layout — ensure main content takes full width

## [0.9.98] - 2026-01-02
### Added
- Heatmap as top strip with blur and legend improvements

## [0.9.97] - 2026-01-02
### Added
- Spectrogram-style heatmap with Batlow scientific color scale

## [0.9.96] - 2026-01-02
### Added
- Adaptive trails and percentile normalization for heatmap density

## [0.9.95] - 2026-01-02
### Added
- Vertical heat trails with 20% Y-axis headroom

## [0.9.94] - 2026-01-02
### Fixed
- Heatmap resolution adjustment to 160×40

## [0.9.93] - 2026-01-02
### Added
- HSL color gradients and doubled heatmap resolution on AirtimeSpectrum

## [0.9.92] - 2026-01-02
### Fixed
- Reduce heatmap blur to 1.5 on NoiseFloor and AirtimeSpectrum charts

## [0.9.91] - 2026-01-02
### Changed
- Default theme changed to Water at 60% opacity

## [0.9.90] - 2026-01-02
### Fixed
- Remove duplicate glass-card from MiniWidget, refine widget CSS

## [0.9.85] – 0.9.89 - 2026-01-02
### Fixed
- Safari WebGL map crash fix
- Safari map WebGL and brighter glass styling
- Glass surface tint instead of backdrop brightness
- Revert Safari WebGL props that broke map initialization
- Surface tint gradient fix for stacking with other bg layers

## [0.9.84] - 2026-01-02
### Changed
- Enhanced airtime chart lines and heatmap visualization

## [0.9.83] - 2026-01-02
### Fixed
- Dim glass reflections, map frame visibility, chart-container isolation

## [0.9.82] - 2026-01-02
### Changed
- Per-background brightness defaults, blur settings, restored dark mode reflex

## [0.9.81] - 2026-01-01
### Changed
- Standardized glass effect — 8px blur, 0.9 brightness, stronger map frame

## [0.9.80] - 2026-01-01
### Changed
- Standardized blur to 8px across magma/water/ribbons/folds themes

## [0.9.79] - 2026-01-01
### Fixed
- Glass-card-frame z-index for map overlay visibility

## [0.9.78] - 2026-01-01
### Changed
- Liquid glass tuning — brightness 0.75, tint 15%, per-theme blur

## [0.9.77] - 2026-01-01
### Added
- Dynamic Y-axis for airtime utilization chart

## [0.9.74] – 0.9.76 - 2026-01-01
### Added
- 4K background images, Kanagawa Wave theme
### Changed
- Simplified glass card styling
- Theme-aware blur tuning

## [0.9.67] – 0.9.73 - 2026-01-01
### Changed
- Glass card refinement pass — removed SVG displacement filter, kept blur + shadows
- Map card glass frame overlay cleanup
- Surface saturation tuning
- Darkened glass backdrop with reflection gradients (multiple iterations)

## [0.9.48] – 0.9.66 - 2026-01-01
### Added
- Liquid glass effect with multi-layered box-shadows
- Liquid glass applied to toggle-group and dark mode reflexes
- Complete liquid glass implementation across all card styles
- Centralized liquid glass design system
- SVG displacement filter experiments (ultimately reverted)
- Dynamic rounded-rectangle displacement map
### Changed
- Extensive glass card tuning (blur intensity, displacement strength, brightness)

## [0.9.43] – 0.9.47 - 2026-01-01
### Changed
- Glass card dimensionality with enhanced inner glow and highlight gradient
- Corrected glass card lighting physics
- Reduced fallback backdrop opacity to 33%
- Shrunk gradient highlight to 25% of card height
- Unified glass-card styling for data-card and chart-container

## [0.9.41] - 2026-01-01
### Added
- JWT token auto-refresh to prevent session timeouts

## [0.9.37] – 0.9.40 - 2026-01-01
### Changed
- Increased glass card backdrop blur intensity (8px → 16px)
- Cross-browser `backdrop-filter` support with `@supports` fallbacks
- Theme-derived darkest color for card fallback backgrounds
- Simplified glass card system

## [0.9.30] – 0.9.36 - 2026-01-01
### Added
- JWT authentication login page
### Fixed
- Auth flow error handling and logging
- Auth store initialization crash
- Direct localStorage check to avoid Zustand persist crash
- Replaced Zustand auth store with simple auth utilities
- Force page reload after login to reinitialize with token
- Auth token added to `packet-cache.ts` direct fetch call

## [0.9.25] – 0.9.29 - 2026-01-01
### Added
- Airtime chart with EMA trend lines and SVG heatmap
### Changed
- Subtle airtime heatmap with percentile normalization
- Max-based heatmap normalization, dimmed opacity
- EMA trend line initialization fix
- Optimized heatmap rendering with typed arrays and pre-computed strings

---

## [0.9.0] – [0.9.24] - 2025-12-31

### Wardriving Coverage Heatmap
- Wardriving coverage heatmap overlay with visibility toggles
- Iterated through HeatmapLayer → HexagonLayer → ScatterplotLayer → H3HexagonLayer
- 24-step Inferno color scale for H3 hexagon wardriving overlay
- Bell curve color mapping, dynamic weight (successRate × recencyWeight)
- High-precision `/get-samples` endpoint (~19m vs ~600m resolution)
- Multi-factor heatmap weight (observed × SNR × recency)
- WebGL context recovery handling
- Accept `/get-samples` URL directly in wardriving modal

---

## [0.8.0] – [0.8.9] - 2025-12-31

### Added
- Wardriving coverage heatmap overlay (initial implementation)
- Wardriving state migrated to Zustand store for persistence
- Consolidated deck.gl layers into shared overlay
### Fixed
- Heatmap URL handling and deck.gl migration
- Shallow comparison in Zustand selectors to prevent re-render loop
- Heatmap colors normalized by success rate

---

## [0.7.0] – [0.7.54] - 2025-12-27 – 2025-12-31

### Added
- Bento-box layout system for rhythmic, harmonious layouts
- Terminal liquid glass autocomplete effect
- Wardriving overlay button relocated above legend
- Animated pulse effect and cascading glow for neighbor edges
- Transparent map water layers (liquid glass alpha matte)
- Subtle arc curve on neighbor edges (evolved to deck.gl 3D arcs at 5000m altitude)
- Node pulse highlights synced with neighbor arc animation
- DIO2 RF switch patch for SX1262 radios (later reverted)

### Changed
- Statistics, System, Settings page layouts reorganized
- Mobile-optimized Terminal with removed merged upstream patches
- Node popup redesigned with improved clarity and data confidence
- Terminal-inspired color theme refactor
- All colors connected to CSS variable system
- Default theme changed to Gotham (black) at 66% brightness
- Recent Packets card shows most recently heard first
- Simplified hub/gateway classification using percentage-only thresholds
- Zero-hop neighbor detection improved for FLOOD-routed ADVERTs
- Link Quality chart shows all contacts, grays non-neighbors
- Modular mesh-topology architecture split
- Polar chart dots sorted: gray first, then SNR worst→best

### Fixed
- TX factor display and map legend tooltips
- TX power clamped to 22 dBm (SX1262 chip max)
- Solid tooltip backgrounds across all themes
- Terminal autocomplete layering and z-index issues
- Hidden contacts propagation
- Client-side performance and memory optimizations

---

## [0.6.57] – [0.6.83] - 2025-12-27

### Added
- Terminal page with command interface
- MeshCore CLI parity for Terminal
- Full `get`/`set` command support with MeshCore config parity
- Private key API (PATCH 1 v4, PATCH 6)
- Live config updates without restart (PATCH 1 v5)
- Increase advert interval max to 10080m (1 week)
- Color-coded help text with semantic differentiation
- Cross-platform block cursor for Terminal
- Dual-repo automated publishing infrastructure
- Standardized UI typography on Logs, Packets, Contacts pages

### Fixed
- Handle diverged git history in self-update
- Terminal loading sequence no longer loops infinitely
- `crypto.randomUUID` polyfill for HTTP contexts
- Terminal data mapping and macOS Tahoe styling
- Autocomplete for multi-word commands
- Reduce Terser obfuscation to fix black screen
- CI packages from pre-built `dist/` instead of building from source

---

## [0.6.0] – [0.6.56] - 2025-12-23 – 2025-12-27

### Added
- Neighbor visualization and gateway hub detection
- Last-hop neighbor detection from packet paths
- Neighbors filter on Contacts page
- Quick neighbor detection without deep analysis
- Calm topology visuals — gray edges, hover reveals type, neighbor ring overlay
- ADVERT-only filter for direct RF neighbor detection
- MapLibre GL JS implementation for ContactsMap (full Leaflet parity)
- PathMap ported to MapLibre
- Node sparklines with gradient health coloring
- Redesigned node popup with 12-column grid layout
- Complete path visualization with Source and Destination in Path Map
- DisambiguationCard on Statistics page
- Mesh Health widget suite
- Background sparkline computation
- Auto-advert on startup to wake up radio
- Show before→after versions on upgrade
- Console-only vs Full Stack install option

### Changed
- Signal icons updated to Lucide variants
- Neighbor edges styled as dashed green lines → yellow indicator
- MeshCore packet constants corrected
- Progressive loading for large packet sets
- Comprehensive performance optimizations
- Complete ESLint delinting for React Compiler compatibility
- Contact list icons updated by device type
- Centralized page layouts into PageLayout component

### Fixed
- Room server detection, "Chat Node" → "Companion" normalization
- Signal strength only for bidirectional neighbors
- Coordinate filtering (0,0 Africa bug)
- Infinite re-render loop in sparkline store
- Cross-platform gesture support for map zoom

---

## [0.5.0] – [0.5.167] - 2025-12-17 – 2025-12-23

### Added
- Unified ThemeContext architecture with background handling
- Map mesh topology graph with confidence-weighted edges
- Multi-factor confidence scoring for path analysis
- Centralized prefix disambiguation system
- Dominant forwarder boost for rooftop gateway detection
- Source-geographic correlation for prefix disambiguation
- Recursive disambiguation using next-hop anchor correlation
- Loop detection (H₁ homology) for mesh topology
- Hub badges in Discovered Nodes with link quality topology
- Intelligent packet caching for consistent topology
- Two-phase packet loading (1K quick start, 20K background)
- Edge z-ordering, thicker strong links
- Topology computation moved to Web Worker
- Deep Analysis button with progress modal
- TX delay recommendations in node popups (all nodes)
- Contacts page sorting, click-to-zoom, and search bar
- Weak topology edges layer
- 7-phase advanced topology analysis system
- PathHealth ↔ Map integration
- Cross-platform fullscreen map support (iOS/mobile)
- Network Composition card and room server icon
- 3D terrain map with MapLibre GL + deck.gl (later reverted to Leaflet-only)
- Hover brightness effect on map node markers
- Neighbor edge trace animation
- ESC key support to close all modals
- Enhanced PathMap with source node and hover highlighting
- Solo Hubs filter with staggered fade animation

### Changed
- ContactsMap and PathMap restyled (node colors, edge thickness, animations)
- Edge animation state synchronization
- Map node styling — deep royal blue, thicker rings
- Background images moved to `/assets/` for CherryPy static serving
- Spectrum analyzer style airtime chart with multiple visualization modes
- True spectrogram with bilinear splat, blur, and Inferno colormap

### Fixed
- Background images display with theme switching
- Prefix collision between local node and direct neighbor
- Local node edge detection and z-index
- Map transition smoothness for node selection
- Various disambiguation confidence threshold tuning

---

## [0.4.1] – [0.4.29] - 2025-12-16 – 2025-12-17

### Added
- SWR caching, skeleton loading, and prefetch for snappier UX
- Version number and animated wifi icon in sidebar
- Mixed-font branding typography for pyMC CONSOLE
- Redesigned Packets page with mobile-first UX and enhanced data display
- Time range and signal filters
- Responsive breakpoints and packet detail modal
- Unified packet row layout across dashboard and packets page

### Changed
- Sidebar branding simplified
- Component selection and version tracking for upgrades
- Prefer curl over wget for dashboard downloads

### Fixed
- Re-exec manage.sh after self-update during upgrade
- Portal-based PacketDetailModal to escape overflow:hidden
- Background transparency and z-index stacking for themes
- Body background fix so theme backgrounds display correctly

---

## [0.3.0] – [0.3.1] - 2025-12-16

### Added
- Dashboard installed to separate directory, preserving upstream Vue.js

### Fixed
- Trailing slashes removed from navigation links for SPA compatibility

---

## [0.2.0] – [0.2.2] - 2025-12-16

### Added
- GitHub Actions release workflow
- Simplified static file serving patch

---

## [0.1.0] - 2025-12-16

### Added
- Initial commit: pymc_console Next.js dashboard for pyMC_Repeater
- manage.sh installer with TUI (radio config, GPIO selection, progress bars)
- Client-side bucketed stats and utilization computation
- Upstream pyMC_Repeater installer wrapper architecture
- Vite + React Router migration (true SPA)
- Error boundaries for page and map errors
- Fullscreen map with skeuomorphic markers
- Neighbor signal strength lines
- Noise floor heatmap scatter visualization
- Temperature gauge with gradient zones
- System Resources time-series chart with Web Worker polling
- Packet types treemap chart
- TX Delay Calculator card
- Airtime utilization chart with smoothing algorithms
- Link Quality polar neighbor plot with radar pulse animation
- Brightness slider gesture control
- Dual-theme duotone chart palette

---

[0.9.294]: https://github.com/Treehouse-00/pymc_console/releases/tag/v0.9.294
[0.9.293]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.293
[0.9.292]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.292
[0.9.291]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.291
[0.9.290]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.290
[0.9.289]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.289
[0.9.288]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.288
[0.9.287]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.287
[0.9.286]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.286
[0.9.285]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.285
[0.9.278]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.278
[0.9.271]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.271
[0.9.258]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.258
[0.9.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.9.0
[0.8.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.8.0
[0.7.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.7.0
[0.6.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.6.0
[0.5.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.5.0
[0.3.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.3.0
[0.2.0]: https://github.com/dmduran12/pymc_console/releases/tag/v0.2.0
