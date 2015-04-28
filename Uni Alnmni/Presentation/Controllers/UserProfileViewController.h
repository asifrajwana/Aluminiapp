//
//  UserProfileViewController.h
//  Uni Alnmni
//
//  Created by asif on 21/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "OAuthLoginView.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import <MACachedImageView/MACachedImageView.h>

@interface UserProfileViewController : UIViewController{
    User *user;
    NSString *token_access;
    OAConsumer *consumer;
}
@property (weak, nonatomic) IBOutlet MACachedImageView *userpic;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;

@end
