//
//  AlumniSearchViewController.h
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlumniSearchCustomCellTableViewCell.h"
#import "AluminiDataSearch.h"
#import "Constants.h"
@interface AlumniSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
__weak IBOutlet UITableView *tableview;
    __weak IBOutlet UIView *footer_View;
}

@property (strong, nonatomic) NSMutableArray *selectedData;

@property (strong, nonatomic) AlumniSearchCustomCellTableViewCell *cellSelected;
- (IBAction)searchAluminiByGivenFilters:(id)sender;
@end
