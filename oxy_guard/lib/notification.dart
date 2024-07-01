
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class Noti{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize,
        iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings );
  }

  static Future showBigTextNotification({var id =0,required String title, required String body,
    var payload, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',

      sound: RawResourceAndroidNotificationSound('n'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      //largeIcon: DrawableResourceAndroidBitmap('logo'), 
    );

  DarwinNotificationDetails iOSPlatformChannelSpecifics = new DarwinNotificationDetails(

  );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics,
    );
    await fln.show(0, title, body,not );
  }

}