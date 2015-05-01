//
//  SettingViewController.h
//  Alnmni App
//
//  Created by asif on 30/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIButton *support;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UIView *footer;

@end
