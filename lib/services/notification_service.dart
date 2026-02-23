import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Serviço de notificações do Cosmic Vision
///
/// Gerencia notificações locais diárias com mensagens criativas
/// sobre o APOD (Astronomy Picture of the Day).
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Canal de notificação para Android
  static const String _channelId = 'cosmic_daily';
  static const String _channelName = 'Notificação Diária';
  static const String _channelDescription =
      'Lembrete diário sobre a nova imagem astronômica';

  /// ID da notificação agendada
  static const int _dailyNotificationId = 1;

  /// Mensagens criativas para as notificações
  static const List<String> _morningMessages = [
    '🌅 Bom dia, explorador cósmico! Uma nova maravilha do universo te espera.',
    '☀️ Bom dia! O cosmos tem uma surpresa para você hoje.',
    '🌄 Bom dia! Que tal começar o dia contemplando o infinito?',
    '🌞 Bom dia, viajante estelar! Uma nova imagem astronômica chegou.',
    '✨ Bom dia! O universo preparou algo especial para hoje.',
    '🚀 Bom dia! Prepare-se para uma viagem pelo cosmos.',
    '🌌 Bom dia! O espaço sideral tem novidades incríveis.',
  ];

  static const List<String> _afternoonMessages = [
    '🌤️ Boa tarde! Hora de uma pausa cósmica no seu dia.',
    '☁️ Boa tarde! Que tal explorar as maravilhas do universo?',
    '🌍 Boa tarde! Uma nova imagem espacial te aguarda.',
    '⭐ Boa tarde! O cosmos está chamando você para uma aventura.',
    '🛸 Boa tarde, explorador! Confira a imagem astronômica de hoje.',
    '🌎 Boa tarde! Descubra os segredos do universo.',
    '💫 Boa tarde! Uma dose de infinito para alegrar seu dia.',
  ];

  static const List<String> _eveningMessages = [
    '🌙 Boa noite! Hora perfeita para contemplar as estrelas.',
    '🌃 Boa noite! O universo está mais bonito à noite.',
    '✨ Boa noite, stargazer! Uma nova imagem cósmica chegou.',
    '🌠 Boa noite! Que tal sonhar com as galáxias?',
    '🔭 Boa noite! O céu noturno tem uma mensagem para você.',
    '🌛 Boa noite! Relaxe contemplando a beleza do cosmos.',
    '💫 Boa noite! As estrelas brilham especialmente hoje.',
  ];

  static const List<String> _genericMessages = [
    '🌌 Uma nova imagem astronômica da NASA está disponível!',
    '🚀 Explore o cosmos: nova APOD disponível!',
    '✨ O universo tem uma surpresa para você hoje.',
    '⭐ Descubra a beleza do espaço: confira a APOD de hoje!',
    '🔭 Aventura cósmica: nova imagem astronômica chegou!',
    '💫 Viaje pelo universo sem sair de casa!',
    '🛸 Sua dose diária de cosmos está pronta!',
  ];

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ [NotificationService] Já inicializado');
      return;
    }

    debugPrint('🔔 [NotificationService] Inicializando...');

    try {
      // Inicializa timezone
      tz.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timezoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('⏰ [NotificationService] Timezone: $timeZoneName');

      // Configurações Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configurações iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      // Configurações gerais
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Inicializa o plugin
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Cria canal para Android 8.0+
      await _createAndroidChannel();

      _isInitialized = true;
      debugPrint('✅ [NotificationService] Inicializado com sucesso');
    } catch (e, stack) {
      debugPrint('❌ [NotificationService] Erro na inicialização: $e');
      debugPrint('❌ [NotificationService] Stack: $stack');
    }
  }

  /// Cria o canal de notificação para Android
  Future<void> _createAndroidChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    debugPrint('📢 [NotificationService] Canal Android criado: $_channelId');
  }

  /// Handler quando a notificação é tocada
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 [NotificationService] Notificação tocada: ${response.payload}');
    // O app será aberto automaticamente
    // Pode-se adicionar navegação específica aqui no futuro
  }

  /// Solicita permissão para enviar notificações
  Future<bool> requestPermission() async {
    debugPrint('🔐 [NotificationService] Solicitando permissão...');

    try {
      // Android 13+
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        debugPrint('📱 [NotificationService] Permissão Android: $granted');
        return granted ?? false;
      }

      // iOS
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint('🍎 [NotificationService] Permissão iOS: $granted');
        return granted ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ [NotificationService] Erro ao solicitar permissão: $e');
      return false;
    }
  }

  /// Verifica se tem permissão para notificações
  Future<bool> hasPermission() async {
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        return await androidImplementation.areNotificationsEnabled() ?? false;
      }

      // Para iOS, assumimos que tem permissão se chegou aqui
      return true;
    } catch (e) {
      debugPrint('❌ [NotificationService] Erro ao verificar permissão: $e');
      return false;
    }
  }

  /// Agenda notificação diária
  ///
  /// [hour] - Hora do dia (0-23)
  /// [minute] - Minuto (0-59)
  /// [apodTitle] - Título opcional do APOD para personalizar a mensagem
  Future<void> scheduleDailyNotification({
    required int hour,
    int minute = 0,
    String? apodTitle,
  }) async {
    if (!_isInitialized) {
      debugPrint('⚠️ [NotificationService] Não inicializado');
      return;
    }

    debugPrint('📅 [NotificationService] Agendando para $hour:${minute.toString().padLeft(2, '0')}');

    try {
      // Cancela notificação anterior
      await cancelDailyNotification();

      // Gera mensagem criativa
      final message = _getCreativeMessage(hour, apodTitle);

      // Detalhes Android
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(''),
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      );

      // Detalhes iOS
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Calcula próximo horário
      final scheduledDate = _nextInstanceOfTime(hour, minute);

      // Agenda a notificação
      await _notificationsPlugin.zonedSchedule(
        _dailyNotificationId,
        '🌌 Cosmic Vision',
        message,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_apod',
      );

      debugPrint('✅ [NotificationService] Notificação agendada para: $scheduledDate');
      debugPrint('📝 [NotificationService] Mensagem: $message');
    } catch (e, stack) {
      debugPrint('❌ [NotificationService] Erro ao agendar: $e');
      debugPrint('❌ [NotificationService] Stack: $stack');
    }
  }

  /// Cancela a notificação diária
  Future<void> cancelDailyNotification() async {
    try {
      await _notificationsPlugin.cancel(_dailyNotificationId);
      debugPrint('🚫 [NotificationService] Notificação diária cancelada');
    } catch (e) {
      debugPrint('❌ [NotificationService] Erro ao cancelar: $e');
    }
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('🚫 [NotificationService] Todas notificações canceladas');
    } catch (e) {
      debugPrint('❌ [NotificationService] Erro ao cancelar todas: $e');
    }
  }

  /// Envia notificação de teste imediata
  Future<void> showTestNotification() async {
    if (!_isInitialized) {
      debugPrint('⚠️ [NotificationService] Não inicializado');
      return;
    }

    debugPrint('🧪 [NotificationService] Enviando notificação de teste...');

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final message = _getCreativeMessage(DateTime.now().hour, null);

    await _notificationsPlugin.show(
      0, // ID diferente para teste
      '🌌 Cosmic Vision - Teste',
      message,
      notificationDetails,
      payload: 'test',
    );

    debugPrint('✅ [NotificationService] Notificação de teste enviada');
  }

  /// Calcula o próximo horário para a notificação
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Se já passou o horário hoje, agenda para amanhã
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Gera uma mensagem criativa baseada no horário
  String _getCreativeMessage(int hour, String? apodTitle) {
    final random = Random();
    List<String> messages;

    // Seleciona mensagens baseado no período do dia
    if (hour >= 5 && hour < 12) {
      messages = _morningMessages;
    } else if (hour >= 12 && hour < 18) {
      messages = _afternoonMessages;
    } else if (hour >= 18 && hour < 22) {
      messages = _eveningMessages;
    } else {
      messages = _genericMessages;
    }

    // Mensagem base aleatória
    String message = messages[random.nextInt(messages.length)];

    // Adiciona título do APOD se disponível
    if (apodTitle != null && apodTitle.isNotEmpty) {
      // Trunca título se muito longo
      final truncatedTitle = apodTitle.length > 50
          ? '${apodTitle.substring(0, 47)}...'
          : apodTitle;
      message = '$message\n\n📸 "$truncatedTitle"';
    }

    return message;
  }

  /// Verifica se há notificações pendentes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
