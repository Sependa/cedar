#import "OCUnitAppAppDelegate.h"

@implementation OCUnitAppAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [[[UIViewController alloc] init] autorelease];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
