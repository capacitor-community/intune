import { registerPlugin } from '@capacitor/core';

import type { IntuneMAM } from './definitions';

const Intune = registerPlugin<IntuneMAM>('Intune', {});

export * from './definitions';
export { Intune };
