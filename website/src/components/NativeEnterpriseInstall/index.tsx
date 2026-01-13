import React from 'react';
import Link from '@docusaurus/Link';
import CodeBlock from '@theme/CodeBlock';
import Heading from '@theme/Heading';


interface Props {
  pluginId?: string;
  variables?: string;
  capacitorSlug?: string | null;
}

function NativeEnterpriseInstall(props: Props): JSX.Element {
  if (typeof props.pluginId === 'undefined') {
    return null;
  }

  const Heading2 = Heading('h2');

  return (
    <>
      <Heading2 id="installation">Installation</Heading2>
      <p>
        If you have not already setup Ionic Enterprise in your app,{' '}
        <Link
          href="https://ionic.io/docs/premier-plugins/setup"
          target={null}
          rel={null}
        >
          follow the one-time setup steps
        </Link>
        .
      </p>
      <p>Next, install the plugin:</p>
      {typeof props.capacitorSlug !== 'undefined' &&
        props.capacitorSlug !== null ? (
        <div>
          Available as a{' '}
          <Link
            href={`https://capacitorjs.com/docs/apis/${props.capacitorSlug}`}
            target={null}
            rel={null}
          >
            core Capacitor plugin
          </Link>
          .
        </div>
      ) : (
        <CodeBlock className="language-bash">
          npm install @ionic-enterprise/{props.pluginId}
          {'\n'}
          {props.pluginId === 'auth' ?
            ('\nUsing React? Also install: \nnpm install @ionic-enterprise/auth-react\n\n'
            ) : ('')
          }
          npx cap sync
        </CodeBlock>
      )}
    </>
  );
}

export default NativeEnterpriseInstall;
