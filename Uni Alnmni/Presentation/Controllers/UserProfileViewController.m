//
//  UserProfileViewController.m
//  Uni Alnmni
//
//  Created by asif on 21/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "UserProfileViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "Constants.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

@synthesize userpic,userAddress,userEmail,userName;

NSDate *now;
NSTimer *refreshTimer;

#pragma mark Init_Function

-(void)setUserData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"data:%@",arr);
    if([arr objectAtIndex:0] !=nil && [arr objectAtIndex:1] !=nil){
        userName.text = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        
    }if([arr objectAtIndex:2] !=nil){
        [userEmail setTitle:[arr objectAtIndex:2] forState:UIControlStateNormal];        [userEmail setTitleColor:BLUE_LIGHT_Color forState:UIControlStateNormal];
        
    }if([arr objectAtIndex:3] !=nil){
        NSString *address = [[NSString alloc] initWithFormat:@"Address: %@",[arr objectAtIndex:3]];
        userAddress.text = address;
        
    }if([arr objectAtIndex:4] !=nil){
        [userpic displayImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:4]]]];
        
    }
    userpic.layer.cornerRadius = userpic.frame.size.width/2;
    userpic.clipsToBounds = YES;
    userpic.layer.borderWidth = 3.0f;
    userpic.layer.borderColor = [UIColor whiteColor].CGColor;
    now = [NSDate date];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUserData];
    [self.footer setBackgroundColor:BLUE_HEADER];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark Controller_Class_Function

- (void)profileApiCall{
    
    NSString *apikey = @"75c6gdfxvh8oh4";
    NSString *secretkey = @"J6apdtZHHWqFtUAZ";
    
    consumer = [[OAConsumer alloc] initWithKey:apikey
                                             secret:secretkey
                                              realm:@"http://api.linkedin.com/"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    token_access = [defaults objectForKey:@"access_token"];
    
    NSLog(@"consumer: %@ \n & access_token: %@",consumer,token_access);
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,location,industry,picture-url,educations,email-address,main-address)?format=json"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:[[OAToken alloc] initWithHTTPResponseBody:token_access]
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data{
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    NSLog(@"Profile responce: %@",json);
    
    PFQuery *query = [PFQuery queryWithClassName:@"LinkedInUser"];
    [query whereKey:@"email" equalTo:[json objectForKey:@"emailAddress"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        
        if (object) {
            
            
            NSString *email = [json objectForKey:@"emailAddress"];
            NSString *firstName = [json objectForKey:@"firstName"];
            NSString *lastName = [json objectForKey:@"lastName"];
            NSString *middleName = [json objectForKey:@"maidenName"];
            NSString *industry = [json objectForKey:@"industry"];
            NSString *pictureUrl = [json objectForKey:@"pictureUrl"];
            NSDictionary *locationDict = [json objectForKey:@"location"];
            NSString *locationName = [locationDict objectForKey:@"name"];
            NSString *address = [json objectForKey:@"mainAddress"];
            //NSString *coordinates = [NSString stringWithFormat:@"%.4f",self.location.coordinate.latitude];
            user = [User new];
            if (email != nil) {
                object[@"email"] = user.email = email;
            }if (firstName != nil) {
                object[@"firstName"] = user.firstName = firstName;
            }if (lastName != nil) {
                object[@"lastName"] = user.lastName = lastName;
            }if (middleName != nil) {
                object[@"middleName"] = user.middleName = middleName;
            }if (industry != nil) {
                object[@"industry"] = user.industry = industry;
            }if (pictureUrl != nil) {
                object[@"pictureUrl"] = user.pictureUrl = pictureUrl;
            }if (locationName != nil) {
                object[@"locationName"] = user.locationName = locationName;
            }
//            if (coordinates != nil) {
//                user.latitude  = [PFGeoPoint geoPointWithLocation:self.location].latitude;
//                user.longitude = [PFGeoPoint geoPointWithLocation:self.location].longitude;
//                object[@"coordinates"] = [PFGeoPoint geoPointWithLocation:self.location];
//            }
            if (address != nil) {
                object[@"address"] = user.address = address;
            }
            
            user.isAlumni = NO;
            
            user.isActive = NO;

            [object saveInBackground];
            
            NSLog(@"data saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updated!" message:@"You latest LinkedIn info synced successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
            NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:user.firstName,
                                   user.lastName,
                                   user.email,
                                   user.address,
                                   user.pictureUrl, nil] ; // set value
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            [defaults setObject:data forKey:@"user"];
            [defaults synchronize];
            
        }
        else if (error)
        {
            
        }
    }];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error{
    
    NSLog(@"Error in Login%@",[error description]);
    
}

- (BOOL) hasExpired:(NSDate*)myDate{
    
    NSLog(@"%f",[myDate timeIntervalSinceNow]);
    return [myDate timeIntervalSinceNow] < -120.f;
    
}

-(void)timeOut
{
    
    [refreshTimer invalidate];
    refreshTimer = nil;
    
    
}

-(void)fireTimer
{
    refreshTimer =  [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    
}

#pragma mark Controller_Actions

- (IBAction)sync:(id)sender {
    
    if (refreshTimer==nil) {
        [self fireTimer];
        //now = [NSDate date];
        [self profileApiCall];
    }
    
}


- (IBAction)sendEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *emailTitle = @"Alumni App - User Feedback";
        // Email Content
        NSString *messageBody = @"Please share your feedback here..";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"support@ixsol.at"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    
}

#pragma mark Mail_Composer_Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];


}




@end
