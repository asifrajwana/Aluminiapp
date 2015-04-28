//
//  User.h
//  Uni Alnmni
//
//  Created by asif on 21/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong , nonatomic) NSString* email;

@property (strong , nonatomic) NSString* firstName;

@property (strong , nonatomic) NSString* lastName;

@property (strong , nonatomic) NSString* middleName;

@property (strong , nonatomic) NSString* industry;

@property (strong , nonatomic) NSString* pictureUrl;

@property (strong , nonatomic) NSString* locationName;

@property (strong , nonatomic) NSString* address;

@property (nonatomic) BOOL isAlumni;

@property (nonatomic) BOOL isActive;

@property (nonatomic) double latitude;

@property (nonatomic) double longitude;

@end
