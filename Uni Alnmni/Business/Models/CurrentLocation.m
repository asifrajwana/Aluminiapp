//
//  CurrentLocation.m
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "CurrentLocation.h"

@implementation CurrentLocation

@synthesize userLocationManager;

-(void) getUserCurrentLocation
{
    if (![CLLocationManager locationServicesEnabled])
    {
    
        UIAlertView *alertToEnableDeviceLocation = [[UIAlertView alloc] initWithTitle:@"LocationServices"
                                                                              message:@"Please Enable Location Services from Settings to use this App"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
        [alertToEnableDeviceLocation show];
        
    }
    else
    {
        
        userLocationManager = [[CLLocationManager alloc] init];
        
        switch([CLLocationManager authorizationStatus])
        {   NSLog(@"here");
            case kCLAuthorizationStatusNotDetermined:
                
                if ([userLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                {
                    [userLocationManager requestWhenInUseAuthorization];
                    userLocationManager.delegate = self;
                }
                break;
            case kCLAuthorizationStatusRestricted:
                
                break;
            case kCLAuthorizationStatusDenied:
            {
                
                UIAlertView *alertToAuth = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please allow MMAO to use your location from device settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertToAuth show];
                
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                //[SVProgressHUD showWithStatus:@"Detecting Location" maskType:SVProgressHUDMaskTypeClear];
                userLocationManager.delegate = self;
                userLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [userLocationManager startUpdatingLocation];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark pragma CLLocationManager Delegate Implementation

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status== kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //[SVProgressHUD showWithStatus:@"Detecting Location" maskType:SVProgressHUDMaskTypeClear];
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [userLocationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //[SVProgressHUD showErrorWithStatus:@"Error"];
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    
    [self getReverseGeocode:self.location];
    
    [manager stopUpdatingLocation];
}


- (void) getReverseGeocode : (CLLocation *) location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             //[SVProgressHUD showErrorWithStatus:@"Error in retreiving Location"];
             return;
         }
         if(placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             NSString *country = @"";
             NSString *state = @"";
             
             if([placemark.addressDictionary objectForKey:@"State"] != NULL)
                 state = [placemark.addressDictionary objectForKey:@"State"];
             if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                 country = [placemark.addressDictionary objectForKey:@"Country"];
             
             NSLog(@"%@",country);
             
            
             
            // [SVProgressHUD showSuccessWithStatus:@"Location Found"];
         }
     }];
}

@end
