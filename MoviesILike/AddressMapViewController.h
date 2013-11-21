//
//  AddressMapViewController.h
//  VTQuest
//
//  Created by Osman Balci on 10/9/13.
//  Copyright (c) 2013 Osman Balci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressMapViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

// These properties are set by the previous view controller
@property (strong, nonatomic) NSString *googleMapQuery;
@property (strong, nonatomic) NSString *adressEnteredToShowOnMap;

@end