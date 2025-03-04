import { IonButton, IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import { useCallback, useEffect, useState } from 'react';
import './Home.css';

import { IntuneMAM } from '@ionic-enterprise/intune';
import { useHistory } from 'react-router';

const Login: React.FC = () => {
  const history = useHistory();

  const [version, setVersion] = useState<string | null>(null);

  useEffect(() => {
    async function getVersion() {
      setVersion((await IntuneMAM.sdkVersion()).version);
    }
    getVersion();
  });

  const login = useCallback(async () => {
    const authInfo = await IntuneMAM.acquireToken({
      scopes: ['https://graph.microsoft.com/.default'],
    });

    console.log('Got auth info', authInfo);

    await IntuneMAM.registerAndEnrollAccount({
      accountId: authInfo.accountId,
    });

    const user = await IntuneMAM.enrolledAccount();
    console.log('user', user);
    if (user.accountId) {
      console.log('Got user, going home');
      history.replace("/home");
    } else {
      console.log("No user, logging in");
      history.replace("/login");
    }
  }, []);

  const showConsole = useCallback(async () => {
    await IntuneMAM.displayDiagnosticConsole();
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Login</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Login</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonButton onClick={login}>Log in</IonButton>
        <IonButton onClick={showConsole}>Show Console</IonButton>
        {version && <p>SDK Version: {version}</p>}
      </IonContent>
    </IonPage>
  );
};

export default Login;
