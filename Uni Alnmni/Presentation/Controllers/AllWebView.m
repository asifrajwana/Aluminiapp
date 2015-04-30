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
    [self backButton];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.loadingView setHidden:NO];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingView setHidden:YES];
}

-(void)backButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Untitled-1"]  ;
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    //[backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 54, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
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
