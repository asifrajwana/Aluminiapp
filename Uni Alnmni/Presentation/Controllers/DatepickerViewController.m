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

@synthesize hint,picker,starthintSet,endhintSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.footer_View setBackgroundColor:BLUE_HEADER];
    self.starthintSet = @"start";
    self.endhintSet = @"end";
    [self.picker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.endPicker addTarget:self action:@selector(enddatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self setDateFromPicker:self.picker];
    [self setEndDateFromPicker:self.endPicker];
    // Do any additional setup after loading the view.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    [self setDateFromPicker:datePicker];
}

- (void)enddatePickerChanged:(UIDatePicker *)datePicker
{
    [self setEndDateFromPicker:datePicker];
}

-(void) setDateFromPicker : (UIDatePicker *) datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    starthintSet = strDate;
}

-(void) setEndDateFromPicker : (UIDatePicker *) datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    endhintSet = strDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
}
- (IBAction)cancel:(id)sender {
    starthintSet = @"";
}


@end
