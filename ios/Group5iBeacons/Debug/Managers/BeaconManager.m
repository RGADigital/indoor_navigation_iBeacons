//
//  BeaconManager.m
//  G5-iBeacon-Demo
//
//  Created by Nemanja Joksovic on 3/3/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "BeaconManager.h"

@implementation BeaconManager

// TODO: replace with a registry
+ (NSArray *)allBeacons
{
    return @[ [BeaconManager findBeaconByMajor:5 andMinor:2],
              [BeaconManager findBeaconByMajor:1 andMinor:838],
              [BeaconManager findBeaconByMajor:1 andMinor:1027] ];
}

+ (Beacon *)findBeaconByMajor:(NSUInteger)major
                     andMinor:(NSUInteger)minor
{
    if (major == 1 && minor == 1027) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:2 y:0 z:0]];
    }
    else if (major == 1 && minor == 838) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:4 y:0 z:0]];
    }
    else if (major == 5 && minor == 2) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:0 y:3 z:0]];
    }
    else {
        return nil;
    }
}

+ (Beacon *)cast:(CLBeacon *)beacon
{
    return [self findBeaconByMajor:[beacon.major integerValue]
                          andMinor:[beacon.minor integerValue]];

}

@end
