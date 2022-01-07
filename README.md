# Bringoz Address Assigment

### Project done with the following tools and settings:
#### XCODE Version: 12.5.1
#### Swift Version: 5.x
#### Deployment Target: 13.0

### Instructions to run the project
- Clone the project
- do a `pod install`
- Project should run sucessfully after this

### Notes regarding testing the app
- App picks the current time as a start time for the first address and all the calculations are applied on that
- In order to apply the constraint, please `double tap` on a cell. `double tapping` again will remove the constraints.

### Architecture design and consideration
Assignment had certain specific requirements which focused on having replacable blocks. Here's how they are achieved:

#### Replacable Address Coordination Resolver
Currently the address coordinations are resolved by using Google API / SDK. For this, the `PlaceProvider` protocol is defined, to which the `GooglePlaceProvider` is adhering to. In future, if we want to replace it with some other third-party/first-party providers, we can create another `*PlaceProvider` class which should extend to the `PlaceProvider` and then it can be easily swapped by returning the new `*PlaceProvider` from `AddressModule` instead of `GooglePlaceProvider`

#### Replacable ETA Calculator/Provider
For this, an abstraction called `ETAProvider` is created and `AerialETAProvider` currently does the job of calculating ETA by using the own logic based on the distance between two addresses. In future we can create a new `*ETAProvider`, for example `RemoteETAProvider`which can call our own API to get the ETA.

#### Replacable Constraints
A base protocol called `Constraint` is defined. Currently, the `AdjacentConstraint` is applied in the app which doesn't allow any other address to be dropped between the constrained addresses. There's one more constrained called `MaxMinutesConstraint` which isn't being used in the app, but has been included to demonstrate that the constraints can easily be replaced in the app.

Further more, the `ConstraintManager` class is created which does the heavy lifting of managing and applying the constraints and the UI can simply ask this class to drive the UI logic.

`MVVM` architecture is also demonstrated for the `Add Address` functionality where the `ViewModel` uses the `PlaceProvider` in order to grab the data and then exposes the streams to which the `ViewController/UI` is subscribed in order to display the data.
