//
//  BeaconListener.h
//  iBeacon-Geo-Demo
//
//  Created by admin on 3/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@protocol BeaconListenerDelegate

- (void)positionDetected:(CLBeacon *)beacon;

@end

@interface BeaconListener : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id<BeaconListenerDelegate> delegate;

- (void)startListener:(NSString *)UUIDString;
- (void)stopListener;

@end