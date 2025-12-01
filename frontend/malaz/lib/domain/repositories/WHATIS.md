# What's Repositories Directory?

- This directory contains the contracts (abstract classes) for the repositories.

## - How it works?
These contracts define what the repositories can do, but not how they do it. The implementation details are left to the `data` layer. This is a key principle of Dependency Inversion.

* **Why is that?**
By depending on abstractions rather than concrete implementations, the `domain` layer remains independent of the `data` layer. This allows us to swap out the data layer implementation without affecting the core business logic.
