//
//  WebView.h
//  Uni Alnmni
//
//  Created by asif on 17/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWebView : UIViewController
{
   // NSString *fullUrl;

}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *fullUrl;
@property (strong, nonatomic) NSURLRequest *requestObj;
@property (strong,  nonatomic) NSString *tittle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@end
