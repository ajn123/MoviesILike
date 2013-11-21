//
//  AddCityViewController.m
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import "AddTheaterViewController.h"

@interface AddTheaterViewController ()

@end

@implementation AddTheaterViewController

- (void)viewDidLoad
{
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
}


-(void)dismissKeyboard {
    [self.countryName resignFirstResponder];
    [self.cityName resignFirstResponder];
}


- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}


- (void)save:(id)sender
{
    
    if (self.countryName.text.length > 0 &&  self.cityName.text.length > 0 ) {
        // Inform the delegate that the user tapped the Save button
        [self.delegate addCityViewController:self didFinishWithSave:YES];
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Invalid Text Boxes"
                              message:@"Please fill out both boxes"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

@end