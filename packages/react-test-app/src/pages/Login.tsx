import { IonButton, IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import { useCallback } from 'react';
import './Home.css';

import IntuneMAM from '../IntuneMAM';
import { useHistory } from 'react-router';

const Login: React.FC = () => {
  const history = useHistory();

  const login = useCallback(async () => {
    await IntuneMAM.loginAndEnrollAccount();
    const user = await IntuneMAM.enrolledAccount();

    if (user.upn) {
      console.log('Got user, going home');
      setTimeout(() => history.replace('/home'), 500);
    } else {
      console.log('No user, logging in');
      setTimeout(() => history.replace('/login'), 500);
    }
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
      </IonContent>
    </IonPage>
  );
};

export default Login;
