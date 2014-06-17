//
//  MapViewController.h
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/13/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "EventManager.h"

@interface MapViewController : UIViewController <EventManagerDelegate>

@property (strong, nonatomic) NSArray *transmissions;

@end
