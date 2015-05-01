//
//  AluminiDataSearch.m
//  Alnmni App
//
//  Created by asif on 28/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AluminiDataSearch.h"

@implementation AluminiDataSearch

+(void)loadAluminiDataForFilters:(NSArray *)filters andCompletionBlock:(void (^)(NSArray *, NSError *))completionBlock
{
    
    NSArray *categories = [NSArray arrayWithObjects:@"Name",@"industry",@"degree",@"fieldOfStudy",@"schoolName",@"Date",@"locationName", nil];
    
    // apply category filter
    if ( [filters count])
    {
        PFQuery *aluminiQuery;
        
        for (int i=0; i<[filters count]; i++)
        {
            if (i==0)
            {
                if ([[filters objectAtIndex:i] length])
                {
                    NSArray *names = [[filters objectAtIndex:i] componentsSeparatedByString:@" "];
                    
                    NSMutableArray *queries = [[NSMutableArray alloc] init];
                    
                    if ([names objectAtIndex:0]) {
                        PFQuery *firstNameQuery = [PFQuery queryWithClassName:@"LinkedInUser"];
                        [firstNameQuery whereKey:@"firstName" matchesRegex:[names objectAtIndex:0]modifiers:@"i"];
                        [queries addObject:firstNameQuery];
                    }
                    
                    if ([names count] > 1 && [names objectAtIndex:1]) {
                        PFQuery *middleNameQuery = [PFQuery queryWithClassName:@"LinkedInUser"];
                        [middleNameQuery whereKey:@"middleName" matchesRegex:[names objectAtIndex:1] modifiers:@"i"];
                        [queries addObject:middleNameQuery];
                    }
                    
                    if ([names count] > 2 && [names objectAtIndex:2]) {
                        PFQuery *lastNameQuery = [PFQuery queryWithClassName:@"LinkedInUser"];
                        [lastNameQuery whereKey:@"lastName" matchesRegex:[names objectAtIndex:2] modifiers:@"i"];
                        [queries addObject:lastNameQuery];
                    }
                    
                    aluminiQuery = [PFQuery orQueryWithSubqueries:queries];
                }
                else
                {
                    aluminiQuery = [PFQuery queryWithClassName:@"LinkedInUser"];
                }
            
            }
            else if (i==1 || i==2 || i==3)
            {
                if ([[filters objectAtIndex:i] length])
                {
                    [aluminiQuery whereKey:[categories objectAtIndex:i] matchesRegex:[filters objectAtIndex:i] modifiers:@"i"];
                }
            }
            else if (i==6)
            {
                if (![[filters objectAtIndex:i] respondsToSelector:@selector(length)])
                {
                    [aluminiQuery whereKey:@"coordinates" nearGeoPoint:[filters objectAtIndex:i] withinMiles:10.0];
                }
            }
            
            else
            {
                if ([[filters objectAtIndex:i] length])
                {
                    if (i==5)
                    {
                        NSArray *dates = [[filters objectAtIndex:i] componentsSeparatedByString:@"-"];
                        
                        if ([dates objectAtIndex:0]) {
                            if (![[dates objectAtIndex:0] isEqualToString:@"start"]) {
                                PFQuery *innerQuery = [PFQuery queryWithClassName:@"Education"];
                                [innerQuery whereKey:@"startDate" equalTo:[NSNumber numberWithInt:[[dates objectAtIndex:0] intValue]]];
                                [aluminiQuery whereKey:@"userEducation" matchesQuery:innerQuery];
                            }
                        }
                        
                        if ([dates count] > 1 && [dates objectAtIndex:1]) {
                            if (![[dates objectAtIndex:1] isEqualToString:@"end"]) {
                            PFQuery *innerQuery = [PFQuery queryWithClassName:@"Education"];
                            [innerQuery whereKey:@"endDate" equalTo:[NSNumber numberWithInt:[[dates objectAtIndex:1] intValue]]];
                            [aluminiQuery whereKey:@"userEducation" matchesQuery:innerQuery];
                            }
                        }
                    }
                    else
                    {
                        PFQuery *innerQuery = [PFQuery queryWithClassName:@"Education"];
                        [innerQuery whereKey:[categories objectAtIndex:i] matchesRegex:[filters objectAtIndex:i] modifiers:@"i"];
                        [aluminiQuery whereKey:@"userEducation" matchesQuery:innerQuery];
                    }
                }
            }
            
        }
        
        [aluminiQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             completionBlock(objects, error);
             
         }];
    }

}

+(void)loadEducationDataForObject:(PFObject *)object andCompletionBlock:(void (^)(PFObject *, NSError *))completionBlock
{
    PFRelation *relation = [object relationForKey:@"userEducation"];
    PFQuery *userEducationQuery = [relation query];
    [userEducationQuery orderByDescending:@"startDate"];
    
    
    [userEducationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object2, NSError *error) {
        
        completionBlock(object2, error);
        
    }];
}



@end
