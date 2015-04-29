//
//  AluminiDataSearch.h
//  Alnmni App
//
//  Created by asif on 28/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AluminiDataSearch : NSObject

+(void)loadAluminiDataForFilters:(NSArray *)filters andCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock;
@end
