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
#import "AlumniNearByViewController.h"

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
    ListData = @[@"Name",@"Industry",@"Company",@"Degree",@"School Name",@"Year", @"Location"];
    self.selectedData = [[NSMutableArray alloc] initWithObjects:@"",@"all",@"all",@"all",@"all",@"", @"all", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  roundf( ([[UIScreen mainScreen] bounds].size.height - 123.0f )/ [ListData count]) ;
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
    cell.cellSelectedText.text = self.selectedData[indexPath.row];
    cell.cellCatagoryText.textColor=BLUE_LIGHT_Color;
    if(indexPath.row == 1 || indexPath.row ==2 || indexPath.row ==6){
        
    }else{
        cell.cellImage.image = nil;
        cell.cellCatagoryText.textColor = [UIColor blackColor];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.cellSelected  = (AlumniSearchCustomCellTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    
    selectedIndex = (int)indexPath.row;
    
    if (indexPath.row == 5) {
        [self performSegueWithIdentifier:@"SEARCH_DATA_DATE_SEGUE" sender:self];
    }else if(indexPath.row == 6){
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
        vc.starthintSet = ListData[tableview.indexPathForSelectedRow.item];
    }else if ([segue.identifier isEqualToString:@"SEARCH_MAP_SEGUE"]){
        
        AlumniNearByViewController *vc = [segue destinationViewController];
        //vc.hintSet = ListData[tableview.indexPathForSelectedRow.item];
        vc.is_search_segue = YES;
        vc.PFObjectList = self.PfObjectList;
    }
    

}


- (IBAction)unwindToAlumniSearchController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[searchDataSetViewController class]]) {
        searchDataSetViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.hintSet isEqualToString:@""]) {
            self.cellSelected.cellSelectedText.text = SDSViewConroller.hintSet;
            
            [self.selectedData replaceObjectAtIndex:selectedIndex withObject:SDSViewConroller.hintSet];
        }
    }
    else if ([unwindSegue.sourceViewController isKindOfClass:[DatepickerViewController class]])
    {
        DatepickerViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.starthintSet isEqualToString:@""]) {
            NSString *dates = [SDSViewConroller.starthintSet stringByAppendingString:@"-"];
            dates = [dates stringByAppendingString:SDSViewConroller.endhintSet];
            
            self.cellSelected.cellSelectedText.text = dates;
            
            [self.selectedData replaceObjectAtIndex:selectedIndex withObject:dates];
            
        }
    }else if ([unwindSegue.sourceViewController isKindOfClass:[MyTableViewController class]]) {
        MyTableViewController *SDSViewConroller = unwindSegue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (![SDSViewConroller.name isEqualToString:@""]) {
            self.cellSelected.cellSelectedText.text = SDSViewConroller.name;
            [self.selectedData replaceObjectAtIndex:selectedIndex withObject:SDSViewConroller.name];
        }
        NSLog(@"helloo.....");
    }
    
}


- (IBAction)searchAluminiByGivenFilters:(id)sender {
    
    NSLog(@"Selected Data Filters = %@", self.selectedData);
    
    for (NSUInteger st=0; st<[self.selectedData count]; st++) {
        
        if ([[self.selectedData objectAtIndex:st] isEqualToString:@"all"])
        {
            [self.selectedData replaceObjectAtIndex:st withObject:@""];
        }
    }
    
    [AluminiDataSearch loadAluminiDataForFilters:self.selectedData andCompletionBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"Objects = %@", objects);
        if (objects) {
            self.PfObjectList = objects;
            [self performSegueWithIdentifier:@"SEARCH_MAP_SEGUE" sender:self];
        }
        
    }];

}
@end
