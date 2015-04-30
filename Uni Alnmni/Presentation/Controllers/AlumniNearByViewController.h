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
#import "Constants.h"
#import "AluminiSearchResultsTableController.h"
@interface AlumniNearByViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSArray *mapItemList;
@property (nonatomic, strong) NSArray *PFObjectList;
@property (nonatomic, strong) NSDictionary *educationData;
@property __block int allUsers;
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
@property bool is_search_segue;
@property (weak, nonatomic) IBOutlet UILabel *searchResultCounter;
@property (strong, nonatomic) MKMapItem *mapitem;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *footer_view;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewAlumni;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic, strong) AluminiSearchResultsTableController *resultsTableController;
// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end
