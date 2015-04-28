//
//  SocialNewsViewController.m
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "SocialNewsViewController.h"
#import "AllWebView.h"

@interface SocialNewsViewController ()

@end

@implementation SocialNewsViewController

NSInteger row;
- (void)viewDidLoad {
    [super viewDidLoad];
    socialTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.is_map_list) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
    }else {
    tableRows = [[NSMutableArray alloc] initWithObjects:@"Twitter",@"Facebook",@"Events",@"LinkedInGroup", nil];
    addresses = [[NSMutableArray alloc] initWithObjects:
    @"https://twitter.com/bucknellu",
    @"https://www.facebook.com/BucknellU",
    @"http://leadstech.com/projects/html/alumni/",
    @"https://www.linkedin.com/company/bucknell-university",nil];
    }
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
    return tableRows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setText:[tableRows objectAtIndex:indexPath.row]];
    cell.textLabel.textAlignment= NSTextAlignmentCenter;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.row;
    // if (indexPath.row >=0) {*/
    [self performSegueWithIdentifier:@"SOCIAL_NEWS_SEGUE" sender:self];
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
