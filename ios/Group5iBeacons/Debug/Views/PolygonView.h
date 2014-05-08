//
//  PolygonView.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/14/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Polygon.h"

@interface PolygonView : UIView

@property (strong, nonatomic) Polygon *polygon;
@property (assign, nonatomic) CGFloat scaleFactor;

+ (instancetype)viewWithPolygon:(Polygon *)polygon
                      plotFrame:(CGRect)plotFrame
                    scaleFactor:(CGFloat)scaleFactor;

@end
