//
//  AlumniSearchViewController.h
//  Uni Alnmni
//
//  Created by asif on 16/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlumniSearchCustomCellTableViewCell.h"

@interface AlumniSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
__weak IBOutlet UITableView *tableview;
}

@property (strong, nonatomic) AlumniSearchCustomCellTableViewCell *cellSelected;
@end
