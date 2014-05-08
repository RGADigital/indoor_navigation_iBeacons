//
//  PolygonManager.h
//  iBeacon-Geo-Demo
//
//  Created by admin on 4/28/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Polygon.h"

@interface PolygonManager : NSObject

+ (instancetype)shared;

- (NSSet *)allPolygons;

- (void)addPolygon:(Polygon *)polygon;
- (void)addPolygons:(NSSet *)polygons;

- (void)removePolygon:(Polygon *)polygon;
- (void)removePolygons:(NSSet *)polygons;

@end
