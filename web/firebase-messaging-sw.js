importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

const firebaseConfig = {
      apiKey: "AIzaSyAkIvYpZS9hdLWgImL9oJexB8ehix4cErk",
      authDomain: "jungle-padel-327a6.firebaseapp.com",
      projectId: "jungle-padel-327a6",
      storageBucket: "jungle-padel-327a6.appspot.com",
      messagingSenderId: "1017484623328",
      appId: "1:1017484623328:web:a6a2d71f35e3cb5edbff85",
      measurementId: "G-Y2QB08YL7V"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
      };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});