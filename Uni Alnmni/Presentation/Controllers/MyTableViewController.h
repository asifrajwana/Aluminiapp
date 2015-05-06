

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyTableViewController : UITableViewController <CLLocationManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic)MKMapItem *mapItem;
@property (nonatomic, strong) NSArray *places;
@property (strong) NSString *name;
@property BOOL is_from_login;


@end
