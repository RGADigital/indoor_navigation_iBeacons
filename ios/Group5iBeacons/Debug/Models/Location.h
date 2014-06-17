//
//  Location.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 3/26/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat z;

- (instancetype)initWithX:(CGFloat)x
                        y:(CGFloat)y
                        z:(CGFloat)z;

@end
