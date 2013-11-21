
//
//  CityWebViewController.m
//  CitiesILike
//
//  Created by Osman Balci on 9/23/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import "MovieWebViewController.h"

@interface MovieWebViewController ()

@end

@implementation MovieWebViewController

- (void)viewDidLoad {
    
    // Obtain the selected city name
    NSString *selectedCityName = [self.movieData objectAtIndex:0];
    
    // Set the title of the view controller to the selected city name
    self.title = selectedCityName;
    
    selectedCityName = [self.movieData objectAtIndex:1];
    
    // The URL cannot have spaces; therefore replace each space in the city name with underscore.
    // Example: The city name "Rio de Janeiro" needs to be converted to "Rio_de_Janeiro"
    NSString *selectedCityNameWithNoSpaces = [selectedCityName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSString *websiteURL = [[NSString alloc] initWithFormat:@"http://www.youtube.com/embed/%@", selectedCityNameWithNoSpaces];
    
    // Asks the UIWebView object to display the web page at URL = websiteURL
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:websiteURL]]];
    
    [super viewDidLoad];   // Inform Super
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.webView loadHTMLString:errorString baseURL:nil];
}

@end