//
//  AppDelegate.m
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /************************************
     All application-specific and user data files must be written to the Documents directory. Nothing can be written
     into application's main bundle because it is locked for writing after your app is published. The contents of the
     Documents directory are backed up by iTunes during backup of an iOS device. Therefore, the user can recover the
     data written by your app from an earlier device backup.
     
     The Documents directory path on an iOS device is different from the one used for iOS Simulator.
     
     To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
     However, this function was designed originally for Mac OS X, where multiple such directories could exist.
     Therefore, it returns an array of paths rather than a single path.
     For iOS, the resulting array's objectAtIndex:0 is the path to the Documents directory.
     ************************************/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"MyFavoriteMovies.plist"];
                                         //MyFavoriteMovies
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file
    NSMutableDictionary *favoriteMovies = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!favoriteMovies) {
        /*
         In this case, the CountryCities.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example favorite cities.
         
         Get the file path to the CountryCities.plist file in application's main bundle.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"MyFavoriteMovies" ofType:@"plist"];
        
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        favoriteMovies = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    
    self.favoriteMovies = favoriteMovies;
    [self otherDict];
    
    return YES;
}


-(void) otherDict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"MyFavoriteTheaters.plist"];
    //MyFavoriteMovies
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file
    NSMutableDictionary *favoriteMovies = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!favoriteMovies) {
        /*
         In this case, the CountryCities.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example favorite cities.
         
         Get the file path to the CountryCities.plist file in application's main bundle.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"MyFavoriteTheaters" ofType:@"plist"];
        
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        favoriteMovies = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    
    self.favoriteTheaters = favoriteMovies;

}


// Write the countryCities dictionary data structure to hard disk before the app becomes inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"MyFavoriteMovies.plist"];
    
    [self.favoriteMovies writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath2 = [paths2 objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory2 = [documentsDirectoryPath2 stringByAppendingPathComponent:@"MyFavoriteTheaters.plist"];
    
    [self.favoriteTheaters writeToFile:plistFilePathInDocumentsDirectory2 atomically:YES];
}




@end