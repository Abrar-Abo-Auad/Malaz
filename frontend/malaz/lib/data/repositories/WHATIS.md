# What's Repositories Directory?

- This directory contains the concrete implementations of the repository contracts (abstract classes) defined in the [domain layer](../../domain/repositories/WHATIS.md).

## - How it works?
These repository implementations are responsible for coordinating data from the different data sources (remote and local). They handle the logic of when to fetch data from the network and when to retrieve it from the local cache.

* **Why is that?**
This separation allows the `domain` layer to be completely unaware of the data sources. The `domain` layer only depends on the repository contract, not the implementation.
