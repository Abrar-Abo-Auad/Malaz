# What's Data Directory?

- The `data` directory is the outermost layer of our architecture. It is responsible for data retrieval and management.

## - How it works?
It contains repository implementations, data sources (remote and local), and data models.

* **Why is that?**
This layer abstracts the data sources from the rest of the application. The `domain` layer communicates with the repository implementations in this layer, but it is unaware of how the data is actually fetched or stored.
