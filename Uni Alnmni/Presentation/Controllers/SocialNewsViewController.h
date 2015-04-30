//
//  SocialNewsViewController.h
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface SocialNewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableRows;
    __weak IBOutlet UIView *footer_view;
    NSMutableArray *addresses;
    __weak IBOutlet UITableView *socialTableview;
}

@property bool is_map_list;
@property (strong, nonatomic) NSArray *mapUserList;
@property (strong, nonatomic) NSArray *mapUserListData;
@property int row;

@end
