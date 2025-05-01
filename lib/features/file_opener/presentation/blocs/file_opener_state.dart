import 'package:mobile_open_with_dialog_demo/features/file_opener/domain/models/calendar_event.dart';

abstract class FileOpenerState {}

class FileOpenerInitial extends FileOpenerState {}

class FileOpenerLoading extends FileOpenerState {}

class FileOpenerSuccess extends FileOpenerState {
  final List<CalendarEvent> events;

  FileOpenerSuccess(this.events);
}

class FileOpenerError extends FileOpenerState {
  final String message;

  FileOpenerError(this.message);
}
