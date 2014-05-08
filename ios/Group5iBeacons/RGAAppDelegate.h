//
//  RGAAppDelegate.h
//  Group5iBeacons
//
//  Created by John Tubert on 3/7/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventManager.h"

@interface RGAAppDelegate : UIResponder <UIApplicationDelegate, EventManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
