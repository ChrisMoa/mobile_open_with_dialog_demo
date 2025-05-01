import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/data/repositories/file_opener_repository.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_bloc.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_event.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/screens/calendar_events_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Events Viewer',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: BlocProvider(create: (context) => FileOpenerBloc(FileOpenerRepository()), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FileOpenerBloc _fileOpenerBloc;

  @override
  void initState() {
    super.initState();
    _fileOpenerBloc = context.read<FileOpenerBloc>();
    _initializeFileHandling();
  }

  void _initializeFileHandling() {
    // Handle files shared while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) {
      if (value.isNotEmpty) {
        _fileOpenerBloc.add(FilesOpenedEvent(value));
      }
    });

    // Handle files shared while the app is running
    FlutterSharingIntent.instance.getMediaStream().listen((List<SharedFile> value) {
      if (value.isNotEmpty) {
        _fileOpenerBloc.add(FilesOpenedEvent(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CalendarEventsScreen();
  }
}
