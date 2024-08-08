# CAAS Aspace SOVA Button Plugin

Adds a "View in SOVA" button to resources and archival objects when the resource finding aid status field is "publish."

<img width="700" alt="Screenshot 2024-08-08 at 2 19 00 PM" src="https://github.com/user-attachments/assets/55e21118-2c65-4848-bac3-ad9828be1024">

## Tests

Should be run from the archivesspace project root directory.

To run headless (default):
```
.build/run frontend:selenium -Dspec="../../plugins/caas_aspace_sova_button/frontend/spec/toolbar_spec.rb"
```

To run headless with Chrome:
```
SELENIUM_CHROME=true .build/run frontend:selenium -Dspec="../../plugins/caas_aspace_sova_button/frontend/spec/toolbar_spec.rb"
```

To run heady with Chrome (chromedriver required):
```
SELENIUM_CHROME=true CHROME_OPTS= .build/run frontend:selenium -Dspec="../../plugins/caas_aspace_sova_button/frontend/spec/toolbar_spec.rb"
```

To run heady with Firefox (geckodriver required):
```
FIREFOX_OPTS= .build/run frontend:selenium -Dspec="../../plugins/caas_aspace_sova_button/frontend/spec/toolbar_spec.rb"
```
