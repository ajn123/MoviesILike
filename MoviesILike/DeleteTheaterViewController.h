//
//  AddCityViewController.h
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTheaterViewController.h"

/*
 We use the Delegation Design Pattern for the communication between the
 AddCityViewController object and the CityViewController Object.
 We define a protocol here and the CityViewController adopts it.
 */
@protocol DeleteCityViewControllerDelegate;


@interface DeleteTheaterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *countryName;
@property (strong, nonatomic) IBOutlet UITextField *cityName;

@property (strong, nonatomic) IBOutlet UIButton *button;




@property (strong, nonatomic) NSString      *theaterName;
@property (strong, nonatomic) NSString      *theaterAddress;


@property (nonatomic, assign) id <DeleteCityViewControllerDelegate> delegate;
@property (nonatomic, assign) id <AddCityViewControllerDelegate> delegates;

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;

// The save: method is invoked when the user taps the Save button created at run time.
- (void)save:(id)sender;
- (IBAction)buttonPressed:(id)sender;

@end

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol DeleteCityViewControllerDelegate

- (void)deleteCityViewController:(DeleteTheaterViewController *)controller didFinishWithSave:(BOOL)save;

- (void)addCityViewController:(AddTheaterViewController *)controller didFinishWithSave:(BOOL)save;




@end