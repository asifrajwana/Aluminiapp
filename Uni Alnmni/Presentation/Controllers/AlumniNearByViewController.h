//
//  AlumniNearByViewController.h
//  Uni Alnmni
//
//  Created by asif on 15/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SocialNewsViewController.h"

@interface AlumniNearByViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>{

    

}

@property (nonatomic, strong) NSArray *mapItemList;
@property (nonatomic, strong) NSArray *PFObjectList;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSArray *places;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property BOOL geocoding;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSArray *cordList;
@property bool is_login_segue;
@property (strong, nonatomic) MKMapItem *mapitem;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewAlumni;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end