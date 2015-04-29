//
//  SocialNewsViewController.m
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "SocialNewsViewController.h"
#import "AllWebView.h"
#import <Parse/Parse.h>
#import "AlumniSearchCustomCellTableViewCell.h"

@interface SocialNewsViewController ()

@end

@implementation SocialNewsViewController

NSInteger row;
- (void)viewDidLoad {
    [super viewDidLoad];
    [footer_view setBackgroundColor:BLUE_HEADER];
    socialTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.is_map_list) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else {
    tableRows = [[NSMutableArray alloc] initWithObjects:@"Twitter",@"Facebook",@"Events",@"LinkedInGroup", nil];
    addresses = [[NSMutableArray alloc] initWithObjects:
    @"https://twitter.com/bucknellu",
    @"https://www.facebook.com/BucknellU",
    @"http://leadstech.com/projects/html/alumni/",
    @"https://www.linkedin.com/company/bucknell-university",nil];
    }
    
    NSLog(@"User Edu = %@", self.mapUserListData);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.is_map_list) {
        return self.mapUserList.count;
    }else {
        return tableRows.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.is_map_list) {
        
        static NSString *cellForIdentifier = @"CellForSearch";
        AlumniSearchCustomCellTableViewCell *cell = (AlumniSearchCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellForIdentifier];
        if (cell == nil) {
            cell = [[AlumniSearchCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForIdentifier];
        }
        //cell.cellCatagoryText.text = ListData[indexPath.row];
        
        PFObject *obj = [self.mapUserList objectAtIndex:indexPath.row];
        NSString *first_name = obj[@"firstName"];
        NSString *last_name = obj[@"lastName"];
        NSString *name= [first_name stringByAppendingString:@" "];
        name = [name stringByAppendingString:last_name];
        
        NSString *degree;
        
        if ([[self.mapUserListData objectAtIndex:indexPath.row] respondsToSelector:@selector(isEqualToString:)]) {
            degree = @"start-end";
        }
        else
        {
            degree = [NSString stringWithFormat:@"%@",[self.mapUserListData objectAtIndex:indexPath.row][@"endDate"]];
        }
        
        cell.cellCatagoryText.text = name;
        cell.cellSelectedText.text = degree;
        cell.cellImage = nil;
        return cell;
    }else {
        static NSString *cellIdentifier = @"cellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        [cell.textLabel setText:[tableRows objectAtIndex:indexPath.row]];
        cell.textLabel.textAlignment= NSTextAlignmentCenter;
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
    self.row = indexPath.row;
    // if (indexPath.row >=0) {*/
    if (!self.is_map_list) {
        [self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
    }
    
    //}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"SOCIAL_NEWS_SEGUE"])
    {
        // Get reference to the destination view controller
        AllWebView *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.fullUrl = [addresses objectAtIndex:row];
        vc.tittle = [tableRows objectAtIndex:row];
    }
    if ([segue.identifier isEqualToString:@"UNWIND_NEARBY_SEGUE"] ) {
        
        NSLog(@"Self row = %d", self.row);
        self.row = [socialTableview indexPathForSelectedRow].row;
    }
}

- (IBAction)unwindToSocialController:(UIStoryboardSegue *)unwindSegue
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
