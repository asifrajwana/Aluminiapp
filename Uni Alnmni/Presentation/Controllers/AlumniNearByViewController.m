//
//  AlumniNearByViewController.m
//  Uni Alnmni
//
//  Created by asif on 15/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AlumniNearByViewController.h"
#import <Parse/Parse.h>

#define MINIMUM_ZOOM_ARC 0.05 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.25
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

    
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
    [self.footer_view setBackgroundColor:BLUE_HEADER];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    
    [self.searchDisplayController setDelegate:self];
    
    self.searchBar.delegate = self;
    
    self.mapViewAlumni.delegate = self;

    
    region.span = MKCoordinateSpanMake(location.coordinate.latitude , location.coordinate.longitude);
    self.slider.minimumValue = 0.1;
    self.slider.maximumValue = 1.0;
    self.slider.value  = 0.1;
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
//    annotation.coordinate = location.coordinate;
//    //annotation.title = location.;
//    [self.mapViewAlumni addAnnotation:annotation];
    if(self.is_login_segue){
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(Done)];
        [backButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.bottomView.hidden = YES;
        self.slider.hidden = YES;
    }else if(self.is_search_segue){
    
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    }else {
    
        self.geocoder = [[CLGeocoder alloc] init];
        [self getUserCurrentLocation];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //[self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    //annotation.title      = item.name;
    //annotation.subtitle   = item.placemark.title;
    [self.mapViewAlumni addAnnotation:annotation];
    //[self.mapViewAlumni setRegion:self.boundingRegion animated:YES];
}

//CLLocationDegrees

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)zoomInOutSlider:(UISlider *)sender {
    
    region.span.latitudeDelta = 1*(1.001-slider.value)+0.001;
    NSLog(@"%f",region.span.latitudeDelta);
    region.span.longitudeDelta = 0.001;
    region.center=mapViewAlumni.centerCoordinate;
    [mapViewAlumni setRegion:region animated:TRUE];
    
}
//- (IBAction)leftBarDone:(id)sender {
//    if(self.is_login_segue){
//        [self performSegueWithIdentifier:@"UNWIND_TO_LOGIN" sender:nil];
//
//    }
//}

-(IBAction) Done {
    if(self.is_login_segue){
        [self performSegueWithIdentifier:@"UNWIND_TO_LOGIN" sender:nil];
        
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
                self.mapViewAlumni.showsUserLocation=YES;
                
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
    if(!self.is_login_segue && !self.is_search_segue){
        [self getUsersNearMyLocation:currLocation];
    }
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate, 700, 700);
    [self.mapViewAlumni setRegion:[self.mapViewAlumni regionThatFits:region] animated:YES];
    self.mapViewAlumni.showsUserLocation = YES;
    isLocation = NO;
    
    [self.geocoder reverseGeocodeLocation:currLocation
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error) {
                                NSLog(@"error find here was %@",error);
                            }
                            
                            //self.doneButton.hidden = YES;
                            
                            if ( !error && [placemarks count] > 0)
                            {
                                MKPlacemark *firstPlace = [placemarks firstObject];
                                self.location = firstPlace.location;
                                [self setAndAddAnnotation:self.location.coordinate];
                                //NSString *locationText = [self niceNameForPlacemark:firstPlace];
                                //self.locationLabel.text = locationText;
                            }
                            
                        }];
    
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
    
    if (!isSearch && !isLocation) {
        NSLog(@"Called Region Change");
        [self reverseGeocodeAndDisplayCenterOfMap];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[MKAnnotationView class]])
    {
        annotationView = (MKPinAnnotationView *)[self.mapViewAlumni dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.animatesDrop = YES;
        }
    }
    return annotationView;
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
                                //self.location = firstPlace.location;
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


- (void)zoomMapViewToFitAnnotation:(MKMapView *)mapView animated:(BOOL)animated andAnnotation : (MKPointAnnotation *) annotation
{
    
    MKMapPoint points[1];
    for( int i=0; i<1; i++ )
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)annotation coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:1] boundingMapRect];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    
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
    
    //self.locationLabel.text = nil;
    
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
            //[self hideActivity];
            self.boundingRegion = response.boundingRegion;
            
            if (response.mapItems.count==0) {
                //self.locationLabel.text = @"No matching result found";
            }
            else
            {
                self.places = response.mapItems;
                [self.searchDisplayController.searchResultsTableView reloadData];
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


- (void) setAndAddAnnotation : (CLLocationCoordinate2D) Cordinate
{
    //[self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = Cordinate;
    //annotation.title      = item.name;
    //annotation.subtitle   = item.placemark.title;
    [self.mapViewAlumni addAnnotation:annotation];
    //[self.mapViewAlumni setRegion:self.boundingRegion animated:YES];
    //isSearch = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = self.places[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = item.name;
    NSLog(@"Details = %@", item.placemark.addressDictionary);
    NSArray *address = [item.placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    
    NSString *addressString = @"";
    
    for (NSString *add in address) {
        addressString = [addressString stringByAppendingString:add];
        if (add != [address lastObject]) {
            addressString = [addressString stringByAppendingString:@", "];
        }
    }
    
    cell.detailTextLabel.text = addressString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchDisplayController setActive:NO animated:YES];
    MKMapItem *firstItem = self.places[indexPath.row];
    [self setAndAddAnnotation:firstItem.placemark.location.coordinate];
    self.mapitem = firstItem;
    self.location = self.mapitem.placemark.location;
    
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
    
}

-(void)getUsersNearMyLocation : (CLLocation *) locationOfCurUser{
    
    PFQuery *query = [PFQuery queryWithClassName:@"LinkedInUser"];
    //[query selectKeys:[NSArray arrayWithObjects:@"coordinates", nil]];
    [query whereKey:@"coordinates" nearGeoPoint:[PFGeoPoint geoPointWithLocation:locationOfCurUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [self.mapViewAlumni removeAnnotations:self.mapViewAlumni.annotations];
        
        if ([objects count]) {
            self.cordList = objects;
            float a= 0.0;
            float b= 0.0;
            self.PFObjectList = objects;
            [self showAllOnMap];
//            for (PFObject *obj in objects) {
//                NSLog(@"Data : %@",obj);
//                //self.PFObjectList
//                PFGeoPoint *objGeoPoint = obj[@"coordinates"];
//
//                [self setAndAddAnnotation:CLLocationCoordinate2DMake(objGeoPoint.latitude, objGeoPoint.longitude)];
//                
//            }
            //[self zoomMapViewToFitAnnotations:self.mapViewAlumni animated:YES];
        }
        
    }];

}

-(void)showAllOnMap{
    for (PFObject *obj in self.PFObjectList) {
        NSLog(@"Data : %@",obj);
        //self.PFObjectList
        PFGeoPoint *objGeoPoint = obj[@"coordinates"];
        
        [self setAndAddAnnotation:CLLocationCoordinate2DMake(objGeoPoint.latitude, objGeoPoint.longitude)];
        
    }
    //[self zoomMapViewToFitAnnotations:self.mapViewAlumni animated:YES];


}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MAP_LIST_SEGUE"]) {
        SocialNewsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.is_map_list = YES;
        vc.mapUserList = self.PFObjectList;
    }

}

- (IBAction)unwindToAlumniNearByController:(UIStoryboardSegue *)unwindSegue{
    if ([unwindSegue.sourceViewController isKindOfClass:[SocialNewsViewController class]]) {
        SocialNewsViewController *vc = unwindSegue.sourceViewController;
        if (vc.row !=nil) {
            PFObject *obj = [self.PFObjectList objectAtIndex:vc.row];
            PFGeoPoint *objGeoPoint = obj[@"coordinates"];
            
            [self setAndAddAnnotation:CLLocationCoordinate2DMake(objGeoPoint.latitude, objGeoPoint.longitude)];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
