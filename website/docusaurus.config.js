module.exports = {
  title: 'Intune (Preview)',
  tagline: 'Support for Microsoft Intune MAM/MDM with Azure AD auth',
  url: 'https://ionic.io',
  baseUrl: '/docs/intune/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/intune-icon.svg',
  organizationName: 'ionic-team',
  projectName: 'enterprise-intune',
  titleDelimiter: '-',
  themeConfig: {
    navbar: {
      logo: {
        alt: 'Ionic Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docsVersionDropdown',
        },
        {
          label: 'Platform',
          position: 'right',
          items: [
            {
              href: 'https://capacitorjs.com/docs',
              label: 'Capacitor',
              target: '_blank',
              rel: null,
              className: 'link--outbound',
            },
            {
              href: 'https://ionicframework.com/docs',
              label: 'Framework',
              target: '_blank',
              rel: null,
              className: 'link--outbound',
            },
            {
              href: 'https://ionic.io/docs/appflow',
              label: 'Appflow',
              target: null,
              rel: null,
            },
            {
              to: '/',
              label: 'Identity Vault',
            },
            {
              href: 'https://ionic.io/docs/auth-connect',
              label: 'Auth Connect',
              target: null,
              rel: null,
            },
            {
              href: 'https://ionic.io/docs/secure-storage',
              label: 'Secure Storage',
              target: null,
              rel: null,
            },
            {
              href: 'https://ionic.io/docs/premier-plugins',
              label: 'Premier Plugins',
              target: null,
              rel: null,
            },
          ],
        },
      ],
    },
    colorMode: {
      respectPrefersColorScheme: true,
    },
    tagManager: {
      trackingID: 'GTM-TKMGCBC',
    },
  },
  plugins: ['@ionic-internal/docusaurus-plugin-tag-manager'],
  themes: ['@ionic-internal/docusaurus-theme'],
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        theme: {
          customCss: ['prismjs/themes/prism-tomorrow.css'],
        },
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          lastVersion: 'current',
          versions: {
            current: {
              label: '1.0',
              
            },
          },
        },
        blog: false,
        pages: false,
      },
    ],
  ],
};
