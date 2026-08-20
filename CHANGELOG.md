# Changelog

All notable changes to pymc_console are documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html) with rapid patch releases.

---

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
