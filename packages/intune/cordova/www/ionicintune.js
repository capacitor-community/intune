var exec = require('cordova/exec');

var PLUGIN_NAME = 'IntuneMAM';

const methods = [
  'acquireToken',
  'acquireTokenSilent',
  'registerAndEnrollAccount',
  'loginAndEnrollAccount',
  'enrolledAccount',
  'deRegisterAndUnenrollAccount',
  'appConfig',
  'groupName',
  'getPolicy',
  'sdkVersion',
  'displayDiagnosticConsole',
];

module.exports = methods.reduce((e, m) => {
  e[m] = args =>
    new Promise((resolve, reject) =>
      exec(resolve, reject, PLUGIN_NAME, m, args ? [args] : []),
    );
  return e;
}, {});
