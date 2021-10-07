#import "AppDelegate+IntuneMAM.h"
#import <MSAL/MSAL.h>

@implementation AppDelegate (IntuneMAM)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  return [MSALPublicClientApplication handleMSALResponse:url sourceApplication:[options valueForKey:UIApplicationOpenURLOptionsSourceApplicationKey]];
}

@end