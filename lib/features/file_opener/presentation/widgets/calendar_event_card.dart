import 'package:flutter/material.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/domain/models/calendar_event.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;

  const CalendarEventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.summary, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.access_time, size: 16), const SizedBox(width: 8), Text('${event.formattedStart} - ${event.formattedEnd}', style: Theme.of(context).textTheme.bodyMedium)]),
            if (event.location != null) ...[
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 8), Expanded(child: Text(event.location!, style: Theme.of(context).textTheme.bodyMedium))]),
            ],
            if (event.description != null) ...[const SizedBox(height: 8), Text(event.description!, style: Theme.of(context).textTheme.bodyMedium)],
          ],
        ),
      ),
    );
  }
}
