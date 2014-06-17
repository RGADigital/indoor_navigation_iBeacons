//
//  NonLinear.h
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/11/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Location.h"
#import "Transmission.h"

@interface NonLinear : NSObject

+ (Location *)determine:(NSArray *)transmissions;

@end
