//
//  Transmission.m
//  G5-iBeacon-Demo
//
//  Created by Nemanja Joksovic on 3/4/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "Transmission.h"

#import "NSDate+Print.h"

#import "BeaconManager.h"

@implementation Transmission

- (instancetype)initWithBeacon:(Beacon *)beacon
                     timestamp:(NSDate *)timestamp
                          rssi:(NSInteger)rssi
                      accuracy:(CGFloat)accuracy
{
    if (self = [super init]) {
        _beacon = beacon;
        _timestamp = timestamp;
        _rssi = rssi;
        _accuracy = (accuracy < 0) ? 0 : accuracy;
    }
    
    return self;
}

- (instancetype)initWithCLBeacon:(CLBeacon *)beacon
{
    return [self initWithBeacon:[BeaconManager cast:beacon]
                      timestamp:[NSDate date]
                           rssi:beacon.rssi
                       accuracy:beacon.accuracy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Beacon: %@, Timestamp: %@, RSSI: %ld, Accuracy: %f",
                                        self.beacon, [self.timestamp asString], (long)self.rssi, self.accuracy];
}

@end
