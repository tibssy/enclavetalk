import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:enclavetalk/data/available_models.dart';
import 'package:enclavetalk/services/download_service.dart';
import 'package:enclavetalk/services/model_provider.dart';
import 'package:enclavetalk/ui/model_management_screen.dart';

class ModelSelectionSheet extends StatelessWidget {
  const ModelSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadService = context.watch<DownloadService>();
    final modelProvider = context.watch<ModelProvider>();

    final downloadedModels = availableModels.where((model) {
      return downloadService.getStatus(model.id) == TaskStatus.complete;
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black26,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select AI Model",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (downloadedModels.isEmpty)
              _buildEmptyState(context)
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: downloadedModels.length,
                  itemBuilder: (context, index) {
                    final model = downloadedModels[index];
                    final isSelected =
                        modelProvider.selectedModelId == model.id;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      leading: Icon(
                        Icons.smart_toy_outlined,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      title: Text(
                        model.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        model.size,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        modelProvider.setSelectedModel(model.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("No models downloaded yet.", textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ModelManagementScreen(),
                ),
              );
            },
            child: const Text("Manage Models"),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
