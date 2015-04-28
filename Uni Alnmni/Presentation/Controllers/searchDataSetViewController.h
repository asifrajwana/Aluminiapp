//
//  searchDataSetViewController.h
//  Uni Alnmni
//
//  Created by asif on 22/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchDataSetViewController : UIViewController{

}
@property (strong) NSString *hintSet;
@property (weak, nonatomic) IBOutlet UILabel *hint;
@property (weak, nonatomic) IBOutlet UIView *footer_View;
@property (weak, nonatomic) IBOutlet UITextField *enter_field_data;


@end
