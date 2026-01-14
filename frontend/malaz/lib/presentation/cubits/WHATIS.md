# What's Cubits Directory?

- The `cubits` directory contains the state management logic for the presentation layer. We use the `flutter_bloc` package, and specifically `Cubits`, to manage the state of our screens.

## - How it works?
Each feature or screen can have its own cubit. The cubit is responsible for receiving events from the UI (e.g., a button press), executing the corresponding [use case](../../domain/usecases/WHATIS.md), and emitting new states to the UI. The UI then rebuilds itself based on the new state.

* **Why is that?**
This separates the state management logic from the UI code, making both easier to test and maintain. It provides a clear and predictable way to manage the state of your application.
