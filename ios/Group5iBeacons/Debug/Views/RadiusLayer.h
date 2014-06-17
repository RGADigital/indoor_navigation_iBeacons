//
//  RadiusLayer.h
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/15/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Beacon.h"

@interface RadiusLayer : CAShapeLayer

@property (strong, nonatomic) Beacon *beacon;
@property (assign, nonatomic) CGPoint centerPoint;
@property (assign, nonatomic, getter = isRefreshed) BOOL refreshed;

+ (id)layerWithBeacon:(Beacon *)beacon
          centerPoint:(CGPoint)centerPoint;

- (void)drawCircle:(CGFloat)radius;

@end
