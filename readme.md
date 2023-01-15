## Build tools & versions used
I used the latest Xcode 14.2.
and deployment target 14.0 for some modern Swift API

## Steps to run the app
Build and run the project from Xcode.
Run tests for tests.

The app is build to show different states of the list, according to the response. Each refresh is using different url from the task. So firs loading shows an error, to see the actual list you need to refresh the list two times.

## What areas of the app did you focus on?
I focused on modern Swift API and architecture. Also, I spend almost a third of my time on writing tests.

## What was the reason for your focus? What problems were you trying to solve?
I was trying to solve the problem of extensive coupling, which regularly appears in iOS projects. As a lead and senior developer, I find this higher-level skill very valuable. As part of it, I spend time writing tests to show how decoupling and decomposition help in testing. At the same time, I tried to keep things simple and not overengineered.

For my architecture, I used the MVVM approach. Combine is a great tool here to build an event-based architecture. 
I wrote unit tests for most classes to test their functionality.

**Models** here are `Employee` and `EmployeesData`. They are parsed from the response and provide basic data representation manipulations.
**ViewModel** is responsible for delivering data ready for a representation by `ViewController`, which is `View` in this scenario. The view is responsible for showing all the data. The presentation is defined by `State`, propagated by the view model and the value needed to render each state.

## How long did you spend on this project?
I've spent around 6 hours over two days, excluding writing this readme.

## Did you make any trade-offs for this project? What would you have done differently with more time?
I've spent less time on the UI. I used the most basic implementations, but I would use more custom elements to have more control over how the app looks like.

I also should have spent more time commenting on my code.

## What do you think is the weakest part of your project?
Some parts may be more challenging to read, and this is because I only left a few comments.

## Did you copy any code or dependencies? Please make sure to attribute them here!
I decided to go all standard. I used no external libraries to keep the project simple and small. But I would like to list some of those which would help me speed up in case of scaling:
- SDWebImage for image manipulations and cashing
- SnapKit for UIkit constraints and autolayout.
- WithKit (developed by me) to help create UIKit elements

Of course, I used some parts of the boilerplate code from SO.

### Contacts

artlookingforjob@gmail.com
