# openHop RepeaterUI Parity Inventory

Source references verified for this local branch work:

- React Console repo: `/home/yellowcooln/openhop-dev/pymc_console`, branch `feature/openhop-console-repeater-parity-local`.
- RepeaterUI reference: `/tmp/openHop_RepeaterUI_feat_update_branding`, branch `feat-update-branding`, inspected plan commit `ce4df83`.
- Repeater backend reference: `/tmp/openhop_repeater_reference`, inspected plan commit `60357f5`.

This file records code-verified implementation status. RepeaterUI and openhop_repeater are reference-only for this task.

## Default UI feature acceptance matrix

| Default UI file | Console target | Status | Acceptance criteria |
| --- | --- | --- | --- |
| `views/Dashboard.vue` | `/` / `frontend/src/pages/Dashboard.tsx` | complete | Existing richer Console dashboard remains the home route. |
| `views/Login.vue` | `/login` / `frontend/src/pages/Login.tsx` | complete | Login remains public and branded as openHop Console. |
| `views/Setup.vue` | `/setup` / `frontend/src/pages/Setup.tsx` | thin | First-run flow uses `/api/needs_setup`, hardware, presets, serial, and setup wizard helpers; further field-level parity can deepen without blocking shell route. |
| `views/Neighbors.vue` | `/neighbors` -> `/contacts` | mapped | Console Contacts map/topology stays the richer neighbor view. |
| `views/Statistics.vue` | `/statistics` | complete | Existing charts remain reachable. |
| `views/RfHealthCorrelation.vue` | `/rf-health-correlation` | thin | Page renders RF correlation inputs and graceful unsupported states; deeper visual correlation remains incremental. |
| `views/GPSDiagnostics.vue` | `/gps` | thin | GPS status/stream route exists with unsupported states. |
| `views/SystemStats.vue` | `/system-stats` -> `/system` | mapped | Existing System page remains the richer system stats target. |
| `views/Sensors.vue` | `/sensors` | thin | Sensor Readings route renders known/generic sensors and empty states. |
| `views/Configuration.vue` | `/configuration` | complete | Existing Console configuration preserved; default tab IDs are now discoverable through query/deep links. |
| `components/configuration/RadioSettings.vue` | `/configuration?tab=radio` | complete | Radio settings remain editable in the existing Configuration page. |
| `components/configuration/RadioHardwareSettings.vue` | `/radio-hardware`, `/configuration?tab=radio-hardware` | complete | Current hardware config, board presets, and serial ports are visible; no unsupported save button is shown. |
| `components/configuration/RepeaterSettings.vue` | `/configuration?tab=repeater` | complete | Node/location/repeater controls remain visible in Configuration. |
| `components/configuration/AdvertSettings.vue` | `/configuration?tab=advert` | mapped | Advert interval and advert rate limiting are represented by Configuration and `AdvertRateLimitCard`. |
| `components/configuration/DutyCycle.vue` | `/configuration?tab=duty` | complete | Duty cycle toggle/max airtime remain editable in Configuration. |
| `components/configuration/TransmissionDelays.vue` | `/configuration?tab=delays` | complete | Flood/direct TX delay factors are displayed as factors (`x`), not seconds. |
| `components/configuration/TransportKeys.vue` | `/configuration?tab=transport` | complete | Transport key tree, add/edit/delete, and unscoped flood policy remain present. |
| `components/configuration/APITokens.vue` | `/configuration?tab=api-tokens` | complete | Token creation/revocation remains present. |
| `components/configuration/WebSettings.vue` | `/configuration?tab=web` | complete | Web frontend, CORS, theme/app controls remain present. |
| `components/configuration/LetsMeshSettings.vue` | `/observer`, `/configuration?tab=observer` | complete | `/observer` manages repeater-side MQTT publisher/Observer; `/mqtt` remains Console browser-side subscriber/source tooling. |
| `components/configuration/PolicyEngineSettings.vue` | `/policy-engine`, `/policies`, `/configuration?tab=policy-engine` | complete | Policy document state, groups, entries, add/remove, and confirm-delete UI are available with graceful unsupported states. |
| `components/configuration/BackupRestore.vue` | `/backup`, `/backup-restore`, `/configuration?tab=backup` | complete | Settings export, full backup, import, and identity key export are available with HTTP/secret warnings and confirmations. |
| `components/configuration/DatabaseManagement.vue` | `/database`, `/database-management`, `/configuration?tab=database` | complete | DB stats, table row counts, vacuum, selected purge, and typed-confirm purge-all are available. |
| `components/configuration/MemoryDebug.vue` | `/memory`, `/configuration?tab=memory` | complete | Process/GC/allocation diagnostics load, refresh, and snapshot action are available with collapsed large details. |
| `views/CADCalibration.vue` | `/cad-calibration` | thin | CAD workflow route uses underscore endpoints and closes stream on navigation/stop. |
| `views/Sessions.vue` | `/sessions` | complete | Existing sessions page preserved. |
| `views/RoomServers.vue` | `/room-servers` -> `/room-server` | mapped | Existing Room Server page preserved. |
| `views/Companions.vue` | `/companions` -> `/companion` | mapped | WebUI Companion remains preserved. |
| `views/Logs.vue` | `/logs` | complete | Existing logs page preserved. |
| `views/Terminal.vue` | `/terminal` | complete | Existing browser terminal preserved. |
| `views/Help.vue` | `/help` | complete | Help describes default parity additions and Console-only extras. |

Console-only preserved features are not default UI gaps: `/contacts`, `/mqtt`, `/companion`, `/meshgraph`, `/raw`, `/test`, packet pipeline workers, WebUI Companion, external source tooling, and Signal Lab.

## Routes

| RepeaterUI route | Console route/status | Notes |
| --- | --- | --- |
| `/` | already present | Existing Dashboard preserved. |
| `/login` | already present | Branding pass only. |
| `/setup` | ported shell | Public route added with hardware/preset/serial/setup_wizard clients. |
| `/neighbors` | mapped | Redirects to existing `/contacts` to preserve Contacts map/topology. |
| `/statistics` | already present | Existing charts preserved. |
| `/rf-health-correlation` | ported shell | Uses packet stats, CRC, noise floor, metrics, and local packet cache when available. |
| `/rf-health` | mapped | Redirects to `/rf-health-correlation`. |
| `/gps` | ported shell | Uses `/api/gps` and `/api/gps_stream` with disabled/unsupported states. |
| `/gps-diagnostics` | mapped | Redirects to `/gps`. |
| `/system-stats` | mapped | Redirects to existing `/system`. |
| `/sensors` | ported shell | Renders generic `stats.sensors` as Sensor Readings; no raw JSON blobs for nested values. |
| `/configuration` | already present + additive hooks | Existing monolithic Console Configuration preserved; new API clients exported for future panels. |
| `/radio-hardware` | ported | Read-only current hardware, serial ports, and hardware presets. |
| `/observer` | ported | Adds RepeaterUI Observer identity + MQTT broker management; `/observers` and `/mqtt-management` redirect here. |
| `/policy-engine` | ported | Policy document state, groups, entries, add/remove, and confirm-delete UI. |
| `/database` | ported | Database stats, vacuum, selected purge, and typed-confirm purge all. |
| `/memory` | ported | Process memory, GC, top allocations, refresh, and diagnostic snapshot. |
| `/backup` | ported | Settings export, full backup, import, and identity key export with confirmations. |
| `/cad-calibration` | ported shell | Uses underscore CAD endpoints and closes SSE on unmount/stop. |
| `/cad` | mapped | Redirects to `/cad-calibration`. |
| `/sessions` | already present | Preserved. |
| `/room-servers` | mapped | Redirects to existing `/room-server`. |
| `/companions` | mapped | Redirects to existing `/companion`; WebUI Companion remains present. |
| `/logs` | already present | Preserved. |
| `/terminal` | already present | Preserved. |
| `/help` | ported | New Help page documenting Console/openHop compatibility boundaries. |
| `/raw` | Console-only preserved | Packet Observatory remains hidden/developer accessible. |
| `/meshgraph` | Console-only preserved | Visible in System group. |
| `/mqtt` | Console-only preserved | Sources/external DB/MQTT tooling remains visible. |

## Endpoint/client parity

| Area | Endpoint(s) | Status |
| --- | --- | --- |
| Setup | `/api/needs_setup`, `/api/hardware_options`, `/api/radio_presets`, `/api/serial_ports`, `/api/setup_wizard` | `frontend/src/commands/setup.ts` added. |
| GPS | `/api/gps`, `/api/gps_stream` | `frontend/src/commands/gps.ts` added; uses underscore stream endpoint. |
| CAD | `/api/cad_calibration_start`, `/api/cad_calibration_stop`, `/api/cad_calibration_stream`, `/api/save_cad_settings` | `frontend/src/commands/cad.ts` added; uses underscore endpoint names. |
| RF health | `/api/packet_stats`, `/api/noise_floor_history`, `/api/crc_error_count`, `/api/crc_error_history`, `/api/metrics_graph_data` | Existing stats commands reused by new page. |
| Database | `/api/db_stats`, `/api/db_purge`, `/api/db_vacuum` | `frontend/src/commands/maintenance.ts` added. |
| Memory | `/api/memory_debug` | `frontend/src/commands/maintenance.ts` added. |
| Backup/Restore | `/api/config_export`, `/api/config_import`, `/api/identity_export` | `frontend/src/commands/backup.ts` added. |
| Observer/MQTT | `/api/mqtt_status`, `/api/broker_presets`, `/api/update_mqtt_config` | `frontend/src/commands/maintenance.ts` typed helpers plus `/observer` management UI added. |
| Policy Engine | `/api/policy`, `/api/policy_groups`, `/api/policy_group_entries` | `frontend/src/commands/policy.ts` added. |
| Compatibility frontend check | `/api/check_pymc_console` | Existing system command preserved. |

## Configuration parity

The current `Configuration.tsx` is still monolithic and already contains important Console functionality: radio settings, repeater settings, duty cycle, transport keys, web frontend switching, API tokens, theme/app settings, software update, stealth location, and flood-loop detection. This pass did not replace it. Added client modules make the following panels ready for incremental extraction/porting:

- Radio hardware and serial ports.
- Observer/MQTT broker presets/status/configuration, now exposed at `/observer`.
- Policy Engine and policy groups/entries.
- Database stats/purge/vacuum.
- Memory diagnostics.
- CAD calibration link/page.

## Branding and compatibility notes

- User-facing app shell accessibility labels and web frontend text now say `openHop Console`.
- The legacy component export `PyMCConsoleLogo` is intentionally retained to avoid broad import churn, but it renders `openHop:Console`.
- Compatibility identifiers intentionally preserved: `/opt/pymc_console/web/html`, `/api/check_pymc_console`, `pymc_usb`, `pymc_tcp`, local storage/auth keys, protocol fields, and existing install/update paths unless the backend actually changes them.
- Current openHop Repeater runtime paths to prefer in new user-facing help/config copy: `/opt/openhop_repeater`, `/etc/openhop_repeater`, `/var/lib/openhop_repeater`, `/var/log/openhop_repeater`, `openhop-repeater.service`.

## Deferred work

- Full setup wizard validation/parity can be deepened once the target backend payload schema is locked.
- Full Configuration refactor into modular panels is intentionally deferred to avoid destabilizing the existing Console-only configuration features in one large edit.
- Browser smoke and endpoint live verification require a running Repeater target or local dev server; this local pass only adds graceful unsupported states.
