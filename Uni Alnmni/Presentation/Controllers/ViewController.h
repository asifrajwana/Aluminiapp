//
//  ViewController.h
//  Uni Alnmni
//
//  Created by asif on 13/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import <Parse/Parse.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    User *user;
}
@property (strong, nonatomic) NSString *current_city;
@property (strong, nonatomic) PFGeoPoint *geo_location;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
    @property (nonatomic, retain) OAuthLoginView *oAuthLoginView;

@property (nonatomic, retain) CLLocationManager *userLocationManager;
@property (nonatomic, retain) CLLocation *location;

@end

