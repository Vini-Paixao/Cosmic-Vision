import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static const channelId = 'daily_notification';
  static const channelName = 'Notificações Diárias';
  static const channelDescription = 'Receba notificações diárias';

  static Future<void> scheduleDailyNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Inicializar o plugin de notificações locais
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId, channelName,
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            playSound: true,
            enableVibration: true,
            channelDescription: channelDescription);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();
    final location =
        tz.getLocation('America/Sao_Paulo'); // Defina a localização desejada

    // Defina os horários desejados
    final morningTime = const TimeOfDay(hour: 10, minute: 0);
    final eveningTime = const TimeOfDay(hour: 20, minute: 0);

    // Agendar as notificações diárias
    await _scheduleNotificationAtTime(
        flutterLocalNotificationsPlugin,
        location,
        platformChannelSpecifics,
        morningTime,
        1,
        'Bom Dia! Já visualizou a imagem do dia hoje?');
    await _scheduleNotificationAtTime(
        flutterLocalNotificationsPlugin,
        location,
        platformChannelSpecifics,
        eveningTime,
        2,
        'Boa Noite! Não perca a imagem de hoje!');
  }

  static Future<void> _scheduleNotificationAtTime(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      tz.Location location,
      NotificationDetails platformChannelSpecifics,
      TimeOfDay notificationTime,
      int notificationId,
      String title) async {
    final now = tz.TZDateTime.now(location);
    final tomorrow = tz.TZDateTime(location, now.year, now.month, now.day + 1);

    final nextNotificationDateTime = tz.TZDateTime(
      location,
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    // Agendar a notificação diária
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      '😉',
      nextNotificationDateTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_notification',
    );
  }
}
