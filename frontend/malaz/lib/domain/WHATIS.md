# What's Domain Directory?

- The `domain` directory is the core layer of the application. It contains the enterprise-wide business logic and is completely independent of any other layer.

## - How it works?
It defines the business models (entities), the contracts for the repositories, and the use cases.

* **Why is that?**
This layer is the most stable part of the application. It has no dependencies on how the data is presented or where it comes from. This makes the business logic reusable and easy to test.
