//
//  MainViewController.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "MainViewController.h"

#import "Global.h"
#import "EventLogViewController.h"
#import "DebugMapViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    self.title = @"G5 iBeacons Demo";
    self.items = @[ @"Debug Map", @"Event Log" ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --
#pragma mark UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items ? [_items count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainTableIdentifier = @"MainTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:mainTableIdentifier];
    }
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        if (IS_IPHONE) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Supported"
                                                                message:@"Debug Map is available only for iPad."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if (IS_IPAD) {
            [self.navigationController pushViewController:[[DebugMapViewController alloc] init]
                                                 animated:YES];
        }
    }
    else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[[EventLogViewController alloc] init]
                                             animated:YES];
    }
}

@end
