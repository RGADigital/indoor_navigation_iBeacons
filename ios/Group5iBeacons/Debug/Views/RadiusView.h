//
//  RadiusView.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/6/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Beacon.h"

@interface RadiusView : UIView

@property (strong, nonatomic) Beacon *beacon;
@property (assign, nonatomic) CGPoint centerPoint;
@property (assign, nonatomic, getter = isRefreshed) BOOL refreshed;

- (id)initWithBeacon:(Beacon *)beacon
         centerPoint:(CGPoint)centerPoint;

- (void)drawCircle:(CGFloat)radis;

@end
