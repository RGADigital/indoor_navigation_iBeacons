//
//  PolygonManager.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/28/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "PolygonManager.h"

@interface PolygonManager ()

@property (strong, nonatomic) NSMutableSet *polygons;

@end

@implementation PolygonManager

+ (instancetype)shared
{
    static dispatch_once_t once;
    static PolygonManager *shared;
    
    dispatch_once(&once, ^ {
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        _polygons = [NSMutableSet set];
    }
    
    return self;
}

- (NSSet *)allPolygons
{
    return [_polygons copy];
}

- (Polygon *)getPolygonByID:(NSNumber *)pid
{
    if (pid) {
        for (Polygon *polygon in [self allPolygons]) {
            if ([pid isEqualToNumber:polygon.pid]) {
                return polygon;
            }
        }
    }
    
    return nil;
}

- (void)addPolygon:(Polygon *)polygon
{
    [_polygons addObject:polygon];
}

- (void)addPolygons:(NSSet *)polygons
{
    [_polygons addObjectsFromArray:[polygons allObjects]];
}

- (void)removePolygon:(Polygon *)polygon
{
    [_polygons minusSet:[NSSet setWithObject:polygon]];
}

- (void)removePolygons:(NSSet *)polygons
{
    [_polygons minusSet:polygons];
}

@end
