

//
//  CityViewController.h
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMoviesViewController.h"
#import "AppDelegate.h"

@class AppDelegate;


@interface MoviesViewController : UITableViewController <AddCityViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *moviesTableView;


@end