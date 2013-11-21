//
//  Autos1ViewController.m
//  Autos
//
//  Created by Osman Balci on 10/21/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import "ScrollViewController.h"
#import "ScrollWebViewController.h"

@interface ScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollMenu;
@property (nonatomic, strong) UIImageView *leftArrowWhite;
@property (nonatomic, strong) UIImageView *rightArrowWhite;
@property (nonatomic, strong) UITableView *autoTableView;

@property (nonatomic, strong) UIButton *previousButton;

@property (nonatomic, strong) NSDictionary *genres;
@property (nonatomic, strong) NSArray *autoMakers;

@property (nonatomic, strong) NSString *selectedAutoMaker;

@property (nonatomic, strong) NSMutableArray *currentSelection;
// This method is invoked when a button in the horizontally scrollable menu is tapped
- (void)buttonPressed:(id)sender;

@end


@implementation ScrollViewController

- (void)viewDidLoad {
    // Instantiate the City Data object to pass to the downstream view controller
    self.currentSelection = [[NSMutableArray alloc] init];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    /**************************************************************************
     * Read in the Automobiles.plist file content
     **************************************************************************/
    
    // Obtain the file path to the Automobiles.plist file, which resides in the main bundle (project folder)
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyFavoriteMovies" ofType:@"plist"];
    
    // Instantiate a static dictionary and initialize it with the content of the Automobiles.plist file
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    // Set the object reference we declared in the header file to point to the newly created dictionary
    self.genres = dictionary;
    
    // Obtain a sorted array of keys, i.e., the names of the automobile manufacturers
    NSArray *autoManufacturers = [[self.genres allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Set the object reference we declared in the header file to point to the newly created array
    self.autoMakers = autoManufacturers;
    
    
    /**************************************************************************
     * Instantiate and position a UITableView object
     **************************************************************************/
    
    // Instantiate a new table view object and position it at
    // x=0, y=kScrollMenuHeight, width=frame's width, height=frame's height - kScrollMenuHeight
    UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kScrollMenuHeight+60,
                                                                              self.view.frame.size.width, self.view.frame.size.height - kScrollMenuHeight)];

    /*--------------- Auto Resize the Table View Object -------------------------------------------------------
     Ask the table view object to automatically resize itself horizontally and vertically:
     UIViewAutoresizingFlexibleWidth  --> The table view resizes itself by expanding or shrinking its width.
     UIViewAutoresizingFlexibleHeight --> The table view resizes itself by expanding or shrinking its height.
     ---------------------------------------------------------------------------------------------------------*/
    [newTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.autoTableView = newTableView;
    self.autoTableView.dataSource = self;
    self.autoTableView.delegate = self;
    
    /*
     We use the Red Green Blue Alpha (RGBA) color space in defining colors. Each RGB color is defined from 0 to 255.
     Below the color values are given as a float value out of 255. For example, Red = 191, which is 191/255 = 0.75
     Alpha defines the amount of transparency.
     If Alpha = 0.0, the object is fully transparent, i.e., invisible.
     If Alpha = 1.0, the object is fully visible.
     */
    self.autoTableView.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
    
    // Place the newly created table view object on top of the View object
    // according to its (x, y) position and size (width, height)
    [self.view addSubview:self.autoTableView];
    
    
    /*******************************************************************************
     * Instantiate and position the two arrow icons with size 10x20 pixels
     *******************************************************************************/
    
    UIImageView *leftArrowImageView = [[UIImageView alloc]
                                       initWithFrame:CGRectMake(0.0, ((kScrollMenuHeight-20.0)/2.0)+60, 10.0, 20.0)];
    
    self.leftArrowWhite = leftArrowImageView;
    self.leftArrowWhite.image = [UIImage imageNamed:@"leftArrowWhite.png"];
    
    // Place the newly created image view object, holding the arrow icon, on top of the View object
    // according to its (x, y) position and size (width, height)
    [self.view addSubview:self.leftArrowWhite];
    
    UIImageView *rightArrowImageView = [[UIImageView alloc]
                                        initWithFrame:CGRectMake(self.view.frame.size.width-10.0, ((kScrollMenuHeight-20.0)/2.0)+60, 10.0, 20.0)];
    
    self.rightArrowWhite = rightArrowImageView;
    self.rightArrowWhite.image = [UIImage imageNamed:@"rightArrowWhite.png"];
    
    self.leftArrowWhite.hidden = YES;
    self.rightArrowWhite.hidden = NO;
    
    // Place the newly created image view object, holding the arrow icon, on top of the View object
    // according to its (x, y) position and size (width, height)
    [self.view addSubview:self.rightArrowWhite];
    
    /*-------------------- Auto Position the Right Arrow Object -----------------------------
     - Disable the right arrow object's auto resizing mask.
     - Create a constraint for the view object to position the right arrow object properly.
     --------------------------------------------------------------------------------------*/
    
    // Disable the right arrow object's auto resizing mask.
    [self.rightArrowWhite setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Create a constraint for the view object to position the right arrow object properly.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightArrowWhite attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    /*******************************************************************************
     * Instantiate and position a UIScrollView (horizontally scrollable menu) object
     *******************************************************************************/
    
    UIScrollView *newScrollView = [[UIScrollView alloc]
                                   initWithFrame:CGRectMake(10.0, 60.0, self.view.frame.size.width -20, kScrollMenuHeight)];
    
    self.scrollMenu = newScrollView;
    
    /*--------------- Auto Resize the Scroll View Object -------------------------------------------------------
     Ask the scroll view object to automatically resize itself horizontally:
     UIViewAutoresizingFlexibleWidth  --> The scroll view resizes itself by expanding or shrinking its width.
     ---------------------------------------------------------------------------------------------------------*/
    [self.scrollMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    // Set the attributes of the UIScrollView (horizontally scrollable menu) object
    
    self.scrollMenu.backgroundColor = [UIColor blackColor];
    self.scrollMenu.showsHorizontalScrollIndicator = FALSE;
    self.scrollMenu.showsVerticalScrollIndicator = FALSE;
    self.scrollMenu.scrollEnabled = YES;
    self.scrollMenu.bounces = YES;
    
    // Set the UIScrollView object's delegate to be self
    
    self.scrollMenu.delegate = self;
    
    
    /**************************************************************************
     * Instantiate and setup the buttons for the horizontally scrollable menu
     **************************************************************************/
    
    // Instantiate a mutable array to hold the menu buttons to be created
    NSMutableArray *listOfMenuButtons = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.autoMakers count]; i++)
    {
        // Instantiate a button to be placed within the horizontally scrollable menu
        UIButton *scrollMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Obtain the title (=auto maker name) to be displayed on the button
        NSString *buttonTitle = [self.autoMakers objectAtIndex:i];
        
        // The button width and height will depend on its font style and size
        UIFont *buttonTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        
        // Set the font of the button title label text
        scrollMenuButton.titleLabel.font = buttonTitleFont;
        
        // Compute the size of the button title in pixels
        CGSize buttonTitleSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:buttonTitleFont}];
        
        // Add 20 pixels to the width to leave 10 pixels on each side
        float buttonWidth = buttonTitleSize.width + 20.0;
        
        // Set the button frame with width=buttonWidth height=kScrollMenuHeight pixels
        // with origin at (x, y) = (0, 0)
        [scrollMenuButton setFrame:CGRectMake(0.0, 0.0, buttonWidth, kScrollMenuHeight)];
        
        // Set the background color of the button to black
        scrollMenuButton.backgroundColor = [UIColor blackColor];
        
        // Set the button title to the automobile manufacturer's name
        [scrollMenuButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        // Set the button title color to white
        [scrollMenuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // Set the button title color to blue when the button is selected
        [scrollMenuButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        // Set the button to invoke the buttonPressed: method when the user taps it
        [scrollMenuButton addTarget:self action:@selector(buttonPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        // Add the constructed button to the list of buttons
        [listOfMenuButtons addObject:scrollMenuButton];
    }
    
    
    /**************************************************************************
     * Compute the sumOfButtonWidths = sum of the widths of all buttons to be displayed in the menu
     **************************************************************************/
    
    float sumOfButtonWidths = 0.0;
    
    for(int i = 0; i < [listOfMenuButtons count]; i++)
    {
        // Obtain the obj ref to the next button in the listOfMenuButtons array
        UIButton *button = [listOfMenuButtons objectAtIndex:i];
        
        // Set the button's frame to buttonRect
        CGRect buttonRect = button.frame;
        
        // Set the buttonRect's x coordinate value to totalButtonWidth
        buttonRect.origin.x = sumOfButtonWidths;
        
        // Set the button's frame to the newly specified buttonRect
        [button setFrame:buttonRect];
        
        // Add the button to the horizontally scrollable menu
        [self.scrollMenu addSubview:button];
        
        // Add the width of the button to the total width
        sumOfButtonWidths += button.frame.size.width;
    }
    
    // Horizontally scrollable menu's content width size = the sum of the widths of all of the buttons
    // Horizontally scrollable menu's content height size = kScrollMenuHeight points
    self.scrollMenu.contentSize = CGSizeMake(sumOfButtonWidths, kScrollMenuHeight);
    
    // Add the horizontally scrollable menu as a subview to the current view
    [self.view addSubview:self.scrollMenu];
    
    /**************************************************************************
     * Select and show the default auto maker upon app launch
     **************************************************************************/
    
    // The first auto maker on the list is the default one to display
    UIButton *defaultButton = [listOfMenuButtons objectAtIndex:0];
    
    // Indicate that the button is selected
    defaultButton.selected = YES;
    
    self.previousButton = defaultButton;
    self.selectedAutoMaker = [self.autoMakers objectAtIndex:0];
    
    // Display the table view object's content for the selected auto maker
    [self.autoTableView reloadData];
    
    [super viewDidLoad];
}



// This method is invoked when the user taps a button in the horizontally scrollable menu
- (void)buttonPressed:(id)sender {
    
    UIButton *selectedButton = (UIButton *)sender;
    
    selectedButton.selected = YES;
    
    if (self.previousButton != selectedButton) {
        // Selecting the selected button again should not change its title color
        self.previousButton.selected = NO;
    }
    
    self.previousButton = selectedButton;
    
    self.selectedAutoMaker = [selectedButton titleForState:UIControlStateNormal];
    
    // Redisplay the table view object's content for the selected auto maker
    [self.autoTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - UIScrollViewDelegate Method

// Tells the delegate when the user scrolls the content view within the receiver
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // The autoTableView object scrolling also invokes this method, in the case of which no action
    // should be taken since this method is created to handle only the scrollMenu object's scrolling
    if ([scrollView isEqual:self.autoTableView]) {
        return;
    }
    
    /*
     Content = concatenated list of buttons
     Content Width = sumOfButtonWidths as we calculated above
     Origin = (x, y) values of the bottom left corner of the scroll view or content
     Sx = Scroll View's origin x value
     Cx = Content's origin x value
     contentOffset = difference between Sx and Cx
     
     If contentOffset <= 5 pixels, then the the content (list of buttons) is scrolled all
     the way to the right.
     
     Interpretation of the Arrows:
     
     IF scrolled all the way to the RIGHT THEN
     show only RIGHT arrow: indicating that
     the data (content) is on the right hand side and therefore,
     the user must *** scroll to the left *** to see the content.
     
     IF scrolled all the way to the LEFT THEN
     show only LEFT arrow: indicating that
     the data (content) is on the left hand side and therefore,
     the user must *** scroll to the right *** to see the content.
     
     5 pixels used as padding
     */
    if(scrollView.contentOffset.x <= 5) {
        // Scrolling is done all the way to the RIGHT
        self.leftArrowWhite.hidden = YES;   // Hide left arrow
        self.rightArrowWhite.hidden = NO;   // Show right arrow
    }
    else if(scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5) {
        // Scrolling is done all the way to the LEFT
        self.leftArrowWhite.hidden = NO;    // Show left arrow
        self.rightArrowWhite.hidden = YES;  // Hide right arrow
    }
    else {
        // Scrolling is in between. Scrolling can be done in either direction.
        self.leftArrowWhite.hidden = NO;    // Show left arrow
        self.rightArrowWhite.hidden = NO;   // Show right arrow
    }
}


#pragma mark - Table View Data Source Methods

// Asks the data source to return the number of rows in a section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Create a static array containing all of the model names for the selected auto maker
    NSArray *modelsForSelectedMaker = [self.genres objectForKey:self.selectedAutoMaker];
    
    // Return the number of model names for the selected auto maker
    // We subtract 1 because the first item is the name of the logo image file
    return [modelsForSelectedMaker count];
}


// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
  
    NSDictionary *currentFavoriteMoviesDict = [self.genres objectForKey:self.selectedAutoMaker];
    
    // Sort the dictionary in Alphabetical order.
    NSMutableArray *sortedMovies = (NSMutableArray *)[[currentFavoriteMoviesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Obtain the favorite movie based on row number.
    NSString *currentIndex = sortedMovies[rowNumber];
    
    // Obtain the Array that contains the current movie's details.
    NSArray *currentMovieDetails = [currentFavoriteMoviesDict objectForKey:currentIndex];
    
    
    
    
    
    
    
    
    NSString *cellIdentifier = @"autoModelCell";
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // We add 1 to row number because the first item is the name of the logo image file
   // NSArray *modelsForSelectedMakers2 =    [modelsForSelectedMaker objectAtIndex:rowNumber ];
    
    
    cell.textLabel.text = [currentMovieDetails objectAtIndex:0 ];
    cell.imageView.image = [UIImage imageNamed:@"movieIcon"];
    // Add the manufacturer's logo for each auto model name listed in the table view
  //  UIImage *logo = [UIImage imageNamed:[modelsForSelectedMaker objectAtIndex:0]];
  //  cell.imageView.image = logo;
    
    return cell;
}


#pragma mark - Table View Delegate Methods

// Tells the delegate (=self) that the row specified under indexPath is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    NSDictionary *currentFavoriteMoviesDict = [self.genres objectForKey:self.selectedAutoMaker];
    
    // Sort the dictionary in Alphabetical order.
    NSMutableArray *sortedMovies = (NSMutableArray *)[[currentFavoriteMoviesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Obtain the favorite movie based on row number.
    NSString *currentIndex = sortedMovies[rowNumber];
    
    // Obtain the Array that contains the current movie's details.
    NSMutableArray *currentMovieDetails = [currentFavoriteMoviesDict objectForKey:currentIndex];
    
    
    [self.currentSelection insertObject:currentMovieDetails[0] atIndex:0];
    [self.currentSelection insertObject:currentMovieDetails[2] atIndex:1];

    [self performSegueWithIdentifier:@"Website" sender:self];
}


#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    

    if ([segueIdentifier isEqualToString:@"Website"]) {
        
        // Obtain the object reference of the destination view controller
      ScrollWebViewController *cityWebViewController = [segue destinationViewController];
   
        // Pass the cityData array obj ref to downstream CityWebViewController
        cityWebViewController.cityData = self.currentSelection;
    }
}


@end