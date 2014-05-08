//
//  EventLogViewController.m
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/27/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import "EventLogViewController.h"

@interface EventLogViewController ()

@end

@implementation EventLogViewController

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
    
    self.title = @"Event Log";

    _events = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[EventManager shared] addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[EventManager shared] removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onEvent:(Event *)event
{
    NSLog(@"Event: %@", event);
    
    _events = [_events arrayByAddingObject:event];
    
    [_tableView reloadData];
}

#pragma mark --
#pragma mark UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events ? [_events count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *eventLogTableIdentifier = @"EventLogTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eventLogTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:eventLogTableIdentifier];
    }
    
    Event *event = [_events objectAtIndex:indexPath.row];

    cell.textLabel.text = [event asString];
    
    return cell;
}

@end
