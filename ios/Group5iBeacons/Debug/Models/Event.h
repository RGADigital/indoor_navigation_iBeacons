//
//  Event.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/26/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Polygon.h"

typedef enum {
    kHasCoverage,
    kNoCoverage,
    kInPolygon,
    kCalculating
} EventType;

@interface Event : NSObject

- (instancetype)initWithType:(EventType)type;

@property (strong, nonatomic) NSNumber *eid;
@property (assign, nonatomic) EventType type;
@property (strong, nonatomic) NSDate *timestamp;

- (NSString *)asString;

- (BOOL)isEqualToEvent:(Event *)event;

@end

@interface PolygonEvent : Event

- (instancetype)initWithType:(EventType)type
             polygon:(Polygon *)polygon;

@property (strong, nonatomic) Polygon *polygon;

@end
