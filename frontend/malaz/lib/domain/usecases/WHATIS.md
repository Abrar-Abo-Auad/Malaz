# What's Usecases Directory?

- The `usecases` directory contains the specific business rules of the application. Each use case represents a single interaction that the user can have with the app.

## - How it works?
Each use case is a class that has a single public method, `call`, which is executed when the use case is invoked. The use case orchestrates the flow of data between the UI and the repositories.

* **Why is that?**
This separates the business logic into small, testable, and reusable components. It makes the code easier to understand and maintain.
