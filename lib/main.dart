import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyectomov2023/assets/global_values.dart';
import 'package:proyectomov2023/assets/styles_app.dart';
import 'package:proyectomov2023/routes.dart';
import 'package:proyectomov2023/screens/information_screen.dart';
import 'package:proyectomov2023/screens/inicio_screen.dart';
import 'package:proyectomov2023/screens/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.configPrefs();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mymap = {};
  var title = '';
  var body = {};
  var mytoken = '';

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var android = const AndroidInitializationSettings('mipmap/ic_launcher');
    var platform = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(platform);

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print("onMessage called ${(msg.data)}");
      mymap = msg.data;
      showNotification(msg.data);
    });

    firebaseMessaging.getToken().then((token) {
      if (token != null) {
        print("FCM Token: $token");
        update(token);
      } else {
        // Manejar el caso en el que no se puede obtener el token
        print("No se pudo obtener el token de Firebase Messaging");
      }
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = AndroidNotificationDetails(
      "1",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'mipmap/ic_launcher',
    );

    var platform = NotificationDetails(android: android, iOS: null);

    // key and value
    msg.forEach((k, v) {
      title = k;
      body = v;
      setState(() {});
    });

    await flutterLocalNotificationsPlugin.show(
      0,
      "${body.keys}",
      "${body.values}",
      platform,
    );
  }

  //fcm-token firebase cloud messaging
  update(String token) {
    print(token);
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    mytoken = token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GlobalValues.flagTheme.value = GlobalValues.teme.getBool('teme') ?? false;

    return ValueListenableBuilder(
      valueListenable: GlobalValues.flagTheme,
      builder: (context, value, _) {
        // Verificar si la casilla de verificación está activada
        bool isSessionActive = GlobalValues.session.getBool('session') ?? false;

        // Redirigir a la pantalla correspondiente
        Widget initialScreen =
            isSessionActive ? const InicioScreen() : InformationScreen();

        return MaterialApp(
          home: initialScreen,
          routes: getRoutes(),
          theme: value
              ? StylesApp.darkTheme(context)
              : StylesApp.lightTheme(context),
        );
      },
    );
  }
}
