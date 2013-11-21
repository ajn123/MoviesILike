#import <UIKit/UIKit.h>

/*
 We use the Delegation Design Pattern for the communication between the
 AddCityViewController object and the CityViewController Object.
 We define a protocol here and the CityViewController adopts it.
 */
@protocol AddCityViewControllerDelegate;


@interface AddMoviesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *countryName;
@property (strong, nonatomic) IBOutlet UITextField *cityName;


@property (strong, nonatomic) IBOutlet UITextField *primaryGenre;


@property (strong, nonatomic) IBOutlet UITextField *trailerYoutube;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;



@property (nonatomic, assign) id <AddCityViewControllerDelegate> delegate;

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;

// The save: method is invoked when the user taps the Save button created at run time.
- (void)save:(id)sender;

@end


/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol AddCityViewControllerDelegate

- (void)addCityViewController:(AddMoviesViewController *)controller didFinishWithSave:(BOOL)save;

@end