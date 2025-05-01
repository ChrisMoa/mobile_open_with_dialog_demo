import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/data/repositories/file_opener_repository.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/domain/models/calendar_event.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_event.dart';
import 'package:mobile_open_with_dialog_demo/features/file_opener/presentation/blocs/file_opener_state.dart';

class FileOpenerBloc extends Bloc<FileOpenerEvent, FileOpenerState> {
  final FileOpenerRepository _repository;

  FileOpenerBloc(this._repository) : super(FileOpenerInitial()) {
    on<FilesOpenedEvent>(_onFilesOpened);
    on<ResetEvent>(_onReset);
  }

  Future<void> _onFilesOpened(FilesOpenedEvent event, Emitter<FileOpenerState> emit) async {
    try {
      emit(FileOpenerLoading());
      final events = await _repository.processOpenedFiles(event.files);
      emit(FileOpenerSuccess(events));
    } catch (e) {
      emit(FileOpenerError(e.toString()));
    }
  }

  void _onReset(ResetEvent event, Emitter<FileOpenerState> emit) {
    emit(FileOpenerInitial());
  }
}
