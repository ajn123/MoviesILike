/**
 
 
 
*/
#import <UIKit/UIKit.h>

@interface MovieWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSMutableArray *movieData;

@end