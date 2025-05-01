import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/domain/models/calendar_event.dart';

class FileOpenerRepository {
  static const _methodChannel = MethodChannel('com.example.mobile_open_with_dialog_demo/file_handler');

  Future<List<CalendarEvent>> processOpenedFiles(List<SharedFile> sharedFiles) async {
    try {
      final List<CalendarEvent> events = [];

      for (var sharedFile in sharedFiles) {
        final String? fileValue = sharedFile.value;
        if (fileValue == null) {
          print('Warning: File value is null, skipping...');
          continue;
        }

        print('Processing file: $fileValue with type: ${sharedFile.type}');

        try {
          String content;
          if (fileValue.startsWith('content://')) {
            print('Reading content URI: $fileValue');
            try {
              content = await _methodChannel.invokeMethod('readContentUri', {'uri': fileValue});
              print('Successfully read content from URI');
            } catch (e) {
              print('Error reading content URI: $e');
              rethrow;
            }
          } else {
            print('Reading file path: $fileValue');
            content = await File(fileValue).readAsString();
          }

          print('Parsing ICS content...');
          final ICalendar calendar = ICalendar.fromString(content);
          print('Successfully parsed ICS content');

          print('Converting events...');
          for (var event in calendar.data) {
            final type = event['type'] as String?;
            print('Processing component of type: $type');

            if (type == 'VEVENT') {
              final summary = event['summary'] as String?;
              print('Processing event: $summary');

              // Parse dates with fallback to current time
              DateTime start;
              DateTime end;
              try {
                final startIcs = event['dtstart'] as IcsDateTime?;
                final endIcs = event['dtend'] as IcsDateTime?;

                start = startIcs?.toDateTime() ?? DateTime.now();
                end = endIcs?.toDateTime() ?? start.add(const Duration(hours: 1));

                print('Parsed dates - Start: $start, End: $end');
              } catch (e) {
                print('Error parsing dates: $e');
                start = DateTime.now();
                end = start.add(const Duration(hours: 1));
              }

              events.add(CalendarEvent(summary: summary ?? 'Untitled Event', start: start, end: end, description: event['description'] as String?, location: event['location'] as String?));
            }
          }
          print('Successfully processed ${events.length} events from file');
        } catch (e, stackTrace) {
          print('Error parsing ICS file: $e');
          print('Stack trace: $stackTrace');
          // Continue with other files if one fails
          continue;
        }
      }

      if (events.isEmpty && sharedFiles.isNotEmpty) {
        throw Exception("No valid calendar events could be extracted from the shared files.");
      }

      return events;
    } catch (e, stackTrace) {
      print('Error processing shared files: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
