//
//  Transmission.h
//  G5-iBeacon-Demo
//
//  Created by Nemanja Joksovic on 3/4/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Beacon.h"

@interface Transmission : NSObject

@property (strong, nonatomic) Beacon *beacon;
@property (strong, nonatomic) NSDate *timestamp;
@property (assign, nonatomic) NSInteger rssi;
@property (assign, nonatomic) CGFloat accuracy;

- (instancetype)initWithBeacon:(Beacon *)beacon
                     timestamp:(NSDate *)timestamp
                          rssi:(NSInteger)rssi
                      accuracy:(CGFloat)accuracy;

- (instancetype)initWithCLBeacon:(CLBeacon *)beacon;

@end
