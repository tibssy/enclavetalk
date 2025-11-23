import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:enclavetalk/models/ai_model.dart';
import 'package:enclavetalk/services/download_service.dart';
import 'package:enclavetalk/data/available_models.dart';
import 'package:enclavetalk/ui/widgets/hf_token_dialog.dart';

class ModelManagementScreen extends StatefulWidget {
  const ModelManagementScreen({super.key});

  @override
  State<ModelManagementScreen> createState() => _ModelManagementScreenState();
}

class _ModelManagementScreenState extends State<ModelManagementScreen> {
  final List<AIModel> _models = availableModels;

  void _handleDownloadTap(
    BuildContext context,
    AIModel model,
    DownloadService downloadService,
  ) {
    if (model.requiresAuth && !downloadService.hasToken) {
      showDialog(
        context: context,
        builder: (context) => HfTokenDialog(
          onSave: (token) {
            downloadService.saveToken(token).then((_) {
              downloadService.startDownload(model);
            });
          },
        ),
      );
      return;
    }
    downloadService.startDownload(model);
  }

  Widget _buildTrailingWidget(AIModel model, DownloadService downloadService) {
    final status = downloadService.getStatus(model.id);
    final progress = downloadService.getProgress(model.id);
    final bool isLocked = model.requiresAuth && !downloadService.hasToken;

    switch (status) {
      case TaskStatus.enqueued:
        return const Text(
          'Pending...',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        );
      case TaskStatus.running:
        return Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case TaskStatus.complete:
        return IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => downloadService.deleteModel(model),
        );
      case TaskStatus.failed:
      case TaskStatus.canceled:
      case TaskStatus.notFound:
      default:
        return IconButton(
          icon: Icon(
            isLocked ? Icons.lock_outline : Icons.download_for_offline_outlined,
            color: isLocked ? Colors.orange : null,
          ),
          onPressed: () => _handleDownloadTap(context, model, downloadService),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloadService = context.watch<DownloadService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Models')),
      body: ListView.builder(
        itemCount: _models.length,
        itemBuilder: (context, index) {
          final model = _models[index];

          final status = downloadService.getStatus(model.id);
          final progress = downloadService.getProgress(model.id);

          final isDownloading =
              status == TaskStatus.running || status == TaskStatus.enqueued;
          final isDownloaded = status == TaskStatus.complete;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Icon(
                    Icons.memory,
                    size: 32,
                    color: isDownloaded
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    model.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text('${model.description}\nSize: ${model.size}'),
                  isThreeLine: true,
                  trailing: _buildTrailingWidget(model, downloadService),
                ),
                if (isDownloading)
                  LinearProgressIndicator(
                    value: status == TaskStatus.enqueued ? null : progress,
                    minHeight: 4,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
