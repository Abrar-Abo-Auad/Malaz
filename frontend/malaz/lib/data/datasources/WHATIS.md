# What's Datasources Directory?

- The `datasources` directory is responsible for fetching raw data from different sources, such as a remote API or a local database.

## - How it works?
It has two sub-directories:
- `remote`: For fetching data from the network.
- `local`: For fetching data from the device's cache or local storage.

* **Why is that?**
This separation allows us to easily switch between data sources or add new ones without affecting the rest of the application.
