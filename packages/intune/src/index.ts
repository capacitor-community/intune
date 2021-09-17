import { registerPlugin } from '@capacitor/core';

import type { IntuneMAMPlugin } from './definitions';

const IntuneMAM = registerPlugin<IntuneMAMPlugin>('Intune', {});

export * from './definitions';
export { IntuneMAM };
