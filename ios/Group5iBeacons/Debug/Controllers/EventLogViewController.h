//
//  EventLogViewController.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventManager.h"

@interface EventLogViewController : UIViewController <EventManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *events;

@end
