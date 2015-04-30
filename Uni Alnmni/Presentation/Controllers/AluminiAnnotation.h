//
//  AluminiAnnotation.h
//  Alnmni App
//
//  Created by asif on 30/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface AluminiAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle : (NSString *) aluminiName;

@end
