import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_mobile/providers/basket_provider.dart';
import 'package:ecommerce_mobile/providers/category_data_provider.dart';
import 'package:ecommerce_mobile/providers/menu_selection_provider.dart';
import 'package:ecommerce_mobile/screens/home.dart';
import 'package:ecommerce_mobile/screens/main.dart';
import 'package:ecommerce_mobile/screens/XPage.dart';
import 'package:ecommerce_mobile/screens/noconnection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
bool _showOnboarding = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  Fluttertoast.showToast(msg: message.toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  _showOnboarding = _prefs.getBool("onboarding") ?? false;
  await _prefs.setBool("onboarding", true);

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

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MenuSelectionProvider>(create: (context) => MenuSelectionProvider()),
        ChangeNotifierProvider<CategoryDataProvider>(create: (_) => CategoryDataProvider()),
        ChangeNotifierProvider<BasketProvider>(create: (_) => BasketProvider()),
      ],
      child: MaterialApp(
        title: 'Malzemecim',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          primaryColor: Color.fromARGB(255, 1, 87, 145),
          secondaryHeaderColor: Color.fromARGB(255, 1, 87, 145),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
            button: TextStyle(fontSize: 13.0, fontFamily: 'Poppins'),
          ),
        ),
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: (_connectionStatus == ConnectivityResult.none)
            ? NoConnectionPage()
            : Scaffold(body: HomePage()),
      ),
    );
  }
}


//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
// import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'models/homepage_model.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({required this.title});
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   List<CategoryModel> menuCategoryList = [];
//   List<String> subCategories = [];
//
//   Future<List<CategoryModel>> fetchCategories() async {
//     final response = await http.get(Uri.parse('http://qsres.com/api/mobileapp/categories'));
//
//     if (response.statusCode == 200) {
//       //return CategoryModel.fromJson(jsonDecode(response.body));
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((item) => new CategoryModel.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   void setSubCats(index) {
//     this.subCategories.clear();
//     if (this.menuCategoryList.elementAt(index).inverseParentCategory.isNotEmpty) {
//       this.subCategories.addAll(this.menuCategoryList[index].inverseParentCategory.map((e) => e['name']));
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder(
//             future: fetchCategories(),
//             builder: (context, AsyncSnapshot snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               } else {
//                 this.menuCategoryList.clear();
//                 this.menuCategoryList.addAll(snapshot.data);
//                 return Column(
//                   children: [
//                     Container(
//                       height: 60,
//                       color: Colors.red,
//                       child: ListView.builder(
//                           physics: BouncingScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: snapshot.data.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: EdgeInsets.all(10),
//                               child: MaterialButton(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 onPressed: () {
//                                   setSubCats(index);
//                                 },
//                                 child: Text('${snapshot.data[index].name}'),
//                               ),
//                             );
//                           }),
//                     ),
//                     Visibility(
//                       visible: this.subCategories.length > 0,
//                       child: Container(
//                         height: 60,
//                         color: Colors.blueGrey,
//                         child: ListView(
//                           shrinkWrap: true,
//                           physics: BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           children: this
//                               .subCategories
//                               .map(
//                                 (e) => MaterialButton(
//                                     onPressed: () {},
//                                     child: Text(e.toString())),
//                               )
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             }),
//       ),
//     );
//   }
// }
