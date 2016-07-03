const firebase = require('firebase');

firebase.initializeApp({
  serviceAccount: __dirname + "/../spajam2016-kirinsan-org-3ceca6c34b02.json",
  databaseURL: "https://spajam2016-kirinsan-org.firebaseio.com/"
});

let db = firebase.database();
db.ref('device/cc9lAjPpOUE/recordedData').on('value', (snapshot) => {
  let data = snapshot.val();
  // db.ref('command/test5/audioData').push(data);
  // db.ref('command/test5/name').set('ミンティア');
  console.log('copied');

});
