//
//  MianMenuController.h
//  Uni Alnmni
//
//  Created by asif on 13/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HomeController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *homeList;
    __weak IBOutlet UITableView *tableview;
    
    __weak IBOutlet UIButton *tell_your_friend_button;
}



@end
