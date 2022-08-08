import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/category_data_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/home.dart';
import 'package:ecommerce_mobile/screens/main.dart';
import 'package:ecommerce_mobile/screens/noconn.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:ecommerce_mobile/screens/user_promotions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  Fluttertoast.showToast(msg: message.toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ios permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // listen for background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // get fcm token
  final fcmToken = await messaging.getToken();

  print("***************************");
  print("FCM TOKEN");
  print(fcmToken);
  print("***************************");

  // FCM Token değiştiğinde
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.

    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }).onError((err) {
    // Error getting token.
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    Fluttertoast.showToast(msg: message.toString());

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //#region Connectivity

  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  //#endregion

  MaterialColor colorCustom = MaterialColor(0xFF015791, color);


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MenuProvider>(
          create: (context) => MenuProvider(),
        ),
        ChangeNotifierProvider<CategoryDataProvider>(
          create: (_) => CategoryDataProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Malzemecim',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          primaryColor: Color.fromARGB(255, 1, 87, 145),
          secondaryHeaderColor: Color.fromARGB(255, 1, 87, 145),
          primarySwatch: colorCustom,
          bottomAppBarColor: colorCustom,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
            button: TextStyle(fontSize: 13.0, fontFamily: 'Poppins'),
          ),
        ),
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home:  (_connectionStatus == ConnectivityResult.none)
          ? NoConnPage()
          : MainPage(),
      ),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(1, 87, 145, .1),
  100: Color.fromRGBO(1, 87, 145, .2),
  200: Color.fromRGBO(1, 87, 145, .3),
  300: Color.fromRGBO(1, 87, 145, .4),
  400: Color.fromRGBO(1, 87, 145, .5),
  500: Color.fromRGBO(1, 87, 145, .6),
  600: Color.fromRGBO(1, 87, 145, .7),
  700: Color.fromRGBO(1, 87, 145, .8),
  800: Color.fromRGBO(1, 87, 145, .9),
  900: Color.fromRGBO(1, 87, 145, 1),
};
