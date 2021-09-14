import { registerPlugin } from '@capacitor/core';

import type { IntunePlugin } from './definitions';

const Intune = registerPlugin<IntunePlugin>('Intune', {});

export * from './definitions';
export { Intune };
