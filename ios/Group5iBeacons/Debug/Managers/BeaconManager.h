//
//  BeaconManager.h
//  G5-iBeacon-Demo
//
//  Created by Nemanja Joksovic on 3/3/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Beacon.h"
#import "Location.h"

@interface BeaconManager : NSObject

+ (NSArray *)allBeacons;

+ (Beacon *)findBeaconByMajor:(NSUInteger)major
                     andMinor:(NSUInteger)minor;

+ (Beacon *)findBeaconByCLBeacon:(CLBeacon *)beacon;

@end
