const ionic = require('@ionic/eslint-config/recommended');

module.exports = [
  {
    ignores: [
      '**/build/**',
      '**/dist/**',
      '**/example-app/**',
      '**/example-app-spm/**',
      '**/website/**',
      // the old lint script passed --ext ts, which flat config ignores
      '**/*.js',
      '**/*.mjs',
      '**/*.cjs',
    ],
  },
  ...ionic,
];
