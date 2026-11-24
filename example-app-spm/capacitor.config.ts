import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.outsystems.intunedemo',
  appName: 'example-app',
  webDir: 'dist',
  experimental: {
    ios: {
      spm: {
        // The Intune SDK needs iOS 18, and `.iOS(.v18)` needs Swift tools 6.0.
        swiftToolsVersion: '6.0',
      },
    },
  },
};

export default config;
