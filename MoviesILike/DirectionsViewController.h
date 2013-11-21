//
//  DirectionsViewController.h
//  MoviesILike
//
//  Created by Ajs mac on 11/20/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsViewController : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *webView;



// These properties are set by the previous view controller
@property (strong, nonatomic) NSString *googleMapQuery;
@property (strong, nonatomic) NSString *directionsType;


@end
