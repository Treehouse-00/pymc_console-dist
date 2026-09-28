# Legacy standalone releases

**The `pymc_console-dist` standalone channel is retired. Its final release is v0.9.394.** New waev:outpost releases are published as the `waev.outpost` application UI plugin in [waev-outpost-plugin](https://github.com/Treehouse-00/waev-outpost-plugin), including [v0.9.396](https://github.com/Treehouse-00/waev-outpost-plugin/releases/tag/v0.9.396).

## Retained standalone downloads

The [v0.9.394 release](https://github.com/Treehouse-00/pymc_console-dist/releases/tag/v0.9.394) and these existing assets remain available for legacy installations:

| Asset | Purpose |
|---|---|
| [`pymc-ui-v0.9.394.tar.gz`](https://github.com/Treehouse-00/pymc_console-dist/releases/download/v0.9.394/pymc-ui-v0.9.394.tar.gz) | Final standalone tar archive |
| [`pymc-ui-v0.9.394.zip`](https://github.com/Treehouse-00/pymc_console-dist/releases/download/v0.9.394/pymc-ui-v0.9.394.zip) | Final standalone ZIP archive |
| [`pymc-ui-latest.tar.gz`](https://github.com/Treehouse-00/pymc_console-dist/releases/download/v0.9.394/pymc-ui-latest.tar.gz) | Existing installer-compatible name for the same final tar archive |
| [`pymc-ui-latest.zip`](https://github.com/Treehouse-00/pymc_console-dist/releases/download/v0.9.394/pymc-ui-latest.zip) | Existing installer-compatible name for the same final ZIP archive |

The `latest` names do not mean the standalone channel will receive further updates. The old `manage.sh upgrade` remains a standalone operation and does not migrate an installation to the plugin. Historical notes remain in [CHANGELOG.md](CHANGELOG.md).

## Install and update the supported plugin

Start with the [migration steps in README.md](README.md#move-to-the-plugin) or the [complete installation guide](INSTALL.md#migrate-from-the-standalone-install). Keep your old folder, Repeater configuration and credentials while verifying the plugin.

In the legacy console, **Configuration → Web Frontend → Default Frontend** returns to the built-in Repeater interface immediately. From there, **System → Plugins → Catalogue → waev:outpost → Install** installs and enables the approved plugin. Confirm **UI READY**, use **Enable** if disabled, and open `/plugins/waev.outpost/`. Make it the default under **System → Configuration → Access → Web Options → Web Frontend**, selecting the plugin entry.

For a specific published version, download its `.whl` from [plugin releases](https://github.com/Treehouse-00/waev-outpost-plugin/releases) and use **System → Plugins → Install wheel**. Enable it if needed and test its direct URL before changing the default.

Catalogue installs receive approved updates through **Plugins → Catalogue → Refresh → Update**, or the available plugin update in waev:outpost's **What's new** dialog. Fresh local-wheel installs may lack update tracking; upload a newer wheel again or adopt catalogue installation using the [documented API](INSTALL.md#automation). A release is available in the catalogue only after approval, which may follow GitHub publication.

Published plugin versions and their versioned wheel downloads are retained. Follow the [plugin release feed](https://github.com/Treehouse-00/waev-outpost-plugin/releases.atom) for new releases. This repository's retained standalone assets are a fallback, not the current update channel.

See [Recovery](INSTALL.md#recovery) to restore the built-in default if the current UI is unavailable. No standalone uninstall or credential reset is required to migrate.
