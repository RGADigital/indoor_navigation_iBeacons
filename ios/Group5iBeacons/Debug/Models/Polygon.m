//
//  Polygon.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/13/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "Polygon.h"

@implementation Polygon

- (instancetype)initWithId:(NSNumber *)pid
                      name:(NSString *)name
                 locations:(NSArray *)locations
{
    if (self = [super init]) {
        _pid = pid;
        _name = name;
        _locations = locations;
    }
    
    return self;
}

- (BOOL)contains:(Location *)location
{
    NSUInteger i, j;
    BOOL result = NO;
    
    for (i = 0, j = [self.locations count] - 1; i < [self.locations count]; j = i++) {
        Location *iloc = self.locations[i];
        Location *jloc = self.locations[j];
        
        if ((iloc.y > location.y) != (jloc.y > location.y) &&
            (location.x < (jloc.x - iloc.x) * (location.y - iloc.y) / (jloc.y - iloc.y) + iloc.x)) {
            result = !result;
        }
    }
    
    return result;
}


- (CGRect)boundingBox
{
    CGFloat minX = CGFLOAT_MAX,
            maxX = CGFLOAT_MIN,
            minY = CGFLOAT_MAX,
            maxY = CGFLOAT_MIN;
    
    for (Location *location in self.locations) {
        minX = MIN(location.x, minX);
        maxX = MAX(location.x, maxX);
        minY = MIN(location.y, minY);
        maxY = MAX(location.y, maxY);
    }
    
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

@end
