//
//  AluminiAnnotation.m
//  Alnmni App
//
//  Created by asif on 30/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AluminiAnnotation.h"

@implementation AluminiAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle : (NSString *) aluminiName
{
    self=[super init];
    if(self){
        _coordinate = coordinate;
        _title = aluminiName;
        
    }
    return self;
}

- (MKAnnotationView *) annotationView
{
    
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:annotationIdentifier];
    
    annotationView.image = [UIImage imageNamed:@"pin_e"];
    annotationView.canShowCallout= YES;
    annotationView.enabled = YES;
    
    return annotationView;
}

@end
