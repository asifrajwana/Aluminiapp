//
//  AluminiSearchResultsTableController.m
//  Alnmni App

//

#import "AluminiSearchResultsTableController.h"

@interface AluminiSearchResultsTableController ()

@end

@implementation AluminiSearchResultsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredAlumini.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"aluminicell"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aluminicell"];
    }
    
    MKMapItem *item = [self.filteredAlumini objectAtIndex:indexPath.row];
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

@end
