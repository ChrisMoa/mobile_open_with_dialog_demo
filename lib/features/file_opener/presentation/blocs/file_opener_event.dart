import 'package:flutter_sharing_intent/model/sharing_file.dart';

abstract class FileOpenerEvent {
  const FileOpenerEvent();
}

class FilesOpenedEvent extends FileOpenerEvent {
  final List<SharedFile> files;

  const FilesOpenedEvent(this.files);
}

class ResetEvent extends FileOpenerEvent {
  const ResetEvent();
}
