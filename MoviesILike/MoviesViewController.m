//
//  CityViewController.m
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import "MoviesViewController.h"
#import "AddMoviesViewController.h"
#import "MovieWebViewController.h"
#import "AppDelegate.h"

@interface MoviesViewController ()

@property (nonatomic, strong) NSMutableDictionary *favoriteMovies;
@property (nonatomic, strong) NSMutableArray *movieGenres;

// cityData is the data object to be passed to the downstream view controller
@property (nonatomic, strong) NSMutableArray *movieData;

// This method is invoked when the user taps the Add button created at run time.
- (void)addCity:(id)sender;

@end


@implementation MoviesViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    // Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set the local instance variable to the obj ref of the countryCities dictionary
    // data structure created in the App Delegate class
    self.favoriteMovies = appDelegate.favoriteMovies;
    
    // You can set the navigation bar's title either here or in the storyboard
    // self.title = @"My Favorite Cities";
    
    // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    /*
     editButtonItem is provided by the system with its own functionality. Tapping it triggers editing by
     displaying the red minus sign icon on all rows. Tapping the minus sign displays the Delete button.
     The Delete button is handled in the method tableView: commitEditingStyle: forRowAtIndexPath:
     */
    
    // Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addCity:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Obtain a sorted list of country names and store them in a mutable array
    NSMutableArray *sortedCountryNames = (NSMutableArray *)[[self.favoriteMovies allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Set the mutable sorted array to countries
    self.movieGenres = sortedCountryNames;
    
    // Instantiate the City Data object to pass to the downstream view controller
    self.movieData = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}


#pragma mark - Add City Method

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)addCity:(id)sender
{
    // Perform the segue named AddCity
    [self performSegueWithIdentifier:@"AddCity" sender:self];
}


#pragma mark - AddMoviesViewControllerDelegate Protocol Method

/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)addCityViewController:(AddMoviesViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *movieName = controller.cityName.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *actorsName = controller.countryName.text;
        
        
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *genre = controller.primaryGenre.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *youtube = controller.trailerYoutube.text;
        
        NSInteger segIndex = controller.segControl.selectedSegmentIndex;
        
        
        NSString *rating = nil;
        
        if (segIndex == 0)
        {
           rating = @"G";
        }
        if (segIndex == 1)
        {
            rating = @"PG";
        }
        if (segIndex == 2)
        {
            rating = @"PG-13";
        }
        if (segIndex == 3)
        {
            rating = @"R";
        }
        if (segIndex == 4)
        {
            rating = @"NC-17";
        }
   
        
        
        NSArray *currencies = [NSArray arrayWithObjects:movieName,actorsName,youtube,rating, nil];
        
        if ([self.movieGenres containsObject:genre]) {
            
            // Get the list of current cities for the country name entered
            NSMutableDictionary *citiesForCountryNameEntered = [self.favoriteMovies objectForKey:genre];
            
           
            [citiesForCountryNameEntered setObject:currencies forKey:movieName];
            
        }
        else {  // The entered country name does not exist in the current dictionary
            // Create a mutable array containing cityNameEntered
            
            NSMutableDictionary *newGenre = [[NSMutableDictionary alloc] init];
            
            // The new section will intially have 1 new movie, so the key will always be 1.
            [newGenre setObject:currencies forKey:@"1"];
            
            // Add the newly entered genre to the current list of genres.
            [self.favoriteMovies setObject:newGenre forKey:genre];

            
        }
        
        // Obtain a sorted list of genre names and store them in a mutable array
        NSArray *sortedGenreNamesArray = (NSMutableArray *)[[self.favoriteMovies allKeys]
                                                            sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *sortedGenreNames = [[NSMutableArray alloc] initWithArray:sortedGenreNamesArray];
        
        // Set the mutable sorted array to movies.
        self.movieGenres = sortedGenreNames;
        
        // Reload the rows and sections of the Table View favoriteMovieTableView
        [self.moviesTableView reloadData];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource Protocol Methods

/*
 We are implementing a Grouped table view style. In the storyboard file,
 select the Table View. Under the Attributes Inspector, set the Style attribute to Grouped.
 */

// Each table view section corresponds to a country
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.movieGenres count];
}


// Number of cities is the number of rows in the given section (country)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *markedCountry = [self.movieGenres objectAtIndex:section];
    NSMutableArray *cities = [self.favoriteMovies objectForKey:markedCountry];
    return [cities count];
}


// Set the table view section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.movieGenres objectAtIndex:section];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSUInteger sectionNumber = [indexPath section];
    NSUInteger rowNumber = [indexPath row];
    
    // Obtain the name of the current category. This will be used to obtain the corresponding dictionary.
    NSString *markedCategory = [self.movieGenres objectAtIndex:sectionNumber];
    
    
    NSDictionary *currentFavoriteMoviesDict = [self.favoriteMovies objectForKey:markedCategory];
    
    // Sort the dictionary in Alphabetical order.
    NSMutableArray *sortedMovies = (NSMutableArray *)[[currentFavoriteMoviesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Obtain the favorite movie based on row number.
    NSString *currentIndex = sortedMovies[rowNumber];
    
    // Obtain the Array that contains the current movie's details.
    NSArray *currentMovieDetails = [currentFavoriteMoviesDict objectForKey:currentIndex];
    
    NSString *movieName = [currentMovieDetails objectAtIndex:0];
    NSString *topStars = [currentMovieDetails objectAtIndex:1];
    NSString *mpaaRatingImageFileName = [currentMovieDetails objectAtIndex:3];
    
    // PG-13 should reflect the file name, PG13.
    if ([mpaaRatingImageFileName isEqualToString:@"PG-13"])
    {
        mpaaRatingImageFileName = @"PG13";
    }
    // NC-17 should reflect the file name, NC17.
    else if([mpaaRatingImageFileName isEqualToString:@"NC-17"])
    {
        mpaaRatingImageFileName = @"NC17";
    }
    
    
    // Set up cells.
    cell.textLabel.text = movieName;
    cell.detailTextLabel.text = topStars;
    cell.imageView.image = [UIImage imageNamed:mpaaRatingImageFileName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



// We allow each row (city) of the table view to be editable, i.e., deletable or movable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// This is the method invoked when the user taps the Delete button in the Edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // Handle the Delete action
        
        NSString *countryOfCityToDelete = [self.movieGenres objectAtIndex:[indexPath section]];
       
        
        NSMutableDictionary *currentFavoriteMoviesDict = [self.favoriteMovies objectForKey:indexPath];
        
        // Sort the dictionary in Alphabetical order.
        NSMutableDictionary *sortedMovies = (NSMutableDictionary *)[[currentFavoriteMoviesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // Obtain the favorite movie based on row number.
    
        [sortedMovies removeObjectForKey:countryOfCityToDelete];
        
        
        if ([sortedMovies count] == 0) {
            // If no city exists in the currentCities array after deletion, then we need to also delete the country.
            [self.favoriteMovies removeObjectForKey:countryOfCityToDelete];
            
            // Update the list of countries since one is deleted
            NSMutableArray *sortedCountryNames = (NSMutableArray *)[[self.favoriteMovies allKeys]
                                                                    sortedArrayUsingSelector:@selector(compare:)];
            self.movieGenres = sortedCountryNames;
        }
        else {
            // Set the new list of cities for the country
            [self.favoriteMovies setValue:sortedMovies forKey:countryOfCityToDelete];
        }
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.moviesTableView reloadData];
    }
}


/*
 This method is invoked to carry out the row (city) movement after the method
 tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *country = [self.movieGenres objectAtIndex:[fromIndexPath section]];
    
    NSMutableDictionary *cities = [self.favoriteMovies objectForKey:country];
    
    
    // Obtain a sorted list of movie genres and store them in a static array
    NSArray *sortedMovieGenresInStaticArray = [[cities allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Instantiate a new NSMutableArray object to hold the movie genres in a mutable (changeable) array
    NSMutableArray *sortedMovieGenres2 = [[NSMutableArray alloc] initWithArray:sortedMovieGenresInStaticArray];
    
    NSUInteger rowNumberFrom = fromIndexPath.row;
    NSUInteger rowNumberTo = toIndexPath.row;

    
    NSString *cityToMoveFrom = [sortedMovieGenres2 objectAtIndex:rowNumberFrom];
    NSString *cityToMoveTo = [sortedMovieGenres2 objectAtIndex:rowNumberTo];

    [sortedMovieGenres2 replaceObjectAtIndex:rowNumberTo withObject:cityToMoveFrom];
    [sortedMovieGenres2 replaceObjectAtIndex:rowNumberFrom withObject:cityToMoveTo];
    
    // After the change of order, set the countryCities dictionary with the new list of cities
    [self.favoriteMovies setObject:cities forKey:country];
}


// Allow the movement of each row (city)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - UITableViewDelegate Protocol Methods

// Tapping a row (city) displays an alert panel informing the user for the selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedCountryName = [self.movieGenres objectAtIndex:[indexPath section]];
    
    NSMutableDictionary *citiesForSelectedCountry = [self.favoriteMovies objectForKey:selectedCountryName];
    
    
    NSArray *moviesForSelectedGenre_Array = [[citiesForSelectedCountry allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *moviesForSelectedGenre = [[NSMutableArray alloc] initWithArray:moviesForSelectedGenre_Array];

    
    NSString *selectedCityName = [moviesForSelectedGenre objectAtIndex:[indexPath row]];
    
    
    NSArray *currentMovieArray = [citiesForSelectedCountry valueForKey:selectedCityName];
    NSMutableArray *currentMovie = [[NSMutableArray alloc] initWithArray:currentMovieArray];
    
    // Prepare the city data object to pass to the downstream view controller
    [self.movieData insertObject:currentMovie[0] atIndex:0];
    [self.movieData insertObject:currentMovie[2] atIndex:1];
    
    // Perform the segue named ShowCityDetail
    [self performSegueWithIdentifier:@"CityWeb" sender:self];
}




// This method is invoked when the user attempts to move a row (city)
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSString *countryFrom = [self.movieGenres objectAtIndex:[sourceIndexPath section]];
    NSString *countryTo = [self.movieGenres objectAtIndex:[proposedDestinationIndexPath section]];
    
    if (countryFrom != countryTo) {
        
        // The user attempts to move a city from one country to another, which is prohibited
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Move Not Allowed"
                              message:@"Order Movies according to their genre!"
                              delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        return sourceIndexPath;  // The row (city) movement is denied
    }
    else {
        return proposedDestinationIndexPath;  // The row (city) movement is approved
    }
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"AddCity"]) {
        
        // Obtain the object reference of the destination view controller
        AddMoviesViewController *addCityViewController = [segue destinationViewController];
        
        // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
        addCityViewController.delegate = self;
        
    }
     else if ([segueIdentifier isEqualToString:@"CityWeb"]) {
        
        // Obtain the object reference of the destination view controller
        MovieWebViewController *cityWebViewController = [segue destinationViewController];
        
        // Pass the cityData array obj ref to downstream CityWebViewController
        cityWebViewController.movieData = self.movieData;
    }
}

@end


