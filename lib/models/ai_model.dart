enum DownloadStatus { notDownloaded, downloading, downloaded }

class AIModel {
  final String id;
  final String name;
  final String description;
  final String size;
  DownloadStatus status;
  double downloadProgress;

  AIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    this.status = DownloadStatus.notDownloaded,
    this.downloadProgress = 0.0,
  });
}
