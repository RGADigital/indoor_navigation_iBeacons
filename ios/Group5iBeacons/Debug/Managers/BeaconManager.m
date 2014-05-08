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
    return @[ [BeaconManager findBeaconByMajor:5 andMinor:0],
               [BeaconManager findBeaconByMajor:5 andMinor:1],
                [BeaconManager findBeaconByMajor:5 andMinor:2] ];
}

+ (Beacon *)findBeaconByMajor:(NSUInteger)major
                     andMinor:(NSUInteger)minor
{
    if (minor == 0) { // beacon1 (iPhone NJ)
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:0 y:4 z:0]];
    }
    else if (minor == 1) { // beacon2 (iPhone PWC2)
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:4 y:0 z:0]];
    }
    else if (minor == 2) { // beacon3 (USB iBeacon)
        return [[Beacon alloc] initWithMajor:major
                                       minor:minor
                                    location:[[Location alloc] initWithX:0 y:0 z:0]];
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
