//
//  SettingViewController.m
//  Alnmni App
//
//  Created by asif on 30/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
NSArray *arr;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.footer setBackgroundColor:BLUE_HEADER];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self backButton];
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Untitled-1"]];
    //[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Untitled-1"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"setting_cell";
    SettingTableViewCell *cell = (SettingTableViewCell*)[self.settingTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0) {
        cell.cellSwitch.hidden = YES;
        if([arr objectAtIndex:2] !=nil){
            cell.cellText.text = [arr objectAtIndex:2];
            cell.cellImage.image = [UIImage imageNamed:@"settings_email_icon"];
        }
        
    }else if(indexPath.row == 1){
        cell.cellText.text  = @"Connect with LinkedIn";
    }
    
    return cell;
}

-(void)backButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Untitled-1"]  ;
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    //[backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 54, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        [self performSegueWithIdentifier:@"LOGOUT_SEGUE" sender:self];
    }
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logout:(id)sender {
    
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logoutAlert show];
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
