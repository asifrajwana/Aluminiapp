//
//  CurrentLocation.h
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocation : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *userLocationManager;
@property (nonatomic, retain) CLLocation *location;
-(void) getUserCurrentLocation;
@end
