import 'dart:async';
import 'package:flutter/material.dart';
import 'package:enclavetalk/models/ai_model.dart';

class ModelManagementScreen extends StatefulWidget {
  const ModelManagementScreen({super.key});

  @override
  State<ModelManagementScreen> createState() => _ModelManagementScreenState();
}

class _ModelManagementScreenState extends State<ModelManagementScreen> {
  final List<AIModel> _models = [
    AIModel(
      id: 'gemma-2b',
      name: 'Gemma 2B',
      description: 'Fast and capable for general chat.',
      size: '1.5 GB',
      status: DownloadStatus.downloaded,
    ),
    AIModel(
      id: 'phi-3-mini',
      name: 'Phi-3 Mini',
      description: 'Powerful, small model from Microsoft.',
      size: '2.1 GB',
    ),
    AIModel(
      id: 'gemma-3-nano',
      name: 'Gemma 3 Nano',
      description: 'Excellent multimodal vision capabilities.',
      size: '3.4 GB',
    ),
  ];

  // --- DUMMY LOGIC ---
  // Simulates downloading a model
  void _startDownload(AIModel model) {
    setState(() {
      model.status = DownloadStatus.downloading;
      model.downloadProgress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        model.downloadProgress += 0.05;
        if (model.downloadProgress >= 1.0) {
          model.downloadProgress = 1.0;
          model.status = DownloadStatus.downloaded;
          timer.cancel();
        }
      });
    });
  }

  void _deleteModel(AIModel model) {
    setState(() {
      model.status = DownloadStatus.notDownloaded;
      model.downloadProgress = 0.0;
    });
  }

  // --- UI WIDGETS ---
  Widget _buildActionButton(AIModel model) {
    switch (model.status) {
      case DownloadStatus.notDownloaded:
        return IconButton(
          icon: const Icon(Icons.download_for_offline_outlined),
          onPressed: () => _startDownload(model),
        );
      case DownloadStatus.downloading:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: model.downloadProgress,
            strokeWidth: 3,
          ),
        );
      case DownloadStatus.downloaded:
        return IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _deleteModel(model),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Models')),
      body: ListView.builder(
        itemCount: _models.length,
        itemBuilder: (context, index) {
          final model = _models[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.memory),
              title: Text(model.name),
              subtitle: Text('${model.description}\nSize: ${model.size}'),
              isThreeLine: true,
              trailing: _buildActionButton(model),
            ),
          );
        },
      ),
    );
  }
}
