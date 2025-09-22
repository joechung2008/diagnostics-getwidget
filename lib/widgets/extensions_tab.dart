import 'package:flutter/material.dart';
import '../models.dart';
import 'configuration_widget.dart';
import 'stage_definition_widget.dart';

class ExtensionsTab extends StatelessWidget {
  final Map<String, Extension> extensions;
  final ExtensionInfo? selectedExtension;
  final ValueChanged<ExtensionInfo> onExtensionSelected;
  final bool showList;
  final VoidCallback? onViewModeChanged;

  const ExtensionsTab({
    super.key,
    required this.extensions,
    required this.selectedExtension,
    required this.onExtensionSelected,
    required this.showList,
    this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;

        final listWidget = SizedBox(
          width: isSmall ? double.infinity : 300,
          height: isSmall ? double.infinity : null,
          child: ListView(
            children:
                (extensions.entries
                        .where((entry) => entry.value.isInfo)
                        .toList()
                      ..sort(
                        (a, b) => a.value.info!.extensionName.compareTo(
                          b.value.info!.extensionName,
                        ),
                      ))
                    .map(
                      (entry) => ListTile(
                        title: Text(
                          entry.value.info!.extensionName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        selected:
                            selectedExtension?.extensionName ==
                            entry.value.info!.extensionName,
                        onTap: () {
                          onExtensionSelected(entry.value.info!);
                          // On small screens, switch to details view when selecting
                          if (isSmall &&
                              showList &&
                              onViewModeChanged != null) {
                            onViewModeChanged!();
                          }
                        },
                      ),
                    )
                    .toList(),
          ),
        );

        final detailsWidget = SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: selectedExtension != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedExtension!.extensionName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (selectedExtension!.config != null)
                        ConfigurationWidget(config: selectedExtension!.config!),
                      if (selectedExtension!.stageDefinition != null)
                        StageDefinitionWidget(
                          stageDefinition: selectedExtension!.stageDefinition!,
                        ),
                    ],
                  ),
                )
              : const Center(child: Text('Select an extension')),
        );

        if (isSmall) {
          return Column(
            children: [Expanded(child: showList ? listWidget : detailsWidget)],
          );
        } else {
          return Row(
            children: [
              listWidget,
              Expanded(child: detailsWidget),
            ],
          );
        }
      },
    );
  }
}
