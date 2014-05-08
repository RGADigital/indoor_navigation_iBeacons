//
//  EventManager.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/26/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Event.h"

@protocol EventManagerDelegate <NSObject>

@optional
- (void)onTransmissions:(NSArray *)transmissions;
- (void)onEvent:(Event *)event;

@end

@interface EventManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)shared;

- (void)startListening;
- (void)stopListening;

- (void)addDelegate:(id<EventManagerDelegate>)delegate;
- (void)removeDelegate:(id<EventManagerDelegate>)delegate;

@end
