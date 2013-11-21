

#import "TheaterViewController.h"
#import "AddressMapViewController.h"
#import "DirectionsViewController.h"
#import "AddCityViewController.h"
#import "DeleteCityViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TheaterViewController ()

@property (strong, nonatomic) NSMutableDictionary  *vtPlaceNameDict;
@property (strong, nonatomic) NSMutableArray       *vtPlaceNames;
@property (strong, nonatomic) NSDictionary  *vtPlaceData;

@property (strong, nonatomic) NSString      *googleMapQuery;

@property (strong, nonatomic) NSString      *fromPlaceSelected;
@property (strong, nonatomic) NSString      *toPlaceSelected;

@property (strong, nonatomic) NSString      *placeFromCoordinates;
@property (strong, nonatomic) NSString      *placeToCoordinates;

@property (strong, nonatomic) NSString      *directionsType;
@property (strong, nonatomic) NSString      *mapsHtmlAbsoluteFilePath;


@property (strong, nonatomic) CLLocationManager *locationManager;


- (void)addCity:(id)sender;



- (void)deleteCity:(id)sender;

@end

static BOOL viewShownFirstTime = TRUE;

NSString *strFirstPickerView;

double longitudeValue;
double latitudeValue;


@implementation TheaterViewController

- (void)viewDidLoad
{
    
    // Instantiate a CLLocationManager object and store its object reference
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the current view controller to be the delegate of the location manager object
    self.locationManager.delegate = self;
    
    // Set the location manager's distance filter to kCLDistanceFilterNone implying that
    // a location update will be sent regardless of movement of the device
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // Set the location manager's desired accuracy within ten meters of the desired target
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Start the generation of updates that report the user’s current location.
    // Implement the protocol method below to receive and process the location info.
    
    [self.locationManager startUpdatingLocation];
    
    
    
    
    self.walkingDirections.selectedSegmentIndex = -1;
    
    
    UIBarButtonItem *addButton2 = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                  target:self action:@selector(deleteCity:)];
    
    
    // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = addButton2;
    
    /*
     editButtonItem is provided by the system with its own functionality. Tapping it triggers editing by
     displaying the red minus sign icon on all rows. Tapping the minus sign displays the Delete button.
     The Delete button is handled in the method tableView: commitEditingStyle: forRowAtIndexPath:
     */
    
    // Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addCity:)];
    
    // Set up the Add custom button on the right of the n
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    
    
    
    
    
    // Obtain the object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Obtain the object reference to the vtPlaceNameDict dictionary object created in the App Delegate class
    self.vtPlaceNameDict = appDelegate.favoriteTheaters;
    
    
    // Obtain a sorted list of movie genres and store them in a static array
    NSArray *sortedMovieGenresInStaticArray = [[self.vtPlaceNameDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    self.vtPlaceNames = sortedMovieGenresInStaticArray;
 
    // Obtain the object reference to the vtPlaceNames array object created in the App Delegate class
 
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    [super viewDidLoad];
}

- (void)addCity:(id)sender
{
    // Perform the segue named AddCity
    [self performSegueWithIdentifier:@"AddCity" sender:self];
}


- (void)deleteCity:(id)sender
{
    [self performSegueWithIdentifier:@"DeleteCity" sender:self];
}








- (void)viewWillAppear:(BOOL)animated {
    
    // Obtain the number of the row in the middle of the VT place names list
    int numberOfRowToShow = (int)([self.vtPlaceNames count] / 2);
    
    // Show the picker view of VT place names from the middle
    [self.pickerView selectRow:numberOfRowToShow inComponent:0 animated:NO];
    
    // Deselect the earlier selected directions type
    [self.directionsTypeSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (viewShownFirstTime) {
        viewShownFirstTime = FALSE;
    } else {
   
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.vtPlaceNames count];
}


#pragma mark - Picker Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    strFirstPickerView = [self.vtPlaceNames  objectAtIndex:row];
    
   
    
    return [self.vtPlaceNames objectAtIndex:row];
}






#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Address"]) {
        
        // Obtain the object reference of the destination view controller
        AddressMapViewController *addressMapViewController = [segue destinationViewController];
        
        // Pass the data object _addressToShowOnMap to the destination view controller object
        addressMapViewController.googleMapQuery = self.googleMapQuery;
        addressMapViewController.adressEnteredToShowOnMap = [self.vtPlaceNameDict objectForKey:strFirstPickerView];
    }
    
    if ([[segue identifier] isEqualToString:@"CampusDirections"]) {
        
        // Obtain the object reference of the destination view controller
        DirectionsViewController *campusDirectionsMapViewController = [segue destinationViewController];
        
        // Pass the data object self.googleMapQuery to the destination view controller object
        campusDirectionsMapViewController.googleMapQuery = self.googleMapQuery;
        
        // Pass the data object self.directionsType to the destination view controller object
        campusDirectionsMapViewController.directionsType = self.directionsType;
    }
    
    if ([[segue identifier] isEqualToString:@"AddCity"]) {
        
        // Obtain the object reference of the destination view controller
        AddCityViewController *addCityViewController = [segue destinationViewController];
        
        // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
        addCityViewController.delegate = self;
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"DeleteCity"]) {
        
        // Obtain the object reference of the destination view controller
        DeleteCityViewController *addCityViewController = [segue destinationViewController];
        
        addCityViewController.theaterName=  strFirstPickerView;
        addCityViewController.theaterAddress = [self.vtPlaceNameDict objectForKey:strFirstPickerView];
        
        // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
        addCityViewController.delegate = self;
        
    }
    
    
    
    
    
    
    
}












- (IBAction)directionTapped:(id)sender {
    
    NSString *string = [self.vtPlaceNameDict objectForKey:strFirstPickerView];
    
    // Replace all occurrences of space in the address with +
    NSString *addressToShowOnMap = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    switch ([self.directionsTypeSegmentedControl selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=ROADMAP&zoom=16", addressToShowOnMap];
            break;
            
        case 1:   // Satellite map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=SATELLITE&zoom=16", addressToShowOnMap];
            break;
            
        case 2:   // Hybrid map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=HYBRID&zoom=16", addressToShowOnMap];
            break;
            
        case 3:   // Terrain map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=TERRAIN&zoom=16", addressToShowOnMap];
            break;
            
        default:
        {
            // Create and display an error message
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                                   message:@"Please select a map type!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil];
            
            [alertMessage show];
            return;
        }
    }
    
    // Perform the segue named Address
    [self performSegueWithIdentifier:@"Address" sender:self];

}


// Tells the delegate that a new location data is available
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    /*
     The objects in the given locations array are ordered with respect to their occurrence times.
     Therefore, the most recent location update is at the end of the array; hence, we access the last object.
     */
    CLLocation *currentLocation = [locations lastObject];
    
    // Obtain current location's latitude in degrees (as a double value)
     latitudeValue = currentLocation.coordinate.latitude;
    
    // Obtain current location's longitude in degrees (as a double value)
     longitudeValue = currentLocation.coordinate.longitude;
    
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
     The kCLErrorLocationUnknown error implies that the manager is currently unable to get the location.
     We can ignore this error for the scenario of getting a single location fix, because we already
     have a timeout that will stop the location manager to save power.
     */
    if ([error code] == kCLErrorLocationUnknown) {
        
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Obtain Your Location"
                                                        message:@"Your location could not be determined!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        
        // Display the Alert View
        [alert show];
        
        // Stop the generation of location updates since we do not need it anymore
        [manager stopUpdatingLocation];
    }
}

- (IBAction)walkingTapped:(id)sender {
    
    
 
    
    // Obtain the GPS coordinates (latitude,longitude) for starting FROM campus place selected
    self.vtPlaceData = [self.vtPlaceNameDict objectForKey:self.fromPlaceSelected];
   // self.placeFromCoordinates = [location coordinate];
    
    

    
    NSString *string = [self.vtPlaceNameDict objectForKey:strFirstPickerView];
    
    
    // Obtain the GPS coordinates (latitude,longitude) for destination TO campus place selected
    self.vtPlaceData = [self.vtPlaceNameDict objectForKey:self.toPlaceSelected];
    self.placeToCoordinates =  [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    
    switch ([sender selectedSegmentIndex]) {
            
        case 0:  // Compose the Google directions query for DRIVING  Current+Location&lat=%f&lng=%f
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%f,%f&end=%@&traveltype=DRIVING",
                                   latitudeValue,longitudeValue, self.placeToCoordinates];
            self.directionsType = @"Driving";
            break;
            
        case 1:  // Compose the Google directions query for WALKING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%f,%f&end=%@&traveltype=WALKING",
                                   latitudeValue,longitudeValue,  self.placeToCoordinates];
            self.directionsType = @"Walking";
            break;
            
        case 2:  // Compose the Google directions query for BICYCLING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%f,%f&end=%@&traveltype=BICYCLING",
                                  latitudeValue,longitudeValue,  self.placeToCoordinates];
            self.directionsType = @"Bicycling";
            break;
            
        case 3:  // Compose the Google directions query for TRANSIT
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%f,%f&end=%@&traveltype=TRANSIT",
                                  latitudeValue,longitudeValue, self.placeToCoordinates];
            self.directionsType = @"Transit";
            break;
            
        default:
            break;
    }
    
    // Perform the segue named CampusDirections
    [self performSegueWithIdentifier:@"CampusDirections" sender:self];
    
}




/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)addCityViewController:(AddCityViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *countryNameEntered = controller.countryName.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *cityNameEntered = controller.cityName.text;
        
        if ([self.vtPlaceNames containsObject:countryNameEntered]) {
            
            // Get the list of current cities for the country name entered
            NSMutableArray *citiesForCountryNameEntered = [self.vtPlaceNameDict objectForKey:countryNameEntered];
            
            
            // Set the new list of cities for the country name entered
            [self.vtPlaceNameDict setValue:cityNameEntered forKey:countryNameEntered];
            
        }
        else {  // The entered country name does not exist in the current dictionary
            // Create a mutable array containing cityNameEntered
            NSMutableArray *citiesForCountryNameEntered = [NSMutableArray arrayWithObject:cityNameEntered];
            
            // Add the new country-city key-value pair to the countryCities mutable dictionary
            [self.vtPlaceNameDict setObject:citiesForCountryNameEntered forKey:countryNameEntered];
        }
        
        // Obtain a sorted list of country names and store them in a mutable array
        NSMutableArray *sortedCountryNames = (NSMutableArray *)[[self.vtPlaceNameDict allKeys]
                                                                sortedArrayUsingSelector:@selector(compare:)];
        
        self.vtPlaceNames = sortedCountryNames;  // Set the mutable sorted array to countries
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.pickerView reloadAllComponents];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}









/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)deleteCityViewController:(AddCityViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *countryNameEntered = controller.countryName.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *cityNameEntered = controller.cityName.text;
        
        if ([self.vtPlaceNames containsObject:countryNameEntered]) {
            // Get the list of current cities for the country name entered
            NSMutableArray *citiesForCountryNameEntered = [self.vtPlaceNameDict objectForKey:countryNameEntered];
            
            // Add the new city to that list
            [self.vtPlaceNameDict removeObjectForKey:countryNameEntered];
            
            
        }
        // Obtain a sorted list of country names and store them in a mutable array
        NSMutableArray *sortedCountryNames = (NSMutableArray *)[[self.vtPlaceNameDict allKeys]
                                                                sortedArrayUsingSelector:@selector(compare:)];
        
        self.vtPlaceNames = sortedCountryNames;  // Set the mutable sorted array to countries
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.pickerView reloadAllComponents];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}











@end
