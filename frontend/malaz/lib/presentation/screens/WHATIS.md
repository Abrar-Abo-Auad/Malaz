# What's Screens Directory?

- The `screens` directory contains all the pages or screens of the application.

## - How it works?
Each screen is a widget (usually a `Scaffold`) that represents a full page in the application. It is responsible for composing the different widgets that make up the screen and for interacting with the state management layer (cubits/blocs) to get the data to display and to notify about user actions.

* **Why is that?**
This organizes the UI into logical pages, making it easier to navigate the codebase and understand the structure of the application.
