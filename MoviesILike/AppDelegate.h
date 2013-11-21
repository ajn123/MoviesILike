//
//  AppDelegate.h
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Global Data countryCities is used by classes in this project
@property (strong, nonatomic) NSMutableDictionary *favoriteTheaters;

@property (strong, nonatomic) NSMutableDictionary *favoriteMovies;

@end