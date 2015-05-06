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
#import "Constants.h"
@implementation HomeController

HomeScreenCustomCellTableViewCell *cell;
BOOL isAlumni;
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    homeList = @[@"Alumni Nearby",@"Search / Filter",@"Directory",@"News and Social"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [footer_view setBackgroundColor:BLUE_HEADER];
    isAlumni = [[defaults objectForKey:@"isAlumni"] boolValue];
    [tell_your_friend_button setBackgroundColor:BLUE_LIGHT_Color];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    NSLog(isAlumni ? @"Yes" : @"No");
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header1"]];

    if(!isAlumni){
    
        UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Pending Affiliation" message:@"Your affection request is pending for administrator’s approval. Please contact your University Alumni section." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [chose_current_location show];
    }
    
}

#pragma mark TableView_Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"cellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"user"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"data:%@",arr);
        if([arr objectAtIndex:0] !=nil && [arr objectAtIndex:1] !=nil){
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
            cell.textLabel.font = [UIFont systemFontOfSize:22];
            
        }
        if (!isAlumni) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.textLabel.textColor = [UIColor lightGrayColor];

        }
        cell.textLabel.textAlignment= NSTextAlignmentCenter;
        return cell;
    }else {
    
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
            //cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        
    }
    
    if (indexPath.row==1) {
        cell.cellImage.image = [UIImage imageNamed:@"nearby"];
    }else if (indexPath.row==2){
        cell.cellImage.image = [UIImage imageNamed:@"classmates"];
    }else if (indexPath.row==3){
        cell.cellImage.image = [UIImage imageNamed:@"search"];
    }else if (indexPath.row==4){
        cell.cellImage.image = [UIImage imageNamed:@"news"];
        
    }
    
    cell.cellText.text = homeList[indexPath.row-1];
    
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(isAlumni){
        if (indexPath.row==1) {

            [self performSegueWithIdentifier:@"MAP_DETAILS_SEGUE" sender:self];
        }else if (indexPath.row==2){
            [self performSegueWithIdentifier:@"SEARCH_FILTER_SEGUE" sender:self];

        }else if (indexPath.row==0){
            [self performSegueWithIdentifier:@"PROFILE_SEGUE" sender:self];
        }else if (indexPath.row==3){
            [self performSegueWithIdentifier:@"WEB_VIEW_SEGUE" sender:self];
        
        }else if (indexPath.row==4){
            [self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
            isAlumni = [[defaults objectForKey:@"isAlumni"] boolValue];
        }
    }else if(indexPath.row==4){
        [self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
    }else{
            
        UIAlertView *chose_current_location = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"It looks like you don’t have permission  to view this content. Please wait for an administrator to approve your affiliation request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [chose_current_location show];
        
    }
    
}

#pragma mark Wind_Unwind_Functions

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"WEB_VIEW_SEGUE"]) {
        AllWebView *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.fullUrl = @"http://fh-alumni.at/page/directory";
        vc.tittle = @"Campus Directory";
    }

}

- (IBAction)unwindToHomeController:(UIStoryboardSegue *)unwindSegue
{
}

#pragma mark Controller_Actions

- (IBAction)tell_your_friends:(id)sender {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:@"Hi Friend, \n\n Please checkout our University Alumni App at: http://ixsol.at \n\n Lets get connected!"];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    
}


@end
