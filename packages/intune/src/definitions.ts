import { PluginListenerHandle } from '@capacitor/core';

export interface IntuneMAMAcquireTokenOptions {
  scopes: string[];
  /**
   * Whether to force the user to enter their password each time they authenticate.
   * 
   * Default: false
   */
  forcePrompt?: boolean;
}

export interface IntuneMAMAcquireTokenSilentOptions
  extends IntuneMAMAcquireTokenOptions {
  upn: string;

  /**
   * Whether to force the tokens to be refresh regardless of whether the cached token is expired or not.
   * 
   * Default: false
   */
  forceRefresh?: boolean;
}

export interface IntuneMAMAcquireToken {
  upn: string;
  accessToken: string;
  accountIdentifier: string;
  idToken?: string;
}

export interface IntuneMAMRegisterAndEnrollAccountOptions {
  upn: string;
}

export interface IntuneMAMUser {
  upn: string;
}

export interface IntuneMAMVersionInfo {
  version: string;
}

export interface IntuneMAMGroupName {
  value: string;
}

export interface IntuneMAMAppConfig {
  [key: string]: any;
}

export interface IntuneMAMPolicy {
  // Cross-platform policy fields
  contactSyncAllowed: boolean;
  pinRequired: boolean;
  managedBrowserRequired: boolean;

  // Android fields
  screenCaptureAllowed?: boolean;

  [key: string]: any;
}

export interface IntuneMAMPlugin {
  enrolledAccount: () => Promise<IntuneMAMUser>;
  acquireToken: (
    options: IntuneMAMAcquireTokenOptions,
  ) => Promise<IntuneMAMAcquireToken>;
  acquireTokenSilent: (
    options: IntuneMAMAcquireTokenSilentOptions,
  ) => Promise<IntuneMAMAcquireToken>;
  registerAndEnrollAccount: (
    options: IntuneMAMRegisterAndEnrollAccountOptions,
  ) => Promise<void>;
  loginAndEnrollAccount: () => Promise<void>;
  deRegisterAndUnenrollAccount: (user: IntuneMAMUser) => Promise<void>;
  appConfig: (user: IntuneMAMUser) => Promise<IntuneMAMAppConfig>;
  groupName: (user: IntuneMAMUser) => Promise<IntuneMAMGroupName>;
  getPolicy: (user: IntuneMAMUser) => Promise<IntuneMAMPolicy>;
  sdkVersion: () => Promise<IntuneMAMVersionInfo>;
  displayDiagnosticConsole: () => Promise<void>;

  // Events
  addListener(
    eventName: 'appConfigChange',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'policyChange',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
}

// const IntuneMAM = registerPlugin<IntuneMAMPlugin>('IntuneMAM');

export default IntuneMAMPlugin;

/*
export interface IntunePlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
*/
