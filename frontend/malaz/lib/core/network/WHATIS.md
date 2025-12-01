# What's Network Directory?

- The `network` directory is responsible for handling all network-related logic, such as checking for internet connectivity.

## - Network Info

This file/class is used to determine the device's network status (connected or disconnected).

* **Why is that?**
Before making any network requests, we need to check if the device has an active internet connection. This helps in providing better error handling and user feedback.

* **Example:**
```
Repository -> uses NetworkInfo -> to check for internet connection before making a request
```
