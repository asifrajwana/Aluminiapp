//
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "AluminiSearchResultsTableController.h"

@interface LocationPickerController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property BOOL geocoding;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) NSArray *mapItemList;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSArray *places;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *footer_view;
@property (nonatomic, strong) NSDictionary *dataOfLocation;
@property BOOL is_from_search;

@property (nonatomic, strong) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic, strong) AluminiSearchResultsTableController *resultsTableController;
// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


- (IBAction)donebuttonpressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

