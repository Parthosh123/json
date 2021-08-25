import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalAuthApi {
  //step:2 create a static variable which caries LocalAuthentication() library class.
  static final auth = LocalAuthentication();
  //step:6 create future bool to verify whether you mobile has biometrics or not
  static Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

//step:3 create a future with bool which returns authenticateWithBiometrics
  static Future<bool> authenticate() async {
    //step:5 create a isAvailable variable call the hasBiometrics.
    final isAvailable = await hasBiometrics();
    //conditional class to verify.
    if (!isAvailable) return false;
    //step:4 create try to find error
    try {
      return await auth.authenticate(
        biometricOnly: true, //if it is false it doesn't work
        localizedReason:
            "scan fingerprint to authenticate", //provides reason while scanning.
        useErrorDialogs:
            true, //if the mobile doesn't have biometrics it pop-up.
        stickyAuth:
            true, //it keeps you in scanning dialog, when you around to the background
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload:' + payload);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage1(),
    );
  }
}

var data;

bool data1 = false;
bool tubeLight = false;
var rating ;
double fan=0.0;
var roundRat;

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List val = [];
//   Future<dynamic> getData() async {
//     http.Response response = await http.get(Uri.parse('http://o.j:8000'));
//     Map data = json.decode(response.body);
//
//     // print(data.length);
//
//     setState(() {
//       data.forEach((key, value) {
//         val.add(key);
//         // print(val);
//       });
//       data1 = data['Nfc1'];
//       tubeLight = data['Tube_Light_Button_Admin_Room'];
//     });
//
//
//
//    //  for (int i = 0; i == data.length;i++) {
//    //     //print(val[5]);
//    //    //print(data.length);
//    //    if(val[i].toString().contains("_Button_"))
//    //      {
//    //         print(val[i]);
//    //
//    //      }
//    //    i++;
//    // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("getting data");
//     getData();
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 1.0,
//             width: MediaQuery.of(context).size.width * 1.0,
//             child: Image(
//               image: AssetImage('images/back.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 200.0,
//                       width: 120.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white70.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           data1
//                               ? Icon(
//                                   Icons.lightbulb,
//                                   size: 60.0,
//                                   color: Colors.yellowAccent,
//                                 )
//                               : Icon(
//                                   Icons.lightbulb_outline,
//                                   size: 60.0,
//                                   color: Colors.white70,
//                                 ),
//                           Text(
//                             "NFC1",
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                           Transform.scale(
//                             scale: 1.5,
//                             child: Switch(
//                               value: data1,
//                               onChanged: (value) async {
//                                 data1
//                                     ? await http.get(
//                                         Uri.parse('http://o.j:8000/Nfc1/0/'))
//                                     : await http.get(
//                                         Uri.parse('http://o.j:8000/Nfc1/1/'));
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Container(
//                       height: 200.0,
//                       width: 120.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white70.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           tubeLight
//                               ? Icon(
//                                   Icons.lightbulb,
//                                   size: 60.0,
//                                   color: Colors.yellowAccent,
//                                 )
//                               : Icon(
//                                   Icons.lightbulb_outline,
//                                   size: 60.0,
//                                   color: Colors.white70,
//                                 ),
//                           Text(
//                             "TubeLight",
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                           Transform.scale(
//                             scale: 1.5,
//                             child: Switch(
//                               value: tubeLight,
//                               onChanged: (value) async {
//                                 tubeLight
//                                     ? await http.get(Uri.parse(
//                                         'http://o.j:8000/Tube_Light_Button_Admin_Room/0/'))
//                                     : await http.get(Uri.parse(
//                                         'http://o.j:8000/Tube_Light_Button_Admin_Room/1/'));
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  List val = [];

  Future<dynamic> getData() async {
    http.Response response =
        await http.get(Uri.parse('http://192.168.1.18:8000/'));
    Map data = json.decode(response.body);
    // print(data.length);
    setState(() {
      // data.forEach((key, value) {
      //   val.add(key);
      //   // print(val);
      // });
       int fan1 = data['Fan_Slide_Admin_Room'];
       fan = fan1.roundToDouble();
      data1 = data['Nfc1'];
      tubeLight = data['Tube_Light_Button_Admin_Room'];
    });
    //  for (int i = 0; i == data.length;i++) {
    //     //print(val[5]);
    //    //print(data.length);
    //    if(val[i].toString().contains("_Button_"))
    //      {
    //         print(val[i]);
    //
    //      }
    //    i++;
    // }
  }

  @override
  void initState() {
    getData();
    super.initState();
    LocalAuthApi.authenticate();
  }
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1.0,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Image(
              image: AssetImage('images/back.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      height: 200.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.white70.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          data1
                              ? Icon(
                                  Icons.lightbulb,
                                  size: 60.0,
                                  color: Colors.yellowAccent,
                                )
                              : Icon(
                                  Icons.lightbulb_outline,
                                  size: 60.0,
                                  color: Colors.white70,
                                ),
                          Text(
                            "NFC1",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: data1,
                              onChanged: (value) async {
                                data1
                                    ? await http.get(Uri.parse(
                                        'http://192.168.1.18:8000/Nfc1/0/'))
                                    : await http.get(Uri.parse(
                                        'http://192.168.1.18:8000/Nfc1/1/'));
                                setState(() {
                                  if (data1 == false) {
                                    scheduleNotification();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 200.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.white70.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          tubeLight
                              ? Icon(
                                  Icons.lightbulb,
                                  size: 60.0,
                                  color: Colors.yellowAccent,
                                )
                              : Icon(
                                  Icons.lightbulb_outline,
                                  size: 60.0,
                                  color: Colors.white70,
                                ),
                          Text(
                            "TubeLight",
                            style: TextStyle(color: Colors.white),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                                value: tubeLight,
                                onChanged: (value) async {
                                  tubeLight
                                      ? await http.get(Uri.parse(
                                          'http://192.168.1.18:8000/Tube_Light_Button_Admin_Room/0/'))
                                      : await http.get(Uri.parse(
                                          'http://192.168.1.18:8000/Tube_Light_Button_Admin_Room/1/'));
                                  setState(() {
                                    if (tubeLight == false) {
                                      scheduleNotification1();
                                    }
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text(fan.toString(),style: TextStyle(color: Colors.white),),
              Slider(
                value: fan,
                onChanged: (newValue)async {
                  setState(() {

                  });
                  fan = newValue;
                  rating = await http.get(Uri.parse(
                      'http://192.168.1.18:8000/Fan_Slide_Admin_Room/${fan.round()}/'));
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white70,
                min: 0,
                max: 4,
                divisions: 5,
                label: fan.round().toString(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: FlatButton(
                      color: Colors.white70.withOpacity(0.50),
                      child: Text(
                        "Press",
                        style: TextStyle(color: Colors.white70),
                      ),
                      onPressed: () {
                        scheduleNotification2();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(milliseconds: 100));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'popup',
      'popup',
      'small popups',
      icon: 'launch_background',
      sound: RawResourceAndroidNotificationSound('iphone_notification'),
      largeIcon: DrawableResourceAndroidBitmap('launch_background'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'home',
        'NFc1 Is On',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  Future<void> scheduleNotification1() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(milliseconds: 100));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'popup',
      'popup',
      'small popups',
      icon: 'launch_background',
      sound: RawResourceAndroidNotificationSound('iphone_notification'),
      largeIcon: DrawableResourceAndroidBitmap('launch_background'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'home',
        'TubeLight Is On',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  Future<void> scheduleNotification2() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(milliseconds: 1));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'popup',
      'popup',
      'small popups',
      icon: 'launch_background',
      sound: RawResourceAndroidNotificationSound('iphone_notification'),
      largeIcon: DrawableResourceAndroidBitmap('launch_background'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'home',
        'Button is Pressed',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}
