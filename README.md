# CAAS Aspace SOVA Button Plugin

Adds a "View in SOVA" button to resources and archival objects when the resource finding aid status field is "publish."

<img width="700" alt="Screenshot 2024-08-08 at 2 19 00 PM" src="https://github.com/user-attachments/assets/55e21118-2c65-4848-bac3-ad9828be1024">

## Using alongside other toolbar plugins (ex: SNAC plugin)

Since this plugin overrides two shared toolbar partials - `shared/_component_toolbar.html.erb` and `shared/_resource_toolbar.html.erb` - it will conflict with plugins that also modify those views.  For the Smithsonian, this currently includes the 3rd-party [SNAC plugin](https://github.com/snac-cooperative/snac_aspace_plugin).  To address this, this plugin conditionally inserts the SNAC resource toolbar override if `snac_aspace_plugin` is present in `AppConfig`.  ASpace maintainers should be aware of this when upgrading ArchivesSpace, the SOVA plugin, and/or the SNAC plugin.

For the above to work, the `caas_aspace_sova_button` must be loaded last, such as:

```
AppConfig[:plugins] = ['local', 'lcnaf', 'snac_aspace_plugin', 'some-other-plugin', 'caas_aspace_sova_button']
```

## Configuring SOVA environment

To (optionally) configure the base SOVA URL (e.g. test or prod) add the following to your ArchivesSpace `config.yml`:

```
 AppConfig[:sova_url] = 'https://sova-test.si.edu/'
```

If no configuration setting is supplied, the system will fallback to the production SOVA URL defined in `caas_aspace_sova_button/frontend/plugin_init.rb`.

## Tests

Should be run from the archivesspace project root directory.

To run headless (default):
```
./build/run frontend:test -Dpattern="../../plugins/caas_aspace_sova_button/frontend/spec/*"
```

To run headless with Chrome:
```
SELENIUM_CHROME=true ./build/run frontend:test -Dpattern="../../plugins/caas_aspace_sova_button/frontend/spec/*"
```

To run heady with Chrome (chromedriver required):
```
SELENIUM_CHROME=true CHROME_OPTS= ./build/run frontend:test -Dpattern="../../plugins/caas_aspace_sova_button/frontend/spec/*"
```

To run heady with Firefox (geckodriver required):
```
FIREFOX_OPTS= ./build/run frontend:test -Dpattern="../../plugins/caas_aspace_sova_button/frontend/spec/*"
```
