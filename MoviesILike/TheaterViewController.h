//
//  TheaterViewController.h
//  MoviesILike
//
//  Created by Ajs mac on 11/20/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface TheaterViewController : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource>



@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *directionsTypeSegmentedControl;

- (IBAction)directionTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *walkingDirections;

- (IBAction)walkingTapped:(id)sender;

@end



