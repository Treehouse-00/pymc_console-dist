# Installing and migrating to waev:outpost

New waev:outpost versions are delivered as the **waev.outpost application UI plugin** for [openHop Repeater](https://github.com/openhop-dev/openhop_repeater). **v0.9.394 is the final legacy standalone release** from `pymc_console-dist`. Existing standalone users can move to the plugin without uninstalling their old files or resetting Repeater.

- [Install from the catalogue](#install-from-the-catalogue-recommended)
- [Migrate an existing standalone installation](#migrate-from-the-standalone-install)
- [Install a downloaded wheel](#install-a-plugin-wheel)
- [Recover the built-in Repeater interface](#recovery)

## Prerequisite

Use a working Repeater installation with application UI plugins and a running plugin manager. The instructions below describe the current built-in Repeater interface. Use your repeater's existing address; examples assume the default port, 8000.

If **System → Plugins** is missing, update Repeater through its [supported installation or upgrade process](https://github.com/openhop-dev/openhop_repeater). On an existing native installation, the updated Repeater `manage.sh upgrade` must be run once as an administrator to replace the privileged upgrade helper; installing only a new Python wheel cannot replace that helper. See [Repeater's native upgrade prerequisite](https://github.com/openhop-dev/openhop_repeater/blob/dev/docs/plugins.md#native-upgrade-prerequisite).

If the Plugins page says **Plugin manager is unavailable**, resolve that before installing the UI plugin. On a native host, check `systemctl status openhop-plugin-manager`. Current Repeater Docker images run the manager alongside Repeater unless it is explicitly disabled. Use the same Plugins page in Docker and LXC; do not run the legacy standalone installer inside the container.

Repeater continues to own its radio settings, identities, credentials, database and service. UI plugin installation does not reset them. Keep using your existing Repeater login. A backend upgrade, if needed, is a separate operation from this UI migration.

## Install from the catalogue (recommended)

1. Open the **built-in Repeater interface** at your repeater's home address. If waev:outpost currently occupies that address, follow the [migration steps](#migrate-from-the-standalone-install) to switch interfaces first.
2. Open **System → Plugins → Catalogue**.
3. Find **waev:outpost** and press **Install**. Repeater downloads the approved wheel and verifies its checksum, plugin ID and version against the catalogue.
4. Wait for completion. On the **Installed** tab, the UI plugin should show **UI READY**. Catalogue installation enables it automatically; if it is disabled, press **Enable**.
5. Use **Open UI**, or visit `http://<repeater-ip>:8000/plugins/waev.outpost/`. Sign in with your existing Repeater credentials and check that you see your repeater and the expected version.

You can use the direct plugin address without changing the default interface.

## Make waev:outpost the default interface

In the **built-in Repeater interface**, open **System → Configuration → Access → Web Options → Web Frontend** and select the **waev:outpost plugin** entry. Selection applies immediately and refreshes the page. The repeater's home address, `/`, now serves waev:outpost.

If the old standalone files are still installed, the built-in interface also lists **openHop Console** at `/opt/pymc_console/web/html`. That is the legacy copy, not the plugin. Select the plugin entry to use new releases.

From current waev:outpost, the equivalent controls are **Configuration → Web Frontend**: select an interface, press **Set as default interface**, then **Open default interface in a new tab**. Apply or discard other configuration drafts before switching. The direct `/plugins/waev.outpost/` address continues to open the plugin even when another interface is the default.

## Migrate from the standalone install

This applies to copies installed from `pymc_console-dist`, its `manage.sh`, or the `pymc-ui-*` archives under `/opt/pymc_console/web/html`.

1. **Keep the existing files and Repeater configuration.** You do not need to uninstall waev:outpost, recreate your account, re-enter radio settings or remove `/opt/pymc_console`.
2. In the existing waev:outpost, open **Configuration → Web Frontend**. Select **Default Frontend**, the built-in Repeater interface. In v0.9.394 the switch applies immediately and reloads. Newer waev versions ask you to press **Set as default interface** and offer **Open default interface in a new tab**. Open the home address `/` if you remain on the direct plugin address. If you cannot open the current UI, use [Recovery](#recovery).
3. In the built-in interface, open **System → Plugins → Catalogue**, find **waev:outpost**, and press **Install**. Wait for **UI READY**, then open `/plugins/waev.outpost/` and confirm your connection and the installed version.
4. Return to the built-in interface's **System → Configuration → Access → Web Options → Web Frontend** and select the **waev:outpost plugin** entry as the default.
5. For subsequent releases, use the [plugin update controls](#keeping-it-up-to-date). The old standalone `manage.sh upgrade` does not migrate to the plugin and will not deliver new plugin versions.

The migration changes where Repeater serves its UI. Its configuration, identities and login credentials stay in place. Both interfaces use the same Repeater API. Keep the same protocol, host and port to retain access to your browser origin's saved preferences; there is no need to clear browser storage.

Leave the old standalone folder in place until you are satisfied with the plugin. To switch back to the built-in interface, select **Default Frontend**. To temporarily return to the old standalone copy, choose **openHop Console** in the built-in interface while that folder still exists. waev itself labels this choice **waev:outpost · standalone install**. Your old copy keeps its installed version; the standalone channel ends at v0.9.394.

<a id="manual-update"></a>

## Keeping it up to date

For catalogue installs:

1. In the built-in interface, open **System → Plugins → Catalogue** and press **Refresh**.
2. If waev:outpost offers **Update**, press it and wait for the operation to finish.
3. Reopen the plugin or refresh its page and check the version.

In waev:outpost, the version badge also opens **What's new**, with **Check** and **Update** when the repeater reports an available plugin update. Updates require your confirmation; they are not installed automatically.

A GitHub release is published before catalogue approval. Repeater offers the version approved in its catalogue, so a newer release may not appear immediately. Existing installations keep working if the catalogue is temporarily unavailable.

For a fresh local-wheel installation, use **Install wheel** again with the newer wheel as described below. The Repeater backend itself is upgraded separately through its own installer or container process.

<a id="2b-install-by-hand"></a>
<a id="manual-install-no-managesh"></a>

## Install a plugin wheel

This is an alternative to catalogue installation, for example when you need a published version that is not yet approved in the catalogue.

1. Download the single `.whl` asset from the desired [waev-outpost-plugin release](https://github.com/Treehouse-00/waev-outpost-plugin/releases). Its name is `waev_outpost_plugin-<version>-py3-none-any.whl`.
2. In the built-in interface, open **System → Plugins → Install wheel**.
3. Choose the downloaded `.whl` file and press **Install**.
4. If the plugin is disabled, press **Enable** on the Installed tab. Confirm **UI READY**, open its UI, and optionally [make it the default](#make-waevoutpost-the-default-interface).

A fresh wheel upload does not establish catalogue repository metadata. The automatic **Update** operation can therefore be unavailable; upload a newer wheel with **Install wheel** to update that installation. An upload over an existing catalogue-managed installation may retain that installation's provenance.

To move a fresh local-wheel installation onto catalogue-managed updates, reinstall the approved version through the [catalogue-install API](#automation). Check the catalogue version first: it may be older than the wheel you uploaded. Installing a local wheel does not make that version catalogue-approved.

## Recovery

If the current UI works, choose **Default Frontend** under its Web Frontend controls, then open the repeater's home address `/`. This is the built-in Repeater interface. Do this before disabling or uninstalling the currently selected plugin.

If the UI cannot be opened but the Repeater API is reachable, restore the built-in default with an existing authenticated API token:

```bash
REPEATER_URL='http://<repeater-ip>:8000'
TOKEN='<repeater-api-token>'
curl --fail-with-body -sS -X POST "$REPEATER_URL/api/update_web_config" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"web":{"web_path":null}}'
```

Replace the placeholders with your repeater address and token. Read the response: confirm success and persistence, and follow `restart_required` if reported. Reopen `/`; a hard refresh may be needed. This changes only the default UI selection, not credentials or radio settings. There is no separate `/builtin` recovery URL.

If you cannot authenticate to the API, use administrator access to the host and Repeater's configuration/credential recovery process. For a native installation, restoring `web.web_path` to YAML `null` in the existing `/etc/openhop_repeater/config.yaml` and restarting `openhop-repeater` selects the built-in interface. Keep the rest of that configuration intact. For Docker or older pyMC-era paths, use the actual mounted configuration and service for that installation instead of assuming the native path.

If plugin operations fail with an unavailable manager, see [Prerequisite](#prerequisite). A missing plugin manager does not itself stop Repeater's normal radio operation.

## Automation

Use an existing Repeater API token. Replace the placeholders before running these commands:

```bash
REPEATER_URL='http://<repeater-ip>:8000'
TOKEN='<repeater-api-token>'

# Inspect the catalogue and its currently approved versions.
curl --fail-with-body -sS "$REPEATER_URL/api/plugins/catalogue" \
  -H "Authorization: Bearer $TOKEN"

# Install the approved waev:outpost version; this also enables it.
curl --fail-with-body -sS -X POST "$REPEATER_URL/api/plugins/catalogue_install" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"id":"waev.outpost"}'

# Check for an approved update for the installed plugin.
curl --fail-with-body -sS "$REPEATER_URL/api/plugins/updates?id=waev.outpost" \
  -H "Authorization: Bearer $TOKEN"

# Apply the update when one is available.
curl --fail-with-body -sS -X POST "$REPEATER_URL/api/plugins/update" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"id":"waev.outpost"}'
```

Inspect each response for success before continuing. The update endpoint needs repository metadata; use the catalogue-install operation to establish it for a fresh local-wheel installation.

To upload a wheel instead of installing from the catalogue:

```bash
curl --fail-with-body -sS -X POST "$REPEATER_URL/api/plugins/install" \
  -H "Authorization: Bearer $TOKEN" \
  -F 'wheel=@/path/to/waev_outpost_plugin-<version>-py3-none-any.whl'

curl --fail-with-body -sS -X POST "$REPEATER_URL/api/plugins/enable" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"id":"waev.outpost"}'
```

After confirming the plugin works at `/plugins/waev.outpost/`, select it as the default:

```bash
curl --fail-with-body -sS -X POST "$REPEATER_URL/api/update_web_config" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"web":{"web_path":"plugin:waev.outpost"}}'
```

The stable `plugin:waev.outpost` reference follows the installed plugin version. Confirm success, persistence and any restart requirement in the response. To restore the built-in default, use the same endpoint with `{"web":{"web_path":null}}`.

## Uninstall

First restore **Default Frontend** and confirm the repeater's home address opens the built-in UI. Then use **System → Plugins → Installed → Uninstall** for waev:outpost. Leave **Also delete persistent data directory** unchecked to keep plugin data for a later reinstall. Repeater's own configuration and radio service are separate.

Do not remove `/opt/pymc_console` as part of plugin installation or migration. It is the independent legacy copy and can remain available for switching back.

<a id="using-managesh-recommended"></a>
<a id="only-the-latest-release-is-published"></a>

## Legacy standalone reference

The final standalone assets are retained at [v0.9.394](https://github.com/Treehouse-00/pymc_console-dist/releases/tag/v0.9.394). They belong to the retired standalone channel. New installs and upgrades should use the plugin instructions above.

A legacy installation normally consists of `/opt/pymc_console/web/html`, a separate source or installer checkout such as `~/pymc_console`, and `web.web_path` pointing to that UI directory. Its old `manage.sh install`, `upgrade` and `uninstall` commands manage those files, not Repeater plugins.

No legacy cleanup is required to use the plugin. If you later choose to remove the old files, first confirm the default UI uses the plugin or built-in interface and retain any backup you need. The old `manage.sh uninstall` also offers to remove its checkout, so read its prompts. Keep Repeater's own installation, configuration and data intact.
