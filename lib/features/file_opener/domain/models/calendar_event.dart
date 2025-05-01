import 'package:intl/intl.dart';

class CalendarEvent {
  final String summary;
  final DateTime start;
  final DateTime end;
  final String? description;
  final String? location;

  CalendarEvent({required this.summary, required this.start, required this.end, this.description, this.location});

  String get formattedStart => DateFormat('MMM d, y HH:mm').format(start);
  String get formattedEnd => DateFormat('MMM d, y HH:mm').format(end);
}
