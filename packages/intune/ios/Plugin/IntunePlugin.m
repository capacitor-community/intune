#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(IntuneMAM, "IntuneMAM",
  CAP_PLUGIN_METHOD(loginAndEnrollAccount, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(acquireToken, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(acquireTokenSilent, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(registerAndEnrollAccount, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(enrolledAccount, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(deRegisterAndUnenrollAccount, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(logoutOfAccount, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(getPolicy, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(groupName, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(appConfig, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(sdkVersion, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(displayDiagnosticConsole, CAPPluginReturnPromise);
)
