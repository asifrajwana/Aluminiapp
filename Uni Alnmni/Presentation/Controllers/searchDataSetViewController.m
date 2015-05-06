//
//  searchDataSetViewController.m
//  Uni Alnmni
//
//  Created by asif on 22/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "searchDataSetViewController.h"
#import "AlumniSearchViewController.h"
#import "Constants.h"
@interface searchDataSetViewController ()

@end

@implementation searchDataSetViewController

@synthesize hint,enter_field_data,hintSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    enter_field_data.clearButtonMode = UITextFieldViewModeWhileEditing;

    hint.text = hintSet;
    [self.footer_View setBackgroundColor:BLUE_HEADER];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [enter_field_data resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    hintSet = @"";
}
- (IBAction)done:(id)sender {
    
    hintSet = enter_field_data.text;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.destinationViewController isKindOfClass:[AlumniSearchViewController class]]) {
//        AlumniSearchViewController *ASViewConroller = segue.destinationViewController;
//        ASViewConroller.cellSelected.cellSelectedText.text = enter_field_data.text;
//    }
    hintSet = enter_field_data.text;
}

@end
