//
//  Event.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/26/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)initWithType:(EventType)type
{
    if (self = [super init]) {
        _eid =  [NSNumber numberWithInteger:arc4random()];
        _type = type;
        _timestamp = [NSDate date];
    }
    
    return self;
}

- (NSString *)asString
{
    if (self.type == kNoCoverage) {
        return @"No Coverage";
    }
    else if (self.type == kHasCoverage) {
        return @"Has Coverage";
    }
    else {
        return @"Unknown";
    }
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToEvent:other];
}

- (BOOL)isEqualToEvent:(Event *)event
{
    if (self == event) {
        return YES;
    }
    
    if (self.type != event.type) {
        return NO;
    }
    
    return YES;
}

@end

@implementation PolygonEvent

- (instancetype)initWithType:(EventType)type
                     polygon:(Polygon *)polygon
{
    if (self = [super initWithType:type]) {
        _polygon = polygon;
    }

    return self;
}

- (NSString *)asString
{
    if (self.type == kInPolygon) {
        return [@"Inside Polygon: " stringByAppendingString:_polygon.name];
    }
    else {
        return [super asString];
    }
}

- (BOOL)isEqualToEvent:(PolygonEvent *)event
{
    if (![super isEqualToEvent:event]) {
        return NO;
    }
    
    if (!self.polygon || !event.polygon || ![self.polygon.pid isEqualToNumber:event.polygon.pid]) {
        return NO;
    }

    return YES;
}

@end