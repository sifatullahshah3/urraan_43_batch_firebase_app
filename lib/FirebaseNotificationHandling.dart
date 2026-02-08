import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationHandling {
  static void FirebaseOnMessageNotificationHandle(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    // ProviderCountryUserData providerCountryUserData = Provider.of<ProviderCountryUserData>(context);
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        notificationHandler(navigatorKey, 2, message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationHandler(navigatorKey, 2, message);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging 5.onMessage.listen");
      if (message.notification != null) {
        notificationHandler(navigatorKey, 1, message);
      }
    });
  }

  // Inside your FirebaseNotificationHandling class
  static void getFCMToken() async {
    try {
      // Retrieve the unique device token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        // Use your custom log utility to print the token
        GeneralPrintLog("FCM_TOKEN_LOG", "Device Token: $token");

        // Step 2: Send this token to your Firestore database or API
        // updateTokenInDatabase(token);
      }
    } catch (e) {
      GeneralPrintLog("FCM_TOKEN_ERROR", e.toString());
    }
  }

  static void notificationHandler(
    GlobalKey<NavigatorState> navigatorKey,
    int count,
    RemoteMessage? remote_message,
  ) async {
    String response1 = remote_message!.toMap().toString();

    remote_message.data["noti_type"].toString()

    String noti_type = remote_message!.toMap()["data"]["noti_type"].toString();

    await Future.delayed(Duration(seconds: count), () {
      if (remote_message.toMap().containsKey("data")) {
        if (noti_type == NotificationStatus.PROMO_ADDED_NOTIFICATION ||
            noti_type == NotificationStatus.GENERAL_NOTIFICATION) {
          String noti_title = remote_message!
              .toMap()["data"]["noti_title"]
              .toString();
          String noti_body = remote_message!
              .toMap()["data"]["noti_body"]
              .toString();
          String image_url = remote_message!
              .toMap()["data"]["image_url"]
              .toString();

          var ssss = DataNotification()
            ..key = GeneralBox.getNewKey()
            ..notify_type = noti_type
            ..title = noti_title
            ..image_url = image_url
            ..description = noti_body
            ..date_time = DateTime.now();

          // GeneralBox.saveDataNotification(ssss);

          showDialog(
            context: navigatorKey.currentState!.context,
            builder: (_) {
              return DialogPromoCode(
                title: noti_title,
                body: noti_body,
                type: noti_type,
                image_url: image_url,
              );
            },
            barrierDismissible: true,
          );
        }
      }
    });
  }

  //initial permission handling methods

  static void registerNotificationPermission() async {
    // firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
  }
}
