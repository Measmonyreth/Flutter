import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'awesome_notifications_helper.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

class FcmHelper {
  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // Firebase Analytics
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.logAppOpen();
      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // notification settings handler
      await _setupFcmNotificationSettings();

      // send message for multiple devices
      await Future.delayed(Duration(seconds: 1));
      await FirebaseMessaging.instance.subscribeToTopic('all');

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    } catch (error) {
      // if you are connected to firebase and still get error
      // or stop fcm service from main.dart class
      Logger().e(error);
    }
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      print("token : $token");

      if (token != null) {
        // StorageService.setFcmToken(token);
        sendFcmTokenToServer();
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  /// this method will be triggered when the index generate fcm
  /// token successfully
  static Future<String?> sendFcmTokenToServer() async {
    // // check is authenticated then send token to firestore
    var token = await messaging.getToken();
    print("token : $token");
    return null;
    // if (FirebaseAuth.instance.currentUser != null) {
    //   // get token from firebase
    //   var token = await messaging.getToken();
    //   print("token : $token");
    //
    //   return token;
    // } else {
    //   return null;
    // }
  }

  ///handle fcm notification when index is closed/terminated
  /// if you are wondering about this annotation read the following
  /// https://stackoverflow.com/a/67083337
  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    if (message.data.isEmpty || message.data['title'] == null) return;

    final large_image = message.data['large_image'];
    final big_image = message.data['big_image'];

    if (GetPlatform.isAndroid) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.data['title'] ?? 'Title',
        body: message.data['body'] ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: large_image != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        largeIcon: large_image,
        bigPicture: big_image,
      );
    }
    //   if platform is ios
    // if (GetPlatform.isIOS) {
    //   AwesomeNotificationsHelper.showNotification(
    //     id: 1,
    //     title: message.notification?.title ?? 'Tittle',
    //     body: message.notification?.body ?? 'Body',
    //     payload: message.data
    //         .cast(), // pass payload to the notification card so you can use it (when user click on notification)
    //     notificationLayout: NotificationLayout.Default,
    //   );
    // }
  }

  //handle fcm notification when index is open
  // static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
  //   print("foreground message : ${message.data}");

  //   // ✅ Fixed condition
  //   if (message.data.isEmpty || message.data['title'] == null) return;

  //   final image = message.data['image'];

  //   if (GetPlatform.isAndroid) {
  //     AwesomeNotificationsHelper.showNotification(
  //       id: 1,
  //       title: message.data['title'] ?? 'Title',
  //       body: message.data['body'] ?? 'Body',
  //       payload: message.data.cast(),
  //       actionButtons: [],
  //       notificationLayout: image != null
  //           ? NotificationLayout.BigPicture
  //           : NotificationLayout.Default,
  //       largeIcon: image,
  //       bigPicture: image,
  //     );
  //   }

  //   // navigate to notification screen
  //   // Get.toNamed(NotificationScreen.route);
  // }
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    print("🔥 FOREGROUND HANDLER CALLED");
    print("🔥 data: ${message.data}");

    if (message.data.isEmpty || message.data['title'] == null) {
      print("🔥 RETURNING EARLY - data empty or no title");
      return;
    }

    final large_image = message.data['large_image'];
    final big_image = message.data['big_image'];
    print("🔥 large_image: $large_image");
    print("🔥 big_image: $big_image");

    if (GetPlatform.isAndroid) {
      print("🔥 CALLING SHOW NOTIFICATION");
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.data['title'] ?? 'Title',
        body: message.data['body'] ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: large_image != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        largeIcon: large_image,
        bigPicture: big_image,
      );
    } else {
      print("🔥 NOT ANDROID - platform: ${GetPlatform.isIOS}");
    }
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    // print("onMessageOpenApp message : ${message.data}");
    if (message.data.isEmpty || message.data['title'] == null) return;

    final large_image = message.data['large_image'];
    final big_image = message.data['big_image'];

    if (GetPlatform.isAndroid) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.data['title'] ?? 'Title',
        body: message.data['body'] ?? 'Body',
        payload: message.data.cast(),
        notificationLayout: large_image != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        largeIcon: large_image,
        bigPicture: big_image,
      );
    }
  }

  // static Future<void> sendNotification({
  //   required String deviceToken,
  //   required Map<String, dynamic> room,
  //   required String message,
  //   required bool isTextSend,
  // }) async {
  //   try {
  //     print("deviceToken : $deviceToken");
  //     // print("room : $room");
  //     // print("userMessage : $message");
  //     // print("userName : ${FirebaseAuth.instance.currentUser!.displayName}");
  //     const url =
  //         "https://us-central1-sala-it.cloudfunctions.net/app/send-notification";
  //     // const url = "http://localhost:3000/send-notification";
  //     final data = {
  //       "deviceToken": deviceToken,
  //       "room": room,
  //       // "userName": FirebaseAuth.instance.currentUser!.displayName,
  //       "userMessage": message,
  //       "messageType": isTextSend ? "text" : "image",
  //     };
  //     final jsonBody = jsonEncode(data);
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: jsonBody,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     print("response : ${response.body}");
  //     if (response.statusCode == 200) {
  //       print("Notification sent");
  //     } else {
  //       print("Notification not sent");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //     // kQuickAlertErrorReusable(text: e.toString());
  //   }
  // }

  // Replace the old sendNotification() with this:
  static showNotification({
    required String title,
    required String body,
    required int id,
    String? channelKey,
    String? groupKey,
    NotificationLayout? notificationLayout,
    String? summary,
    List<NotificationActionButton>? actionButtons,
    Map<String, String>? payload,
    String? largeIcon,
    String? bigPicture,
  }) async {
    print("🔔 showNotification CALLED");
    print("🔔 title: $title");
    print("🔔 bigPicture: $bigPicture");
    print("🔔 layout: $notificationLayout");

    AwesomeNotificationsHelper.awesomeNotifications
        .isNotificationAllowed()
        .then((isAllowed) {
          print("🔔 isAllowed: $isAllowed");
          if (!isAllowed) {
            print("🔔 NOT ALLOWED - requesting permission");
            AwesomeNotificationsHelper.awesomeNotifications
                .requestPermissionToSendNotifications();
          } else {
            print("🔔 CREATING NOTIFICATION NOW");
            AwesomeNotificationsHelper.awesomeNotifications.createNotification(
              content: NotificationContent(
                id: id,
                title: title,
                body: body,
                groupKey: groupKey ?? NotificationChannels.generalGroupKey,
                channelKey:
                    channelKey ?? NotificationChannels.generalChannelKey,
                showWhen: true,
                payload: payload,
                notificationLayout:
                    notificationLayout ?? NotificationLayout.Default,
                autoDismissible: true,
                summary: summary,
                largeIcon: largeIcon,
                bigPicture: bigPicture,
              ),
              actionButtons: actionButtons,
            );
            print("🔔 NOTIFICATION CREATED");
          }
        });
  }
}
