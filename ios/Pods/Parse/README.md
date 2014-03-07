# Mirror of the Parse iOS framework

This is an unofficial [Parse](http://parse.com/) Cocoapods repository for integrating iOS projects with the Parse backend. This project is not officially supported by Parse.com.


##Getting Started

1. Create a new Xcode project

2. Add a Podfile with the Parse framework as a pod reference:

		platform :ios
		pod 'Parse'

3. Run 'pod install' on the command line to install the Parse cocoapod. FacebookSDK will also be installed as a dependency. Currently this is not optional.

4. Open up your AppDelegate.m file and add the following import to the top of the file:

		#import <Parse/Parse.h>		

5. Then set your applicationId and clientId inside the application:didFinishLaunchingWithOptions: function. See the [Parse QuickStart Guide](https://parse.com/apps/quickstart) for more details. Start at step 9.

