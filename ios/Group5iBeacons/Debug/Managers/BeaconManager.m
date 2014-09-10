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
    return @[ [BeaconManager findBeaconByMajor:5 andMinor:1],
              [BeaconManager findBeaconByMajor:5 andMinor:2],
              [BeaconManager findBeaconByMajor:5 andMinor:3],
              [BeaconManager findBeaconByMajor:5 andMinor:4] ];
}

+ (Beacon *)findBeaconByMajor:(NSUInteger)major
                     andMinor:(NSUInteger)minor
{
    if (major == 5 && minor == 1) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:0 y:0 z:0]];
    }
    else if (major == 5 && minor == 2) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:4 y:0 z:0]];
    }
    else if (major == 5 && minor == 3) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:4 y:4 z:0]];
    }
    else if (major == 5 && minor == 4) {
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:0 y:4 z:0]];
    }
    else {
        return nil;
    }
}

+ (Beacon *)findBeaconByCLBeacon:(CLBeacon *)beacon
{
    if (!beacon.major || !beacon.minor) {
        return nil;
    }
    else {
        return [self findBeaconByMajor:[beacon.major integerValue]
                              andMinor:[beacon.minor integerValue]];
    }

}

@end
