//
//  DebugMapViewController.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/5/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventManager.h"

@interface DebugMapViewController : UIViewController <EventManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *transmissions;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *transmissionMapView;
@property (weak, nonatomic) IBOutlet UIView *radiusHostView;
@property (weak, nonatomic) IBOutlet UIView *currentGreenPositionView;
@property (weak, nonatomic) IBOutlet UIView *currentRedPositionView;
@property (weak, nonatomic) IBOutlet UITableView *transimissionTableView;

@end
