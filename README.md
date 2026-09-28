# waev:outpost — legacy standalone distribution

> **This standalone distribution is retired. v0.9.394 is its final release.**
> New waev:outpost updates are delivered through the [waev:outpost Repeater plugin](https://github.com/Treehouse-00/waev-outpost-plugin). Start with [plugin release v0.9.396](https://github.com/Treehouse-00/waev-outpost-plugin/releases/tag/v0.9.396), or install the currently approved version from Repeater's catalogue.

Your existing standalone installation can continue to run. The [v0.9.394 downloads](https://github.com/Treehouse-00/pymc_console-dist/releases/tag/v0.9.394) remain available. Installing the plugin does not require deleting `/opt/pymc_console`, resetting Repeater, changing radio settings or replacing your credentials.

## Move to the plugin

Use your existing repeater address; the examples below assume the default port, 8000.

1. **Open the built-in Repeater interface.** In the legacy waev:outpost console, open **Configuration → Web Frontend** and select **Default Frontend**, the built-in Repeater interface. In v0.9.394 the change applies immediately and reloads the page. If needed, open the repeater's home address, `http://<repeater-ip>:8000/`.
2. **Install from the catalogue.** In the built-in interface, open **System → Plugins → Catalogue**, find **waev:outpost**, and press **Install**. Catalogue installation enables it automatically.
3. **Check the plugin.** On the **Installed** tab, confirm **UI READY**. If it is disabled, press **Enable**. Use **Open UI**, or open `http://<repeater-ip>:8000/plugins/waev.outpost/`, and sign in with your existing Repeater credentials. Check the installed version and connection to your repeater.
4. **Make it the default.** Return to the built-in interface and open **System → Configuration → Access → Web Options → Web Frontend**. Select the **waev:outpost plugin** entry. The selection applies immediately; the repeater's home address now serves the plugin.

If the old folder is still installed, the built-in interface also lists **openHop Console** at `/opt/pymc_console/web/html`. That is the old standalone copy. Choose the plugin entry for new releases.

Your Repeater configuration, radio identities and login credentials stay in place. Keep the same protocol, host and port to retain access to that browser origin's saved preferences. The old standalone folder can remain as a fallback; no uninstall is needed.

If **System → Plugins** is missing or the plugin manager is unavailable, [update Repeater and check its plugin prerequisites](INSTALL.md#prerequisite) before proceeding. The old standalone installer does not provide plugin support.

## Install a downloaded wheel instead

To install a specific published plugin version, download its single `.whl` asset from [waev-outpost-plugin releases](https://github.com/Treehouse-00/waev-outpost-plugin/releases).

In the built-in interface, use **System → Plugins → Install wheel**, choose the file and press **Install**. Press **Enable** if disabled, confirm **UI READY**, and test `/plugins/waev.outpost/`. Select the plugin under **Web Options → Web Frontend** if you want it at `/`.

A fresh local-wheel installation has no catalogue repository metadata, so the automatic **Update** operation may be unavailable. Update it by uploading a newer wheel with **Install wheel** again. To adopt catalogue-managed updates, use the [catalogue-install API](INSTALL.md#automation) to reinstall the approved version. Check that version first because it may be older than a manually uploaded wheel.

## Future updates

- **Catalogue installation:** in the built-in interface, use **System → Plugins → Catalogue → Refresh**, then **Update** when offered. In waev:outpost, the version badge also offers **What's new → Check / Update** when the repeater reports an available plugin update.
- **Fresh local-wheel installation:** upload the newer wheel with **Install wheel** again, or adopt catalogue installation as described above.
- **Legacy standalone installation:** this repository ends at v0.9.394. Its old `manage.sh upgrade` does not install or update the plugin.

Updates require your confirmation. A published GitHub release becomes available through the catalogue only after approval, so the catalogue may temporarily offer an earlier version. Repeater itself is upgraded separately through its own supported installer or container process.

## Switch back or recover

In current waev:outpost, open **Configuration → Web Frontend**, select **Default Frontend**, press **Set as default interface**, then **Open default interface in a new tab**. The direct `/plugins/waev.outpost/` address still opens the plugin; use `/` to see the selected default.

To temporarily return to your old standalone copy, select **openHop Console** in the built-in interface while `/opt/pymc_console/web/html` still exists. waev labels this choice **waev:outpost · standalone install**. Your old copy keeps its installed version; the standalone channel ends at v0.9.394.

If the UI cannot be opened, follow [Recovery](INSTALL.md#recovery) to restore the built-in default through the authenticated Repeater API or the host's existing configuration. Switch to a working default before disabling or uninstalling the selected plugin. Do not delete Repeater's configuration or data.

## Downloads and documentation

- [Complete installation, migration and recovery guide](INSTALL.md)
- [Supported plugin repository and release notes](https://github.com/Treehouse-00/waev-outpost-plugin)
- [Plugin releases](https://github.com/Treehouse-00/waev-outpost-plugin/releases) · [release feed](https://github.com/Treehouse-00/waev-outpost-plugin/releases.atom)
- [Retained standalone v0.9.394 downloads](https://github.com/Treehouse-00/pymc_console-dist/releases/tag/v0.9.394)
- [Legacy release information](RELEASE.md) · [legacy changelog](CHANGELOG.md) · [license](LICENSE)
