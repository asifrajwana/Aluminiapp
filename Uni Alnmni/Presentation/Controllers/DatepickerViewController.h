//
//  DatepickerViewController.h
//  Uni Alnmni
//
//  Created by asif on 22/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface DatepickerViewController : UIViewController{
    
}
@property (strong) NSString *starthintSet;
@property (strong) NSString *endhintSet;

@property (strong, nonatomic) IBOutlet UILabel *hint;
@property (weak, nonatomic) IBOutlet UIView *footer_View;

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UILabel *endhint;
@property (weak, nonatomic) IBOutlet UIDatePicker *endPicker;
@end
