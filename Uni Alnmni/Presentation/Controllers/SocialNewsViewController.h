//
//  SocialNewsViewController.h
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialNewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableRows;
    NSMutableArray *addresses;
    __weak IBOutlet UITableView *socialTableview;
}

@property bool is_map_list;

@end
