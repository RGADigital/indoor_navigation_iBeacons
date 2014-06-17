//
//  PolygonView.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/14/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "PolygonView.h"

#import "Global.h"
#import "UIView+Additions.h"

@implementation PolygonView

+ (instancetype)viewWithPolygon:(Polygon *)polygon
                      plotFrame:(CGRect)plotFrame
                    scaleFactor:(CGFloat)scaleFactor
{
    PolygonView *polygonView = [[PolygonView alloc] initWithFrame:plotFrame];
    polygonView.clipsToBounds = NO;
    polygonView.backgroundColor = [UIColor clearColor];
    polygonView.polygon = polygon;
    polygonView.scaleFactor = scaleFactor;
    
    return polygonView;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.0);

    CGContextSetRGBFillColor(context, 255./255., 255./255., 255./255., 0.2);

    for (int idx = 0; idx < [self.polygon.locations count]; idx++) {
        Location *location = [self.polygon.locations objectAtIndex:idx];
        
        if (idx == 0) {
            CGContextMoveToPoint(context,
                                 location.x * self.scaleFactor,
                                 self.height - location.y * self.scaleFactor);
        }
        else {
            CGContextAddLineToPoint(context,
                                    location.x * self.scaleFactor,
                                    self.height - location.y * self.scaleFactor);
        }
    }
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:17],
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.polygon.name
                                                                           attributes:attributes];
    
    CGRect boundingBox = [self.polygon boundingBox];
    CGRect scaledBoundingBox = CGRectMake(boundingBox.origin.x * self.scaleFactor,
                                          self.height - (boundingBox.origin.y + boundingBox.size.height) * self.scaleFactor,
                                          boundingBox.size.width * self.scaleFactor,
                                          boundingBox.size.height * self.scaleFactor);
    
    [attributedString drawInRect:scaledBoundingBox];
}

@end
