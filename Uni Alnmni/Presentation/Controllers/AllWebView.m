//
//  WebView.m
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AllWebView.h"

@interface AllWebView ()

@end

@implementation AllWebView
@synthesize webview,fullUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.fullUrl = @"http://www.facebook.com";
    NSURL *url = [NSURL URLWithString:self.fullUrl];
    self.requestObj = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:self.requestObj];
    [self.navigationItem setTitle:self.tittle];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reload:(id)sender {
    [self.webview loadRequest:self.requestObj];
    
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
