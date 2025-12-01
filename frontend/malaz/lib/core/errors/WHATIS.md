# What's Errors Directory ?

- error directory contains two files failures and exception they have a solid link between them

## - Exceptions File
when we face an exception for instance network exception we can find this exception in exceptions
file and we'll throw that exception

* why is that ?   
later we will handle any thrown exception through failures file
* example :
```
DataSource -> throws NetworkException
```

## - Failures File
When an exception is thrown, we will catch it and then return a `Failure` from the `Failures` file. This allows us to handle errors in a more structured way.

* why is that ?
This allows us to gracefully handle errors in the UI layer, for example by showing a specific error message for each failure type.

* example :
```
Repository -> catches Exception & returns Failure -> UseCase -> UI
```
