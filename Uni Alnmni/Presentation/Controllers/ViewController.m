//
//  ViewController.m
//  Uni Alnmni
//
//  Created by asif on 13/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "ViewController.h"

#import "CurrentLocation.h"
#import <AFNetworking/AFNetworking.h>
#import "AlumniNearByViewController.h"


@interface ViewController ()
{

}


@end

@implementation ViewController

@synthesize oAuthLoginView, userLocationManager;

bool isAlumni;
NSDictionary *json;

NSString *userLoginToken;
int first_random_no,second_random_no;
UIAlertView *alertToEnableDeviceLocation;


- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    NSString *access_token = [defaults objectForKey:@"access_token"];
    [self getUserCurrentLocation];
    if (access_token) {
        [self first_Alumni_Hit];
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark pragma SignIn_Into_LinkedIn_And_Getting Data

- (IBAction)signInLinkedIn:(id)sender {
    
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
    self.loader.hidden = false;
    [self.loader startAnimating];
    
    [self presentViewController:oAuthLoginView animated:YES completion:nil];
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
    NSDictionary *userinfo = notification.userInfo;
    if([[userinfo objectForKey:@"isLogin"] isEqualToString:@"Yes"]){
        //[self performSegueWithIdentifier:@"Homescreen" sender:self];
//        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
//         [self prepareForSegue:myController sender:nil];
//        [self presentViewController:myController animated:YES completion:nil];
    }else{
        [self.loader stopAnimating];
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
    
}

- (void)profileApiCall
{
        NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,location,industry,picture-url,educations,email-address,main-address)?format=json"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSError *error;
    //NSString *responseBody = [[NSString alloc] initWithData:data
    //                                               encoding:NSUTF8StringEncoding];
    
    json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
   
    //NSLog(@"Profile responce: %@",responseBody);
    
    //NSDictionary *profile = [responseBody objectFromJSONString];
    
        if ( json )
        {
            NSLog(@"%@",userLoginToken);
            
            PFQuery *query = [PFQuery queryWithClassName:@"LinkedInUser"];
            [query whereKey:@"email" equalTo:[json objectForKey:@"emailAddress"]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
             
                if (object) {
                    NSLog(@"Object = %@", object);
                    user = [[User alloc] init];
                    user.email = object[@"email"];
                    user.firstName = object[@"firstName"];
                    user.lastName = object[@"lastName"];
                    user.middleName = object[@"middleName"];
                    user.industry = object[@"industry"];
                    user.pictureUrl = object[@"pictureUrl"];
                    user.locationName = object[@"locationName"];
                    PFGeoPoint *location = object[@"coordinates"];
                    user.latitude = location.latitude;
                    user.longitude = location.longitude;
                    user.address = object[@"address"];
                    user.isAlumni =[object[@"isAlumni"] boolValue];
                    user.isActive =[object[@"isActive"] boolValue];
                    
                    if (user.firstName == nil) {
                        user.firstName = @"";
                    }if (user.lastName == nil) {
                        user.lastName = @"";
                    }if (user.email == nil) {
                        user.email = @"";
                    }if (user.address == nil) {
                        user.address = @"";
                    }if (user.pictureUrl == nil) {
                        user.pictureUrl = @"";
                    }
                    
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:[NSNumber numberWithBool:user.isAlumni] forKey:@"isAlumni"];
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:user.firstName,
                                           user.lastName,
                                           user.email,
                                           user.address,
                                           user.pictureUrl, nil] ; // set value
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    [defaults setObject:data forKey:@"user"];
                    [defaults synchronize];
                    if (!user.isAlumni) {
                        [self first_Alumni_Hit];
                    }else{
                        [self performSegueWithIdentifier:@"Homescreen" sender:self];
                    }
                    
                    
                }
                else if (error)
                {
                    if (error.code==101) {
                        NSString *addressmain = [json objectForKey:@"mainAddress"];
                        if (addressmain != nil) {
                            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                            [geocoder geocodeAddressString:addressmain
                                         completionHandler:^(NSArray* placemarks, NSError* error){
                                             if (placemarks.count > 0) {
                                                 int count = 0;
                                                 for (CLPlacemark* aPlacemark in placemarks)
                                                 {
                                                     count++;
                                                     NSLog(@"Name = %@", aPlacemark.locality);
                                                     NSLog(@"Current Location:%lu",(unsigned long)placemarks.count);
                                                     if ([aPlacemark.locality isEqualToString:self.current_city]) {
                                                         self.geo_location = [PFGeoPoint geoPointWithLocation:self.location];
                                                     }else if (placemarks.count == count){
                                                     
                                                         UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your current location does not match to your LinkedIn address. Please search and select your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                         [chose_current_location show];
                                                         [self performSegueWithIdentifier:@"GETTING_CURRENT_LOCATION" sender:self];
                                                     }
                                                 }
                                             }else {
                                                 NSLog(@"Error : %@",error);
                                                 UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your current location does not match to your LinkedIn address. Please search and select your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                 [chose_current_location show];
                                                 [self performSegueWithIdentifier:@"GETTING_CURRENT_LOCATION" sender:self];
                                             }
                                             
                                         }];
                        }else {
                        
                            UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your LinkedIn address not found. Please search and select your current location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [chose_current_location show];
                            [self performSegueWithIdentifier:@"GETTING_CURRENT_LOCATION" sender:self];
                        }
                        
                        if (self.geo_location != nil) {
                            [self saveLinkedInUserOnParse:json];
                        }
                    
                    }

                }
            }];
            
            //headline.text = [profile objectForKey:@"headline"];
        }
    
    // The next thing we want to do is call the network updates
    //[self networkApiCall];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"Error in Login%@",[error description]);
}

#pragma mark pragma Save_LinkedIn_Data_On_Parse

-(void)saveLinkedInUserOnParse : (NSDictionary *) dataOfLinkedInUser {
    
    
    
    PFObject *newLinkedInUser = [PFObject objectWithClassName:@"LinkedInUser"];
    
    NSString *email = [dataOfLinkedInUser objectForKey:@"emailAddress"];
    NSString *firstName = [dataOfLinkedInUser objectForKey:@"firstName"];
    NSString *lastName = [dataOfLinkedInUser objectForKey:@"lastName"];
    NSString *middleName = [dataOfLinkedInUser objectForKey:@"maidenName"];
    NSString *industry = [dataOfLinkedInUser objectForKey:@"industry"];
    NSString *pictureUrl = [dataOfLinkedInUser objectForKey:@"pictureUrl"];
    NSDictionary *locationDict = [dataOfLinkedInUser objectForKey:@"location"];
    NSString *locationName = [locationDict objectForKey:@"name"];
    NSString *address = [dataOfLinkedInUser objectForKey:@"mainAddress"];
    //NSString *coordinates = [NSString stringWithFormat:@"%.4f",self.location.coordinate.latitude];
    user = [User new];
    if (email != nil) {
        newLinkedInUser[@"email"] = user.email = email;
    }if (firstName != nil) {
        newLinkedInUser[@"firstName"] = user.firstName = firstName;
    }if (lastName != nil) {
        newLinkedInUser[@"lastName"] = user.lastName = lastName;
    }if (middleName != nil) {
        newLinkedInUser[@"middleName"] = user.middleName = middleName;
    }if (industry != nil) {
        newLinkedInUser[@"industry"] = user.industry = industry;
    }if (pictureUrl != nil) {
        newLinkedInUser[@"pictureUrl"] = user.pictureUrl = pictureUrl;
    }if (locationName != nil) {
        newLinkedInUser[@"locationName"] = user.locationName = locationName;
    }if (self.geo_location != nil) {
        newLinkedInUser[@"coordinates"] = self.geo_location;
    }if (address != nil) {
        newLinkedInUser[@"address"] = user.address = address;
    }
    
    newLinkedInUser[@"isAlumni"] = [NSNumber numberWithBool:NO];
    user.isAlumni = NO;
    
    newLinkedInUser[@"isActive"] = [NSNumber numberWithBool:NO];
    user.isActive = NO;
    
     NSLog(@"user:%@",user.firstName);
    
    if (user.firstName == nil) {
        user.firstName = @"";
    }if (user.lastName == nil) {
        user.lastName = @"";
    }if (user.email == nil) {
        user.email = @"";
    }if (user.address == nil) {
        user.address = @"";
    }if (user.pictureUrl == nil) {
        user.pictureUrl = @"";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithBool:user.isAlumni] forKey:@"isAlumni"];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:user.firstName,
                           user.lastName,
                           user.email,
                           user.address,
                           user.pictureUrl, nil] ; // set value
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:data forKey:@"user"];
    [defaults synchronize];
    
    
    [newLinkedInUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([[dataOfLinkedInUser objectForKey:@"educations"] objectForKey:@"_total"] > 0) {
                
                [self saveEducationsForThisUser:newLinkedInUser andEducations:[dataOfLinkedInUser objectForKey:@"educations"]];
                
                //[self performSegueWithIdentifier:@"Homescreen" sender:self];
            }
                    }
        else if (error)
        {
            NSLog(@"%@",error);
        }
    }];
    
    if (!user.isAlumni) {
        [self first_Alumni_Hit];
    }
}

- (void) saveEducationsForThisUser : (PFObject *) linkedUser andEducations : (NSDictionary *) educations
{
    NSArray *allEducations = [educations objectForKey:@"values"];
    
    for (NSDictionary *edu in allEducations)
    {
        PFObject *educationPFObject = [PFObject objectWithClassName:@"Education"];
        
        educationPFObject[@"degree"] = [edu objectForKey:@"degree"];
        educationPFObject[@"schoolName"] = [edu objectForKey:@"schoolName"];
        educationPFObject[@"endDate"] = [NSString stringWithFormat:@"%@", [[edu objectForKey:@"endDate"] objectForKey:@"year"]];
        educationPFObject[@"startDate"] = [NSString stringWithFormat:@"%@", [[edu objectForKey:@"startDate"] objectForKey:@"year"]];
        
        [educationPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded)
            {
                PFRelation *relation = [linkedUser relationForKey:@"userEducation"];
                [relation addObject:educationPFObject];
                [linkedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"User degree Saved");
                    }
                }];
            }
            else if (error)
            {
                NSLog(@"Error = %@", error);
            }
        }];
        
    }
    
}


#pragma mark pragma getting user current location

-(void) getUserCurrentLocation
{
    
    if (![CLLocationManager locationServicesEnabled])
    {
        
        alertToEnableDeviceLocation = [[UIAlertView alloc] initWithTitle:@"LocationServices"
                                                                              message:@"Please Enable Location Services from Settings to use this App"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
        alertToEnableDeviceLocation.tag = 2;
        [alertToEnableDeviceLocation show];
        
    }
    else
    {
        userLocationManager = [[CLLocationManager alloc] init];
        
        switch([CLLocationManager authorizationStatus])
        {
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
                
                alertToEnableDeviceLocation = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please allow Uni Alumni to use your location from device settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alertToEnableDeviceLocation.tag=1;
                [alertToEnableDeviceLocation show];
                
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

#pragma mark pragma CLLocationManager_Delegate_Implementation

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
             
             NSLog(@"%@",placemark.locality);
             
             self.current_city = placemark.locality;
             
             
             
             // [SVProgressHUD showSuccessWithStatus:@"Location Found"];
         }
     }];
}

#pragma mark pragma Alumni_API_Hits_functions

- (void)first_Alumni_Hit {
    first_random_no = [self random_Number];
    NSLog(@"random first:%i",first_random_no);
    NSMutableDictionary *jsoncreate=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    NSMutableArray *args=[[NSMutableArray alloc] init];
    /*for first hit args*/
    [args addObject:@"bitnami_openerp"];
    [args addObject:@"user@example.com"];
    [args addObject:@"bU73FTAsoc0Q"];
    
    [params setObject:args forKey:@"args"];
    [params setObject:@"login" forKey:@"method"];
    [params setObject:@"common" forKey:@"service"];
    
    [data setObject:params forKey:@"params"];
    [data setObject:@"2.0" forKey:@"jsonrpc"];
    [data setObject:@"call" forKey:@"method"];
    [data setObject:[NSString stringWithFormat:@"%i",first_random_no] forKey:@"id"];
    
    [jsoncreate setObject:data forKey:@"data"];
    
    NSLog(@"%@",data);
    
    [self post:@"http://52.17.195.152/jsonrpc" :data];
}

- (void)second_Alumni_Hit {
    second_random_no = [self random_Number];
    NSMutableDictionary *jsoncreate=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    NSMutableArray *args=[[NSMutableArray alloc] init];
    NSMutableDictionary *userdetail=[[NSMutableDictionary alloc] init];
    
    
    [userdetail setObject:user.firstName forKey:@"name"];
    [userdetail setObject:user.email forKey:@"email"];
    //[userdetail setObject:@"IXSOL - innovative solutions gmbh" forKey:@"company"];
    
    /*for second hit args*/
    [args addObject:@"bitnami_openerp"];
    [args addObject:@"1"];
    [args addObject:@"bU73FTAsoc0Q"];
    [args addObject:@"res.partner"];
    [args addObject:@"check_partner"];
    [args addObject:userdetail];
    
    [params setObject:args forKey:@"args"];
    [params setObject:@"execute" forKey:@"method"];
    [params setObject:@"object" forKey:@"service"];
    
    [data setObject:params forKey:@"params"];
    [data setObject:@"2.0" forKey:@"jsonrpc"];
    [data setObject:@"call" forKey:@"method"];
    [data setObject:[NSString stringWithFormat:@"%i",second_random_no] forKey:@"id"];
    
    [jsoncreate setObject:data forKey:@"data"];
    
    NSLog(@"%@",data);
    [self post:@"http://52.17.195.152/jsonrpc" :data];
}

-(int)random_Number{
    
    return (arc4random() % 8000000) + 10000000;
    
}


-(void)post : (NSString *)url : (NSDictionary *)param {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager POST:url parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        
                NSString *name = [[NSString alloc] initWithFormat:@"%@",
                          [responseObject objectForKey:@"result"]];
        NSString *user_id = [[NSString alloc] initWithFormat:@"%@",
                          [responseObject objectForKey:@"id"]];
        NSLog(@"%@",name);
        if([name isEqualToString:@"1"] && [user_id isEqualToString:[NSString stringWithFormat:@"%i", first_random_no ]]){
            
            [self second_Alumni_Hit];
            
        }else if([name isEqualToString:@"0"] && [user_id isEqualToString:[NSString stringWithFormat:@"%i", second_random_no ]]){
            
            PFQuery *query = [PFQuery queryWithClassName:@"LinkedInUser"];
            [query whereKey:@"email" equalTo:user.email];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                if(object){
                    object[@"isAlumni"] = [NSNumber numberWithBool:YES];
                    [object saveInBackground];
                }
            }];
            
            user.isAlumni = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithBool:user.isAlumni] forKey:@"isAlumni"];
            [defaults synchronize];
            UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Your affiliation has been approved. Welcome to the University Alumni App. Let’e Get Connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [chose_current_location show];
            [self performSegueWithIdentifier:@"Homescreen" sender:self];
            
        }
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

#pragma mark pragma Segue_Delegates

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.loader stopAnimating];
    if ([segue.destinationViewController isKindOfClass:[AlumniNearByViewController class]]) {
        AlumniNearByViewController *my_table_search = segue.destinationViewController;
        my_table_search.is_login_segue = YES;
    }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}


- (IBAction)unwindToLogInController:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.sourceViewController isKindOfClass:[AlumniNearByViewController class]]) {
        AlumniNearByViewController *current_user_location = unwindSegue.sourceViewController;
        if (current_user_location.location != nil) {
            self.geo_location = [PFGeoPoint geoPointWithLocation:current_user_location.location];
            if (self.geo_location != nil) {
                [self saveLinkedInUserOnParse:json];
            }
            NSLog(@"current User:%@",self.geo_location);

        }
        NSLog(@"current User location login:");
    }else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"access_token"]; 
    [defaults setObject:nil forKey:@"isAlumni"];
    [defaults setObject:nil forKey:@"user"];
    [defaults synchronize];
    }
}


@end
