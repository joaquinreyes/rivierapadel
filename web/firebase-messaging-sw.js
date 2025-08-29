importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: "AIzaSyD-PmQOZM8YFV61R8eWzGg3vNGWrIV82Ew",
  authDomain: "frontendbooakdngo3.firebaseapp.com",
  projectId: "frontendbooakdngo3",
  storageBucket: "frontendbooakdngo3.firebasestorage.app",
  messagingSenderId: "808637490319",
  appId: "1:808637490319:web:82aa4c2cc2252bf27cbcfa"
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