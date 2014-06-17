//
//  RadiusLayer.m
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/15/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import "RadiusLayer.h"

@interface RadiusLayer ()

@end

@implementation RadiusLayer

+ (id)layerWithBeacon:(Beacon *)beacon
          centerPoint:(CGPoint)centerPoint
{
    RadiusLayer *layer = [RadiusLayer layer];
    layer.beacon = beacon;
    layer.centerPoint = centerPoint;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [[UIColor whiteColor] CGColor];
    layer.masksToBounds = NO;
    layer.lineWidth = 1;
    layer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4],
                                                        [NSNumber numberWithInt:4], nil];
    layer.lineCap = kCALineCapRound;

    return layer;
}

- (void)drawCircle:(CGFloat)radius
{
    UIBezierPath *newPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint
                                                           radius:radius
                                                       startAngle:0
                                                         endAngle:M_PI * 2
                                                        clockwise:YES];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setDuration:0.4 ];
    [animation setFromValue:(id)self.path];
    [animation setToValue:(id)newPath.CGPath];
    [animation setAutoreverses:NO];
    [animation setRemovedOnCompletion:NO];
    [animation setRepeatCount:0];
    [animation setFillMode:kCAFillModeBoth];
    [self addAnimation:animation forKey:@"path"];
    
    self.path = newPath.CGPath;
}

@end
