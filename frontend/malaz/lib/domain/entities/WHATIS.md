# What's Entities Directory?

- The `entities` directory contains the core business models of the application.

## - How it works?
Entities are plain Dart objects that represent the business objects of your application (e.g., User, Apartment). They are the most essential and high-level objects in the app and should be independent of any specific implementation details like serialization or database specifics.

* **Why is that?**
By keeping entities pure, we ensure that the core business logic is not tied to any specific data format or database. This makes the domain layer highly reusable and testable.
