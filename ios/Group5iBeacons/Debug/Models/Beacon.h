//
//  Beacon.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/6/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Location.h"
#import "Beacon.h"

@interface Beacon : NSObject

@property (assign, nonatomic) NSUInteger major;
@property (assign, nonatomic) NSUInteger minor;
@property (strong, nonatomic) Location *location;

- (instancetype)initWithMajor:(NSUInteger)major
                        minor:(NSUInteger)minor
                     location:(Location *)location;

- (BOOL)isEqualToBeacon:(Beacon *)beacon;

@end
