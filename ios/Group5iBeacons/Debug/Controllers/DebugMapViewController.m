//
//  DebugMapViewController.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/5/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "DebugMapViewController.h"

#import "Global.h"
#import "Transmission.h"
#import "BeaconManager.h"
#import "Polygon.h"
#import "EventManager.h"
#import "PolygonManager.h"
#import "RadiusView.h"
#import "PolygonView.h"
#import "UIView+Additions.h"
#import "NonLinear.h"
#import "Trilateration.h"

#define kCurrentPinEdge 20

@interface DebugMapViewController ()

@property (assign, nonatomic) CGFloat scaleFactor;
@property (assign, nonatomic) CGFloat maxY;

- (void)renderTransmissionMap;
- (CGRect)calculatePinRect:(Location *)location;
- (void)updateRadiusCircles:(NSArray *)transmissions;

@end

@implementation DebugMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Debug Map";

    [self renderTransmissionMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (Polygon *polygon in [[PolygonManager shared] allPolygons]) {
        PolygonView *polygonView = [PolygonView viewWithPolygon:polygon
                                                      plotFrame:self.transmissionMapView.bounds
                                                    scaleFactor:self.scaleFactor];
        [self.transmissionMapView addSubview:polygonView];
    }
    
    [[EventManager shared] addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[EventManager shared] removeDelegate:self];
}

#pragma mark -
#pragma mark Private methods

- (void)renderTransmissionMap
{
    NSArray *beacons = [BeaconManager allBeacons];
    
    CGFloat minCoordinate = -CGFLOAT_MIN;
    CGFloat maxCoordinate = -CGFLOAT_MIN;
    
    for (NSInteger i = 0; i < [beacons count]; i++) {
        Beacon *beacon = [beacons objectAtIndex:i];
        Location *location = beacon.location;
        
        if (location.x < minCoordinate)
            minCoordinate = location.x;
        
        if (location.x > maxCoordinate)
            maxCoordinate = location.x;
        
        if (location.y < minCoordinate)
            minCoordinate = location.y;
        
        if (location.y > maxCoordinate)
            maxCoordinate = location.y;
    }
    
    self.scaleFactor = self.transmissionMapView.frame.size.width / (maxCoordinate - minCoordinate);
    self.maxY = (maxCoordinate - minCoordinate) * self.scaleFactor;
    
    for (NSUInteger i = 0; i < [beacons count]; i++) {
        Beacon *beacon = [beacons objectAtIndex:i];
        
        UILabel *pinLabel = [[UILabel alloc] initWithFrame:[self calculatePinRect:beacon.location]];
        [pinLabel setText:[NSString stringWithFormat:@"%lu", (long) i]];
        [pinLabel setBackgroundColor:[UIColor blackColor]];
        [pinLabel setTextColor:[UIColor whiteColor]];
        [pinLabel setTextAlignment:NSTextAlignmentCenter];
        [pinLabel setFont:kDefaultFont];
        [pinLabel.layer setMasksToBounds:YES];
        [pinLabel.layer setCornerRadius:10];
        [self.transmissionMapView addSubview:pinLabel];
        
        RadiusView *radiusView = [[RadiusView alloc] initWithBeacon:beacon
                                                        centerPoint:pinLabel.center];
        [self.radiusHostView addSubview:radiusView];
    }
    
    [self.currentRedPositionView setHidden:YES];
    [self.currentRedPositionView.layer setMasksToBounds:YES];
    [self.currentRedPositionView.layer setCornerRadius:10];

    [self.currentGreenPositionView setHidden:YES];
    [self.currentGreenPositionView.layer setMasksToBounds:YES];
    [self.currentGreenPositionView.layer setCornerRadius:10];
}

- (CGRect)calculatePinRect:(Location *)location
{
    return CGRectMake((location.x * self.scaleFactor) - kCurrentPinEdge / 2,
                      (self.maxY - (location.y * self.scaleFactor)) - kCurrentPinEdge / 2,
                      kCurrentPinEdge,
                      kCurrentPinEdge);
}

- (void)updateRadiusCircles:(NSArray *)transmissions
{
    NSMutableArray *radiusViews = [NSMutableArray array];
    
    for (UIView *view in [self.radiusHostView subviews]) {
        if ([view isKindOfClass:[RadiusView class]]) {
            RadiusView *radiusView = (RadiusView *)view;
            [radiusView setRefreshed:NO];
            [radiusViews addObject:radiusView];
        }
    }
    
    for (Transmission *transmission in transmissions) {
        for (RadiusView *radiusView in radiusViews) {
            if ([radiusView.beacon isEqualToBeacon:transmission.beacon]) {
                [radiusView drawCircle:transmission.accuracy * self.scaleFactor];
                [radiusView setRefreshed:YES];
            }
        }
    }
    
    for (RadiusView *radiusView in radiusViews) {
        if (![radiusView isRefreshed]) {
            [radiusView setHidden:YES];
        }
    }
}

#pragma mark -
#pragma mark EventManager delegate methods

- (void)onTransmissions:(NSArray *)transmissions
{
    Location *nl = [NonLinear determine:transmissions];

    [Trilateration trilaterate:transmissions
                       success:^(Location *location) {
                           [self.positionLabel setText:[NSString stringWithFormat:@"TR (%.1f, %.1f), NL (%.1f, %.1f)",
                                                            location.x, location.y, nl.x, nl.y ]];
                              
                           [UIView animateWithDuration:0.7
                                            animations:^{
                                                [self.currentRedPositionView setHidden:NO];
                                                [self.currentRedPositionView setFrame:[self calculatePinRect:location]];
                                                   
                                                if (nl) {
                                                    [self.currentGreenPositionView setHidden:NO];
                                                    [self.currentGreenPositionView setFrame:[self calculatePinRect:nl]];
                                                }
                                                else {
                                                    [self.currentGreenPositionView setHidden:YES];
                                                }
                                            }
                               ];
                          }
                       failure:^(NSError *error) {
                           [self.positionLabel setText:[NSString stringWithFormat:@"TR (N/A), NL (%.1f, %.1f)", nl.x, nl.y]];
                           [self.currentRedPositionView setHidden:YES];
                           
                           if (nl) {
                                [self.currentGreenPositionView setHidden:NO];
                                [self.currentGreenPositionView setFrame:[self calculatePinRect:nl]];
                            }
                            else {
                                [self.currentGreenPositionView setHidden:YES];
                            }
                       }
        ];

    // Reload debug table
    self.transmissions = transmissions;
    [self.transimissionTableView reloadData];
    
    // Update circle radius
    [self updateRadiusCircles:transmissions];
}

#pragma mark -
#pragma mark TableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.transmissions ? [self.transmissions count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TransmissionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:kDefaultFont];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }

    Transmission *transmission = [self.transmissions objectAtIndex:indexPath.row];

    [cell.textLabel setText:[NSString stringWithFormat:@"%lu: %@",
                             (long)indexPath.row, [transmission description]]];

    return cell;
}

@end
