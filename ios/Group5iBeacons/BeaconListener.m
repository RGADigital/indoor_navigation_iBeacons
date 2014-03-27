//
//  BeaconListener.m
//  iBeacon-Geo-Demo
//
//  Created by admin on 3/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "BeaconListener.h"

@interface BeaconListener ()

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeacon *latestBeacon;

@property (assign, nonatomic) NSInteger consistencyCounter;
@property (assign, nonatomic) NSInteger consistencyMinor;

@end

@implementation BeaconListener

- (void)startListener:(NSString *)UUIDString
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUIDString];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                      identifier:@"com.rga.group5"];

    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)stopListener
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    NSMutableArray *filteredBeacons = [NSMutableArray array];
    
    for (CLBeacon *beacon in beacons) {
        if (!(beacon.accuracy < 0 || labs(beacon.rssi) < 40)) {
            [filteredBeacons addObject:beacon];
        }
    }
    
    NSInteger rssi = INT_MAX;
    CLBeacon *closestBeacon;

    for (NSUInteger i = 0; i < [filteredBeacons count]; i++) {
        CLBeacon *beacon = [filteredBeacons objectAtIndex:i];
        
        if (labs(beacon.rssi) < rssi) {
            closestBeacon = beacon;
            rssi = labs(beacon.rssi);
        }
    }
    
    if ([closestBeacon.minor intValue] != self.consistencyMinor) {
        self.consistencyMinor = [closestBeacon.minor intValue];
        self.consistencyCounter = 0;
    }
    else {
        self.consistencyCounter++;
    }
    
    if (closestBeacon.proximity == CLProximityNear && self.consistencyCounter > 0 && (!self.latestBeacon ||
            ([closestBeacon.minor intValue] != [self.latestBeacon.minor intValue] &&
             [closestBeacon.major intValue] != [self.latestBeacon.major intValue]))) {

        self.latestBeacon = closestBeacon;

        [self.delegate positionDetected:closestBeacon];
    }
}

@end