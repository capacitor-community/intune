import type { PluginListenerHandle } from '@capacitor/core';

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
  accountId: string;

  /**
   * Whether to force the tokens to be refresh regardless of whether the cached token is expired or not.
   *
   * Default: false
   */
  forceRefresh?: boolean;
}

export interface IntuneMAMAcquireToken {
  accountId: string;
  accessToken: string;
  accountIdentifier: string;
  idToken?: string;
}

export interface IntuneMAMRegisterAndEnrollAccountOptions {
  accountId: string;
}

export interface IntuneMAMUser {
  accountId: string;
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

export interface IntuneMAMRegisterAndEnrollAccountResult {
	enrolled: boolean;
	accountId: string;
	resultCode?: IntuneMAMRegisterAndEnrollAccountResultCode;
	resultName?: keyof typeof IntuneMAMRegisterAndEnrollAccountResultCode;
	message?: string;
}

export enum IntuneMAMRegisterAndEnrollAccountResultCode {
	ENROLLMENT_SUCCEEDED = 0,
	ENROLLMENT_FAILED = 1,
	WRONG_USER = 2,
	MDM_ENROLLED = 3,
	PENDING = 4,
	NOT_LICENSED = 5,
	UNENROLLMENT_SUCCEEDED = 6,
	UNENROLLMENT_FAILED = 7,
	AUTHORIZATION_NEEDED = 8,
	COMPANY_PORTAL_REQUIRED = 9
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
  ) => Promise<IntuneMAMRegisterAndEnrollAccountResult>;
  loginAndEnrollAccount: () => Promise<void>;
  deRegisterAndUnenrollAccount: (user: IntuneMAMUser) => Promise<void>;
  appConfig: (user: IntuneMAMUser) => Promise<IntuneMAMAppConfig>;
  groupName: (user: IntuneMAMUser) => Promise<IntuneMAMGroupName>;
  getPolicy: (user: IntuneMAMUser) => Promise<IntuneMAMPolicy>;
  sdkVersion: () => Promise<IntuneMAMVersionInfo>;
  displayDiagnosticConsole: () => Promise<void>;
  logoutOfAccount: (user: IntuneMAMUser) => Promise<void>;

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
