//
//  Location.m
//  iBeacon-Geo-Demo
//
//  Created by admin on 3/26/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithX:(CGFloat)x
                        y:(CGFloat)y
                        z:(CGFloat)z;
{
    if (self = [super init]) {
        _x = x;
        _y = y;
        _z = z;
    }
    
    return self;
}

@end
