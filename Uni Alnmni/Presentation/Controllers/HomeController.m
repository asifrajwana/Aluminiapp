//
//  MianMenuController.m
//  Uni Alnmni
//
//  Created by asif on 13/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//
#import "HomeScreenCustomCellTableViewCell.h"
#import "HomeController.h"
#import "AllWebView.h"
#import <CoreLocation/CoreLocation.h>

@implementation HomeController

HomeScreenCustomCellTableViewCell *cell;
BOOL isAlumni;
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    homeList = @[@"Alunmi Nearby",@"Alumni Search",@"Profile",@"Campus Directory",@"News & Social"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    isAlumni = [[defaults objectForKey:@"isAlumni"] boolValue];
    
    NSLog(isAlumni ? @"Yes" : @"No");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"lost angel"
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks) {
                         for (CLPlacemark* aPlacemark in placemarks)
                         {
                             NSLog(@"Name = %@", aPlacemark.name);
                         }
                     }else {
                         NSLog(@"Error : %@",error);
                     }
                     
                 }];
    
    if(!isAlumni){
    
        UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Pending Affiliation" message:@"Your affection request is pending for administrator’s approval. Please contact your University Alumni section." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [chose_current_location show];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resuseIdentifier = @"cellForAlumini";
    
    cell = (HomeScreenCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (cell==nil) {
         cell = [[HomeScreenCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
    }
    
    if(!isAlumni){
        
        if (indexPath.row==4){
            //[self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.userInteractionEnabled = YES;
            cell.textLabel.enabled = YES;
        }else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
        }
        
    }
    
    if (indexPath.row==0) {
        cell.cellImage.image = [UIImage imageNamed:@"globe"];
    }else if (indexPath.row==1){
        cell.cellImage.image = [UIImage imageNamed:@"search"];
    }else if (indexPath.row==2){
        cell.cellImage.image = [UIImage imageNamed:@"people_like_me"];
    }else if (indexPath.row==3){
        cell.cellImage.image = [UIImage imageNamed:@"grad-cap"];
    }else if (indexPath.row==4){
        cell.cellImage.image = [UIImage imageNamed:@"news"];
        
    }
    
    //cell.cellImage.image = [UIImage imageNamed:@""];
    cell.cellText.text = homeList[indexPath.row];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"MAP_DETAILS_SEGUE" sender:self];
    }else if (indexPath.row==1){
        [self performSegueWithIdentifier:@"SEARCH_FILTER_SEGUE" sender:self];

    }else if (indexPath.row==2){
        [self performSegueWithIdentifier:@"PROFILE_SEGUE" sender:self];
    }else if (indexPath.row==3){
        [self performSegueWithIdentifier:@"WEB_VIEW_SEGUE" sender:self];
        
    }else if (indexPath.row==4){
        [self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        isAlumni = [[defaults objectForKey:@"isAlumni"] boolValue];
    }else if(!isAlumni){
            
            UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"It looks like you don’t have permission  to view this content. Please wait for an administrator to approve your affiliation request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [chose_current_location show];
        
    
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"WEB_VIEW_SEGUE"]) {
        AllWebView *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.fullUrl = @"http://leadstech.com/projects/html/alumni/";
        vc.tittle = @"Campus Directory";
    }

}

- (IBAction)unwindToHomeController:(UIStoryboardSegue *)unwindSegue
{
}
- (IBAction)tell_your_friends:(id)sender {
    
    UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"It looks like you don’t have permission  to view this content. Please wait for an administrator to approve your affiliation request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [chose_current_location show];
}


//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Row: %ld",(long)indexPath.row);
//    
//    
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//
//    if ([[segue identifier] isEqualToString:@"MAP_DETAILS_SEGUE"]) {
//        NSIndexPath *indexPath = [tableview indexPathForCell:sender];
//        if (indexPath.row==0) {
//            [self performSegueWithIdentifier:@"MAP_DETAILS_SEGUE" sender:self];
//        }
//    }
//}



@end
