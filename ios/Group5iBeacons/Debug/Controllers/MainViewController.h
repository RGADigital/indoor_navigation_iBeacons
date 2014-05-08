//
//  MainViewController.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;

@end
