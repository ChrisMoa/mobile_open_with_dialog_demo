import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_bloc.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_event.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_state.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/widgets/calendar_event_card.dart';

class CalendarEventsScreen extends StatelessWidget {
  const CalendarEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Events')),
      body: BlocBuilder<FileOpenerBloc, FileOpenerState>(
        builder: (context, state) {
          if (state is FileOpenerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FileOpenerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FileOpenerBloc>().add(const ResetEvent());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is FileOpenerSuccess) {
            final events = state.events;
            if (events.isEmpty) {
              return const Center(child: Text('No calendar events found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return CalendarEventCard(event: events[index]);
              },
            );
          }

          return const Center(child: Text('No files have been opened yet'));
        },
      ),
    );
  }
}
