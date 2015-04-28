//
//  AlumniSearchViewController.m
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AlumniSearchViewController.h"
#import "AlumniSearchCustomCellTableViewCell.h"
#import "searchDataSetViewController.h"
#import "DatepickerViewController.h"
#import "MyTableViewController.h"

@interface AlumniSearchViewController ()
@property (strong ,nonatomic) NSString *Name;
@property (strong ,nonatomic) NSString *Industry;
@property (strong ,nonatomic) NSString *Company;
@property (strong ,nonatomic) NSString *Degree;
@property (strong ,nonatomic) NSString *Start_Year;
@property (strong ,nonatomic) NSString *End_Year;
@property (strong ,nonatomic) NSString *Field_of_Study;
@property (strong ,nonatomic) NSString *School_Name;
@property (strong ,nonatomic) NSString *Location;
@end

@implementation AlumniSearchViewController

@synthesize cellSelected;

NSArray *ListData;
int selectedIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    [footer_View setBackgroundColor:BLUE_HEADER];
    ListData = @[@"Name",@"Industry",@"Company",@"Degree",@"Start Year",@"End Year",@"Field of Study",@"School Name",@"Location"];
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
    return ListData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellForIdentifier = @"CellForSearch";
    AlumniSearchCustomCellTableViewCell *cell = (AlumniSearchCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellForIdentifier];
    if (cell == nil) {
        cell = [[AlumniSearchCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForIdentifier];
    }
    cell.cellCatagoryText.text = ListData[indexPath.row];
    if(indexPath.row == 1 || indexPath.row ==2 || indexPath.row ==8){
    
    }else{
        cell.cellImage.image = nil;
        cell.cellCatagoryText.textColor = [UIColor blackColor];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.cellSelected  = (AlumniSearchCustomCellTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter the Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [alert show];
//    }
    
    selectedIndex = indexPath.row;
    
    if (indexPath.row == 4 || indexPath.row == 5) {
        [self performSegueWithIdentifier:@"SEARCH_DATA_DATE_SEGUE" sender:self];
    }else if(indexPath.row == 8){
        [self performSegueWithIdentifier:@"SEARCH_LOCATION_SEGUE" sender:self];
    }else {
        [self performSegueWithIdentifier:@"SEARCH_DATA_TEXT_SEGUE" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SEARCH_DATA_TEXT_SEGUE"]) {
        searchDataSetViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.hintSet = ListData[tableview.indexPathForSelectedRow.item];
    }else if ([segue.identifier isEqualToString:@"SEARCH_DATA_DATE_SEGUE"]){
        
        DatepickerViewController *vc = [segue destinationViewController];
        vc.hintSet = ListData[tableview.indexPathForSelectedRow.item];
    }

}


- (IBAction)unwindToAlumniSearchController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[searchDataSetViewController class]]) {
        searchDataSetViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.hintSet isEqualToString:@""]) {
            self.cellSelected.cellSelectedText.text = SDSViewConroller.hintSet;
            if (selectedIndex == 0) {
                self.Name = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Name);
            }else if (selectedIndex == 1) {
                self.Industry = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Industry);
            }else if (selectedIndex == 2) {
                self.Company = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Company);
            }else if (selectedIndex == 3) {
                self.Degree = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Degree);
            }else if (selectedIndex == 6) {
                self.Field_of_Study = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Field_of_Study);
            }else if (selectedIndex == 7) {
                self.School_Name = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Field_of_Study);
            }
        }
    }else if ([unwindSegue.sourceViewController isKindOfClass:[DatepickerViewController class]]) {
        DatepickerViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.hintSet isEqualToString:@""]) {
            self.cellSelected.cellSelectedText.text = SDSViewConroller.hintSet;
            if (selectedIndex == 4) {
                self.Start_Year = SDSViewConroller.hintSet;
                NSLog(@"%@",self.Start_Year);
            }else if (selectedIndex == 5) {
                self.End_Year = SDSViewConroller.hintSet;
                NSLog(@"%@",self.End_Year);
            }
        }
    }else if ([unwindSegue.sourceViewController isKindOfClass:[MyTableViewController class]]) {
        MyTableViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.name isEqualToString:@""]) {
            self.cellSelected.cellSelectedText.text = SDSViewConroller.name;
            if (selectedIndex == 8) {
                self.Location = SDSViewConroller.name;
                NSLog(@"%@",self.Location);
            }
        }
        NSLog(@"helloo.....");
    }
    
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
