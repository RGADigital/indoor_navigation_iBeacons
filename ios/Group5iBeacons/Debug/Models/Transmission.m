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

+ (instancetype)transmissionWithCLBeacon:(CLBeacon *)CLBeacon
{
    if (CLBeacon.rssi == 0 && CLBeacon.accuracy == 0) {
        return nil;
    }
    else {
        Beacon *beacon = [BeaconManager findBeaconByCLBeacon:CLBeacon];
    
        if (!beacon) {
            return nil;
        }
        else {
            return [[Transmission alloc] initWithBeacon:beacon
                                              timestamp:[NSDate date]
                                                   rssi:CLBeacon.rssi
                                               accuracy:CLBeacon.accuracy];
        }
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Beacon: %@, Timestamp: %@, RSSI: %ld, Accuracy: %f",
                                        self.beacon, [self.timestamp asString], (long)self.rssi, self.accuracy];
}

@end
