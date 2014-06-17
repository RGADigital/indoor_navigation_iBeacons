//
//  MapViewController.m
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/13/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import "MapViewController.h"

#import "Global.h"
#import "Transmission.h"
#import "BeaconManager.h"
#import "Polygon.h"
#import "EventManager.h"
#import "PolygonManager.h"
#import "RadiusLayer.h"
#import "PolygonView.h"
#import "UIView+Additions.h"
#import "LocationManager.h"

#define kBeaconEdge 20
#define kUserEdge 40

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIView *transmissionMapView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (assign, nonatomic) CGFloat scaleFactor;

- (void)renderLayout;
- (CGRect)calculatePinRect:(Location *)location
                      edge:(CGFloat)edge;
- (void)updateRadiusCircles:(NSArray *)transmissions;
- (IBAction)pingTapped:(id)sender;

@end

@implementation MapViewController

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
    
    self.profilePictureView.layer.cornerRadius = 20;
    self.profilePictureView.profileID = [RGAAppDelegate shared].user.id;
    
    [[EventManager shared] addDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self renderLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -
#pragma mark Private methods

- (void)renderLayout
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
    
    self.scaleFactor = self.transmissionMapView.width / (maxCoordinate - minCoordinate);
    
    for (NSUInteger i = 0; i < [beacons count]; i++) {
        Beacon *beacon = [beacons objectAtIndex:i];
        
        UIImage *beaconIcon = [UIImage imageNamed:@"beacon_icon"];
        UIImageView *beaconImageView = [[UIImageView alloc] initWithImage:beaconIcon];
        beaconImageView.frame = [self calculatePinRect:beacon.location
                                                  edge:kBeaconEdge];
        [self.transmissionMapView addSubview:beaconImageView];
        
        RadiusLayer *radiusLayer = [RadiusLayer layerWithBeacon:beacon
                                                    centerPoint:beaconImageView.center];
        [self.transmissionMapView.layer addSublayer:radiusLayer];
    }
    
    for (Polygon *polygon in [[PolygonManager shared] allPolygons]) {
        PolygonView *polygonView = [PolygonView viewWithPolygon:polygon
                                                      plotFrame:self.transmissionMapView.bounds
                                                    scaleFactor:self.scaleFactor];
        [self.transmissionMapView addSubview:polygonView];
    }
}

- (CGRect)calculatePinRect:(Location *)location
                      edge:(CGFloat)edge
{
    return CGRectMake((location.x * self.scaleFactor) - edge / 2,
                      (self.transmissionMapView.height - location.y * self.scaleFactor) - edge / 2,
                      edge,
                      edge);
}

- (void)updateRadiusCircles:(NSArray *)transmissions
{
    NSMutableArray *radiusLayers = [NSMutableArray array];
    
    for (CALayer *layer in [self.transmissionMapView.layer sublayers]) {
        if ([layer isKindOfClass:[RadiusLayer class]]) {
            RadiusLayer *radiusLayer = (RadiusLayer *)layer;
            [radiusLayer setRefreshed:NO];
            [radiusLayers addObject:radiusLayer];
        }
    }
    
    for (Transmission *transmission in transmissions) {
        for (RadiusLayer *radiusLayer in radiusLayers) {
            if ([radiusLayer.beacon isEqualToBeacon:transmission.beacon]) {
                [radiusLayer drawCircle:transmission.accuracy * self.scaleFactor];
                [radiusLayer setHidden:NO];
                [radiusLayer setRefreshed:YES];
            }
        }
    }
    
    for (RadiusLayer *radiusLayer in radiusLayers) {
        if (![radiusLayer isRefreshed]) {
            [radiusLayer setHidden:YES];
        }
    }
}

- (IBAction)pingTapped:(id)sender
{
    // fake polygon event
    Polygon *polygon = [[[PolygonManager shared] allPolygons] anyObject];
    PolygonEvent *polygonEvent = [[PolygonEvent alloc] initWithType:kEnterPolygon
                                                            polygon:polygon];
    [[RGAAppDelegate shared] onEvent:polygonEvent];
}

#pragma mark -
#pragma mark EventManager delegate methods

- (void)onTransmissions:(NSArray *)transmissions
{
    // Update local data
    self.transmissions = transmissions;

    // Determine location
    [LocationManager determine:transmissions
                       success:^(Location *location) {
                           [self.profilePictureView setHidden:NO];

                           [UIView animateWithDuration:0.4
                                            animations:^{
                                                [self.profilePictureView setFrame:[self calculatePinRect:location
                                                                                                    edge:kUserEdge]];
                                            }
                            ];
                       } failure:^(NSError *error) {
                           [self.profilePictureView setHidden:YES];
                       }
     ];
    

    // Update circle radius
    [self updateRadiusCircles:transmissions];
    
    // Update settings button
    NSString *title = [transmissions count] == 0 ? @"No Beacons Found" :
    [NSString stringWithFormat:@"%lu Beacons Found", (long) [transmissions count]];
    
    [self.settingsButton setTitle:title
                         forState:UIControlStateNormal];
}

@end
