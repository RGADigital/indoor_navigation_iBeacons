//
//  Polygon.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/13/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Location.h"

@interface Polygon : NSObject

@property (strong, nonatomic) NSNumber *pid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *locations;

- (instancetype)initWithId:(NSNumber *)pid
                      name:(NSString *)name
                 locations:(NSArray *)locations;

/**
 * Return true if the given point is contained inside the polygon.
 * See: http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
 * @param location The Location to check
 * @return YES if the location is inside the polygon, NO otherwise
 *
 */
- (BOOL)contains:(Location *)location;

- (CGRect)boundingBox;

@end
