//
//  AlumniNearByViewController.m
//  Uni Alnmni
//
//  Created by asif on 15/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AlumniNearByViewController.h"
#import "AluminiDataSearch.h"
#import <Parse/Parse.h>
#import "AluminiAnnotation.h"
#import <SVProgressHUD.h>

#define MINIMUM_ZOOM_ARC 0.05 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 2.50
#define MAX_DEGREES_ARC 360

@interface AlumniNearByViewController ()
{
    BOOL isSearch;
    BOOL isLocation;
}

@end

@implementation AlumniNearByViewController

@synthesize mapViewAlumni,slider;
@synthesize locationManager, location, geocoder;

MKCoordinateRegion region;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isLocation = NO;
    isSearch = NO;
    
    
    _resultsTableController = [[AluminiSearchResultsTableController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    [self.searchController.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    _resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
    [self.footer_view setBackgroundColor:BLUE_HEADER];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    
    [self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
    self.mapViewAlumni.delegate = self;

    self.slider.minimumValue = 0.1;
    self.slider.maximumValue = 1.0;
    self.slider.value  = 0.1;
    
    if(self.is_login_segue)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(Done)];
        [backButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.bottomView.hidden = YES;
        self.slider.hidden = YES;
        self.geocoder = [[CLGeocoder alloc] init];
        [self getUserCurrentLocation];
    }
    else if(self.is_search_segue)
    {
    
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self loadEducationDetails:self.PFObjectList];
    
    }
    else
    {

        self.geocoder = [[CLGeocoder alloc] init];
        [self getUserCurrentLocation];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)zoomInOutSlider:(UISlider *)sender {
    
    region.span.latitudeDelta = 1*(1.001-slider.value)+0.001;
    region.span.longitudeDelta = 0.001;
    region.center=mapViewAlumni.centerCoordinate;
    [mapViewAlumni setRegion:region animated:TRUE];
}

-(IBAction) Done
{
    if(self.is_login_segue)
    {

        
    }
}

-(void) getUserCurrentLocation
{
    if (![CLLocationManager locationServicesEnabled])
    {
        
        UIAlertView *alertToEnableDeviceLocation = [[UIAlertView alloc] initWithTitle:@"LocationServices"
                                                                              message:@"Please Enable Location Services from Settings"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
        [alertToEnableDeviceLocation show];
        
    }
    else
    {
        locationManager = [[CLLocationManager alloc] init];
        isLocation = YES;
        switch([CLLocationManager authorizationStatus])
        {
            case kCLAuthorizationStatusNotDetermined:
                
                if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                {
                    [locationManager requestWhenInUseAuthorization];
                    locationManager.delegate = self;
                }
                else
                {
                    locationManager.delegate = self;
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    [locationManager startUpdatingLocation];
                }
                break;
            case kCLAuthorizationStatusRestricted:
                
                break;
                
            case kCLAuthorizationStatusDenied:
            {
                UIAlertView *alertToAuth = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please allow Alumni App to use your location from device settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertToAuth show];
                
                break;
            }
            
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [locationManager startUpdatingLocation];
                self.mapViewAlumni.showsUserLocation = YES;
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark pragma CLLocationManager Delegate Implementation

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status== kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    self.location = currLocation;
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    
    if(!self.is_login_segue && !self.is_search_segue){
                [SVProgressHUD showWithStatus:@"Finding Nearby Alumni" maskType:SVProgressHUDMaskTypeClear];
        [self getUsersNearMyLocation:currLocation withInKM:100.0];
    }
    else if (self.is_login_segue)
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate, 700, 700);
         [self.mapViewAlumni setRegion:[self.mapViewAlumni regionThatFits:region] animated:YES];
         self.mapViewAlumni.showsUserLocation = YES;
         isLocation = NO;
         
    }
    
}

- (void)openAnnotation:(id)annotation;
{
    [self.mapViewAlumni selectAnnotation:annotation animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    isLocation = NO;
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}


#pragma mark MKMapView Delegate implementation
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    if (!isSearch && !isLocation)
    {
        [self reverseGeocodeAndDisplayCenterOfMap];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    else if ([annotation isKindOfClass:[AluminiAnnotation class]])
    {
        NSString *annotationIdentifier = @"CustomViewAnnotation";
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if(!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:annotationIdentifier];
        }
        annotationView.image = [UIImage imageNamed:@"pin_e"];
        annotationView.canShowCallout= YES;
        annotationView.enabled = YES;
        
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (void) reverseGeocodeAndDisplayCenterOfMap {
    CLLocationCoordinate2D centerCoord = self.mapViewAlumni.centerCoordinate;
    if (self.geocoder.isGeocoding) {
        [self.geocoder cancelGeocode];
    }
    
    [self performSelector:@selector(checkForGeocoding) withObject:nil afterDelay:0.25];
    
    [self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithCoordinate:centerCoord
                                                                        altitude:0
                                                              horizontalAccuracy:1
                                                                verticalAccuracy:1
                                                                          course:0
                                                                           speed:0
                                                                       timestamp:[NSDate date]]
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error) {
                                NSLog(@"error find here was %@",error);
                            }
                            
                            //self.doneButton.hidden = YES;
                            
                            if ( !error && [placemarks count] > 0)
                            {
                                MKPlacemark *firstPlace = [placemarks firstObject];
                                NSString *locationText = [self niceNameForPlacemark:firstPlace];
                                self.location = firstPlace.location;
                                //[self setAndAddAnnotation:self.location.coordinate];
                                //self.locationLabel.text = locationText;
                            }
                            
                        }];
}

- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = (int)[mapView.annotations count];
    if ( count == 0) { return; }
    
    MKMapPoint points[count];
    for( int i=0; i<count; i++ )
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    
    [mapView setRegion:region animated:animated];
}


- (NSString *)niceNameForPlacemark:(MKPlacemark *)placemark {
    
    NSString *returnString = nil;
    
    if ( placemark.locality && [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] count]==3)
    {
        //[self hideActivity];
        
        NSString *name = [placemark.addressDictionary objectForKey:@"Name"];
        
        NSString *city =[placemark.addressDictionary objectForKey:@"City"];
        
        NSString *state = [placemark.addressDictionary objectForKey:@"State"];
        
        if ([placemark.addressDictionary objectForKey:@"ZIP"])
        {
            state = [NSString stringWithFormat:@"%@ %@", state, [placemark.addressDictionary objectForKey:@"ZIP"] ];
        }
        
        NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
        
        returnString = [NSString stringWithFormat:@"%@, %@, %@, %@", name, city, state, country];
    }
    return returnString;
}


- (void) checkForGeocoding {
    if ([self.geocoder isGeocoding]) {
        //[self showActivity];
    }
}

//- (void) showActivity {
//    [self.activityIndicator startAnimating];
//    self.activityIndicator.hidden = NO;
//    self.locationLabel.hidden = YES;
//    self.doneButton.hidden = YES;
//}
//
//- (void) hideActivity {
//    [self.activityIndicator stopAnimating];
//    self.activityIndicator.hidden = YES;
//    self.locationLabel.hidden = NO;
//    self.doneButton.hidden = NO;
//}

#pragma mark - pragma UISearchbarDelegate Metods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearch = YES;
    [searchBar resignFirstResponder];
    [self startSearch:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    isSearch = NO;
    searchBar.text=nil;
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}


- (void) performSearchWithText : (NSString *) searchText
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = self.mapViewAlumni.region;
    
    NSMutableArray *matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search =[[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [matchingItems addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [self.mapViewAlumni addAnnotation:annotation];
            }
    }];
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    [self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userLocation.latitude;
    newRegion.center.longitude = self.userLocation.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.boundingRegion = response.boundingRegion;
            
            if (response.mapItems.count==0) {
                
            }
            else
            {
                self.places = response.mapItems;
                AluminiSearchResultsTableController *tableController = (AluminiSearchResultsTableController *)self.searchController.searchResultsController;
                tableController.filteredAlumini = self.places;
                [tableController.tableView reloadData];
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void) setAndAddAnnotation : (CLLocationCoordinate2D) Cordinate andAluminiName : (NSString *) nameOfPerson
{
    /*
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = Cordinate;
    [self.mapViewAlumni addAnnotation:annotation];
    */
    
    
    AluminiAnnotation *ann = [[AluminiAnnotation alloc] initWithCoordinate:Cordinate andTitle:nameOfPerson] ;
    [self.mapViewAlumni addAnnotation:ann];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.searchController setActive:NO];
    
    MKMapItem *firstItem = self.places[indexPath.row];
    self.mapitem = firstItem;
    self.location = self.mapitem.placemark.location;
    [self getUsersNearMyLocation:self.location withInKM:20.0];
    
    /*
    [self setAndAddAnnotation:firstItem.placemark.coordinate andAluminiName:firstItem.placemark.name];
    [self.mapViewAlumni setRegion:self.boundingRegion animated:YES];

    
    NSArray *adAra = [firstItem.placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSString *name;
    
    if ([adAra count]<3) {
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"City"])
        {
            name = [firstItem.placemark.addressDictionary objectForKey:@"City"];
        }
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"State"])
        {
            if (name) {
                name = [NSString stringWithFormat:@"%@, %@", name, [firstItem.placemark.addressDictionary objectForKey:@"State"]];
            }
            else
            {
                name = [firstItem.placemark.addressDictionary objectForKey:@"State"];
            }
        }
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"ZIP"])
        {
            name = [NSString stringWithFormat:@"%@ %@", name, [firstItem.placemark.addressDictionary objectForKey:@"ZIP"] ];
        }
        
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"Country"])
        {
            if (name) {
                name = [NSString stringWithFormat:@"%@, %@", name, [firstItem.placemark.addressDictionary objectForKey:@"Country"]];
            }
            else
            {
                name = [firstItem.placemark.addressDictionary objectForKey:@"Country"];
            }
        }
        
    }
    else
    {
        name = [firstItem.placemark.addressDictionary objectForKey:@"Name"];
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"City"])
        {
            if (![name isEqualToString:[firstItem.placemark.addressDictionary objectForKey:@"City"]]) {
                name = [NSString stringWithFormat:@"%@, %@", name, [firstItem.placemark.addressDictionary objectForKey:@"City"]];
            }
        }
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"State"])
        {
            if (![name isEqualToString:[firstItem.placemark.addressDictionary objectForKey:@"State"]]) {
                name = [NSString stringWithFormat:@"%@, %@", name, [firstItem.placemark.addressDictionary objectForKey:@"State"]];
            }
        }
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"ZIP"])
        {
            name = [NSString stringWithFormat:@"%@ %@", name, [firstItem.placemark.addressDictionary objectForKey:@"ZIP"] ];
        }
        
        
        if ([firstItem.placemark.addressDictionary objectForKey:@"Country"])
        {
            if (![name isEqualToString:[firstItem.placemark.addressDictionary objectForKey:@"Country"]]) {
                name = [NSString stringWithFormat:@"%@, %@", name, [firstItem.placemark.addressDictionary objectForKey:@"Country"]];
            }
        }
    }
    */
}

- (void) allAluminiUsers : (NSUInteger ) from
{
    PFQuery *qu = [PFQuery queryWithClassName:@"LinkedInUser"];
   [qu countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    
       self.searchResultCounter.text = [NSString stringWithFormat:@"Showing %lu out of %i", (unsigned long)from, number];
   }];
}


- (void)loadEducationDetails:(NSArray *)userObjects
{
    [self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
    
    [self allAluminiUsers:[userObjects count]];
    
        self.PFObjectList = userObjects;
        [self showAllOnMap:userObjects];
        
        NSMutableDictionary *educationObjects = [[NSMutableDictionary alloc] init];
        
        __block NSUInteger count = 0;
        
        for (PFObject *objCur in userObjects)
        {
            
            PFRelation *relation = [objCur relationForKey:@"userEducation"];
            PFQuery *userEducationQuery = [relation query];
            [userEducationQuery orderByDescending:@"startDate"];
            
            [userEducationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                count ++;
                
                if (object)
                {
                    [educationObjects setObject:object forKey:objCur.objectId];
                }
                else
                {
                    [educationObjects setObject:@"" forKey:objCur.objectId];
                }
                
                if (count==[userObjects count])
                {
                    self.educationData = educationObjects;
                    
                    [SVProgressHUD showSuccessWithStatus:@"Alumni found successfully" maskType:SVProgressHUDMaskTypeClear];
                    
                }
                
            }];
        }
}

-(void)getUsersNearMyLocation : (CLLocation *) locationOfCurUser withInKM : (double) kilomiters
{
    PFQuery *query = [PFQuery queryWithClassName:@"LinkedInUser"];
    [query whereKey:@"coordinates" nearGeoPoint:[PFGeoPoint geoPointWithLocation:locationOfCurUser] withinKilometers:kilomiters];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error)
    {
        if ([userObjects count])
        {
            [self loadEducationDetails:userObjects];
        }
        else if([userObjects count]==0)
        {
            [SVProgressHUD showErrorWithStatus:@"Alumni not found" maskType:SVProgressHUDMaskTypeClear];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"No Alumni found" maskType:SVProgressHUDMaskTypeClear];
            
        }

        
    }];
}

-(void)showAllOnMap : (NSArray *) ObjectsUsers
{
    for (PFObject *obj in ObjectsUsers)
    {
        PFGeoPoint *objGeoPoint = obj[@"coordinates"];
        
        [self setAndAddAnnotation:CLLocationCoordinate2DMake(objGeoPoint.latitude, objGeoPoint.longitude) andAluminiName:[NSString stringWithFormat:@"%@ %@",obj[@"firstName"],obj[@"lastName"]]];
    }
    
    [self zoomMapViewToFitAnnotations:self.mapViewAlumni animated:YES];
}

#pragma mark Wind_Unwind_Functions

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MAP_LIST_SEGUE"]) {
        SocialNewsViewController *vc = [segue destinationViewController];
        vc.navigationItem.title = @"Alumini List";
        vc.is_map_list = YES;
        vc.mapUserList = self.PFObjectList;
        
        NSMutableArray *educat = [[NSMutableArray alloc] init];
        
        for (PFObject *olu in self.PFObjectList)
        {
            [educat addObject:[self.educationData objectForKey:olu.objectId]];
        }
        
        vc.mapUserListData = educat;
    }

}

- (IBAction)unwindToAlumniNearByController:(UIStoryboardSegue *)unwindSegue{
    if ([unwindSegue.sourceViewController isKindOfClass:[SocialNewsViewController class]]) {
        SocialNewsViewController *vc = unwindSegue.sourceViewController;

            PFObject *obj = [self.PFObjectList objectAtIndex:vc.row];
            PFGeoPoint *objGeoPoint = obj[@"coordinates"];
            //[self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
        AluminiAnnotation *annot = [[AluminiAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(objGeoPoint.latitude, objGeoPoint.longitude) andTitle:[NSString stringWithFormat:@"%@ %@",obj[@"firstName"],obj[@"lastName"]]];
        [self.mapViewAlumni addAnnotation:annot];
        [self openAnnotation:annot];
            [self zoomMapViewToFitAnnotations:self.mapViewAlumni animated:YES];

    }
}

#pragma mark - UIStateRestoration

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }

    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [super decodeRestorableStateWithCoder:coder];
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}


@end
