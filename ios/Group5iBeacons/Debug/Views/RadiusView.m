//
//  RadiusView.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/6/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "RadiusView.h"

#import "UIColor+Random.h"
#import "UIView+Additions.h"

@implementation RadiusView

- (id)initWithBeacon:(Beacon *)beacon
         centerPoint:(CGPoint)centerPoint
{
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.beacon = beacon;
        self.centerPoint = centerPoint;
        self.backgroundColor = [UIColor randomColor:0.2];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [self.backgroundColor darkerColor].CGColor;
    }
    
    return self;
}

- (void)drawCircle:(CGFloat)radis
{
    self.layer.bounds = CGRectMake(0, 0, radis * 2, radis * 2);
    self.layer.position = CGPointMake(self.centerPoint.x,
                                      self.centerPoint.y);
    self.layer.cornerRadius = radis;

    if (self.isHidden) {
        self.hidden = NO;
    }
    else {
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];

        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.duration = 0.6;
        animationGroup.removedOnCompletion = NO;
        animationGroup.animations = @[ boundsAnimation, positionAnimation, cornerRadiusAnimation ];

        [self.layer addAnimation:animationGroup forKey:nil];
    }
}

@end
