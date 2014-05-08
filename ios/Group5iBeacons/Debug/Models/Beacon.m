//
//  Beacon.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/6/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "Beacon.h"

#import "BeaconManager.h"

@implementation Beacon

- (instancetype)initWithMajor:(NSUInteger)major
                        minor:(CGFloat)minor
                     location:(Location *)location
{
    if (self = [super init]) {
        _major = major;
        _minor = minor;
        _location = location;
    }
    
    return self;
}

- (BOOL)isEqualToBeacon:(Beacon *)beacon
{
    return beacon && beacon.major == self.major && beacon.minor == self.minor;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Minor: %ld, Major: %ld",
                                        (long)self.minor, (long)self.major];
}

@end
