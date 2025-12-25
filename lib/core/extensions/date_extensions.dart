import 'package:intl/intl.dart';

/// Extensões para DateTime
extension DateTimeExtensions on DateTime {
  /// Formata a data no padrão da API (YYYY-MM-DD)
  String toApiFormat() => DateFormat('yyyy-MM-dd').format(this);

  /// Formata a data para exibição (ex: 16 de Dezembro de 2025)
  String toDisplayFormat() => DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(this);

  /// Formata a data curta (ex: 16/12/2025)
  String toShortFormat() => DateFormat('dd/MM/yyyy').format(this);

  /// Formata a data média (ex: 16 Dez 2025)
  String toMediumFormat() => DateFormat('d MMM yyyy', 'pt_BR').format(this);

  /// Retorna apenas a data (sem hora)
  DateTime get dateOnly => DateTime(year, month, day);

  /// Verifica se é hoje
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Verifica se é ontem
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Retorna "Hoje", "Ontem" ou a data formatada
  String toRelativeFormat() {
    if (isToday) return 'Hoje';
    if (isYesterday) return 'Ontem';
    return toMediumFormat();
  }

  /// Verifica se a data está no intervalo permitido pela API (desde 16/06/1995)
  bool get isValidApodDate {
    final minDate = DateTime(1995, 6, 16);
    final maxDate = DateTime.now();
    return !isBefore(minDate) && !isAfter(maxDate);
  }
}

/// Extensões para String de data
extension DateStringExtensions on String {
  /// Converte string no formato API (YYYY-MM-DD) para DateTime
  DateTime? toDateFromApi() {
    try {
      return DateFormat('yyyy-MM-dd').parse(this);
    } catch (_) {
      return null;
    }
  }
}
