
#import <UIKit/UIKit.h>

@interface ScrollWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

/*
 [self.cityData objectAtIndex:0] = selectedCityName
 [self.cityData objectAtIndex:1] = selectedCountryName
 */
@property (strong, nonatomic) NSMutableArray *cityData;

@end