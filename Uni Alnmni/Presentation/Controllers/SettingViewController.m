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
    [self backButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView_Delegates

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

#pragma mark Class_Function

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

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark AlertView_Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        [self performSegueWithIdentifier:@"LOGOUT_SEGUE" sender:self];
    }
    
}

#pragma mark Controller_Actions

- (IBAction)logout:(id)sender {
    
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logoutAlert show];
    
}
- (IBAction)supportAlumini:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *emailTitle = @"Alumni App - User Feedback";
        // Email Content
        NSString *messageBody = @"Please share your feedback here..";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObjects:@"support@ixsol.at", nil];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    
}

#pragma mark Mail_composer_delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
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
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
