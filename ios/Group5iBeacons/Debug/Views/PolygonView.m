//
//  PolygonView.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/14/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "PolygonView.h"

#import "Global.h"

@implementation PolygonView

+ (instancetype)viewWithPolygon:(Polygon *)polygon
                      plotFrame:(CGRect)plotFrame
                    scaleFactor:(CGFloat)scaleFactor
{
    PolygonView *polygonView = [[PolygonView alloc] initWithFrame:plotFrame];
    polygonView.backgroundColor = [UIColor clearColor];
    polygonView.polygon = polygon;
    polygonView.scaleFactor = scaleFactor;
    
    return polygonView;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);

    CGContextSetRGBFillColor(context, 100./255., 100./255., 100./255., 0.2);
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);

    for (int idx = 0; idx < [self.polygon.locations count]; idx++) {
        Location *location = [self.polygon.locations objectAtIndex:idx];
        
        if (idx == 0) {
            CGContextMoveToPoint(context,
                                 location.x * self.scaleFactor,
                                 location.y * self.scaleFactor);
        }
        else {
            CGContextAddLineToPoint(context,
                                    location.x * self.scaleFactor,
                                    location.y * self.scaleFactor);
        }
    }
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{ NSFontAttributeName: kDefaultFont,
                                  NSForegroundColorAttributeName: [UIColor redColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.polygon.name
                                                                           attributes:attributes];
    
    CGRect boundingBox = [self.polygon boundingBox];
    CGRect scaledBoundingBox = CGRectMake(boundingBox.origin.x * self.scaleFactor,
                                          boundingBox.origin.y * self.scaleFactor,
                                          boundingBox.size.width * self.scaleFactor,
                                          boundingBox.size.height * self.scaleFactor);
    
    [attributedString drawInRect:scaledBoundingBox];
}

@end
