//
//  RGAAppDelegate.m
//  Group5iBeacons
//
//  Created by John Tubert on 3/7/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import "RGAAppDelegate.h"

#import "Global.h"
#import "PolygonManager.h"

@implementation RGAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TestFlight
    //[TestFlight takeOff:@"<id>"];
    
    // Load the FBProfilePictureView
    // You can find more information about why you need to add this line of code in our troubleshooting guide
    // https://developers.facebook.com/docs/ios/troubleshooting#objc
    [FBProfilePictureView class];
    
    [[EventManager shared] startListening];
    [[EventManager shared] addDelegate:self];

    return YES;
}

// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onEvent:(Event *)event
{
    if (event.type == kHasCoverage || event.type == kInPolygon) {
        NSDictionary *headers = @{ @"accept": @"application/json" };
        NSString *facebookId = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookId"];
        NSDictionary* parameters = @{ @"facebookId": facebookId,
                                       @"message" : [event asString] };

        [[UNIRest post:^(UNISimpleRequest* request) {
            [request setUrl:[kWebServiceHostname stringByAppendingString:@"/fenceentry"]];
            [request setHeaders:headers];
            [request setParameters:parameters];
            [request setUsername:@"admin"];
            [request setPassword:@"admin"];
        }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                NSLog(@"HTTP ping sent!");
            }
        }];
    }
}

- (void)setupTestData
{
    Polygon *polygon1 = [[Polygon alloc] initWithId:[NSNumber numberWithInteger:0]
                                               name:@"Refrigerator"
                                          locations:@[[[Location alloc] initWithX:0. y:0. z:0.],
                                                      [[Location alloc] initWithX:2. y:0. z:0.],
                                                      [[Location alloc] initWithX:2. y:1. z:0.],
                                                      [[Location alloc] initWithX:0. y:1. z:0.]]];
    [[PolygonManager shared] addPolygon:polygon1];
    
    Polygon *polygon2 = [[Polygon alloc] initWithId:[NSNumber numberWithInteger:0]
                                               name:@"Table"
                                          locations:@[[[Location alloc] initWithX:1. y:2. z:0.],
                                                      [[Location alloc] initWithX:4. y:2. z:0.],
                                                      [[Location alloc] initWithX:4. y:4. z:0.],
                                                      [[Location alloc] initWithX:1. y:4. z:0.]]];
    [[PolygonManager shared] addPolygon:polygon2];
}

@end
