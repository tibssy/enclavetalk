import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:enclavetalk/models/ai_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadService with ChangeNotifier {
  final Map<String, TaskStatus> _taskStatus = {};
  final Map<String, double> _taskProgress = {};

  static const String _hfTokenKey = 'hf_token';
  String? _huggingFaceToken;

  TaskStatus getStatus(String taskId) =>
      _taskStatus[taskId] ?? TaskStatus.notFound;
  double getProgress(String taskId) => _taskProgress[taskId] ?? 0.0;

  Future<void> initialize() async {
    await FileDownloader().configureNotification(
      running: const TaskNotification(
        'Downloading {filename}',
        'Progress: {progress}',
      ),
      complete: const TaskNotification('Download complete', '{filename}'),
      error: const TaskNotification('Download failed', 'Error: {error}'),
      progressBar: true,
    );

    final prefs = await SharedPreferences.getInstance();
    _huggingFaceToken = prefs.getString(_hfTokenKey);

    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate():
          _taskStatus[update.task.taskId] = update.status;
          if (update.status == TaskStatus.complete) {
            _taskProgress.remove(update.task.taskId);
          }
          debugPrint(
            'Task ${update.task.taskId} status is now ${update.status}',
          );
          break;

        case TaskProgressUpdate():
          _taskStatus[update.task.taskId] = TaskStatus.running;
          _taskProgress[update.task.taskId] = update.progress;
          break;

        default:
          break;
      }
      notifyListeners();
    });

    await _loadExistingTaskStates();
  }

  bool get hasToken =>
      _huggingFaceToken != null && _huggingFaceToken!.isNotEmpty;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hfTokenKey, token);
    _huggingFaceToken = token;
    notifyListeners();
  }

  Future<void> _loadExistingTaskStates() async {
    final records = await FileDownloader().database.allRecords();
    for (var record in records) {
      _taskStatus[record.taskId] = record.status;
      _taskProgress[record.taskId] = record.progress;
    }
    notifyListeners();
  }

  Future<void> startDownload(AIModel model) async {
    Map<String, String> headers = {};

    if (model.requiresAuth) {
      if (!hasToken) {
        debugPrint('ERROR: Hugging Face token missing for ${model.name}');
        return;
      }
      headers = {'Authorization': 'Bearer $_huggingFaceToken'};
    }

    final task = DownloadTask(
      url: model.url,
      taskId: model.id,
      filename: model.filename,
      directory: 'models',
      baseDirectory: BaseDirectory.applicationSupport,
      updates: Updates.statusAndProgress,
      headers: headers,
    );

    await FileDownloader().enqueue(task);
  }

  Future<void> deleteModel(AIModel model) async {
    final task = DownloadTask(
      url: model.url,
      taskId: model.id,
      filename: model.filename,
      directory: 'models',
      baseDirectory: BaseDirectory.applicationSupport,
    );

    final String filePath = await task.filePath();
    final File file = File(filePath);

    if (await file.exists()) {
      try {
        await file.delete();
        debugPrint('Successfully deleted file: $filePath');
      } catch (e) {
        debugPrint('Error deleting file: $e');
      }
    } else {
      debugPrint('File was not found at: $filePath');
    }

    await FileDownloader().database.deleteRecordWithId(model.id);

    _taskStatus[model.id] = TaskStatus.notFound;
    _taskProgress.remove(model.id);

    notifyListeners();
  }
}
