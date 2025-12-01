# What's Presentation Directory?

- The `presentation` directory is the outermost layer of the application, responsible for everything related to the UI and user interaction.

## - How it works?
It contains the screens (pages), the state management logic (cubits/blocs), and the widgets that make up the UI.

* **Why is that?**
This layer is concerned with how to display the data and handle user input. It is the only layer that has a dependency on the Flutter framework. It communicates with the `domain` layer through use cases.
