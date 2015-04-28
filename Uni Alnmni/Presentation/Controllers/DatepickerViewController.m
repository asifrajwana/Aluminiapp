//
//  DatepickerViewController.m
//  Uni Alnmni
//
//  Created by asif on 22/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "DatepickerViewController.h"

@interface DatepickerViewController ()

@end

@implementation DatepickerViewController

@synthesize hint,picker,hintSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.footer_View setBackgroundColor:BLUE_HEADER];
    hint.text = self.hintSet;
    //self.picker.datePickerMode = UIDatePickerModeDate;
    [self.picker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    hintSet = strDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
}
- (IBAction)cancel:(id)sender {
    hintSet = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
