//
//  Global.h
//  iBeacon-Geo-Demo
//
//  Created by Nemanja Joksovic on 4/5/14.
//  Copyright (c) 2014 R/GA. All rights reserved.
//

#define kBeaconProximityUUID @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"
#define kBeaconRegionIdentifier @"com.rga.iBeacon-Geo-Demo"
#define kWebServiceHostname @"http://radiant-basin-9738.herokuapp.com"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kDefaultFont [UIFont fontWithName:@"HelveticaNeue-Light" size:IS_IPHONE ? 11 : 14]

