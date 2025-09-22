import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../models.dart';
import '../widgets.dart';

class DashboardBody extends StatelessWidget {
  final DashboardState state;
  final TabController tabController;
  final ValueChanged<Environment?> onEnvironmentChanged;
  final ValueChanged<ExtensionInfo> onExtensionSelected;
  final ValueChanged<String> onShortcutPressed;
  final VoidCallback? onViewModeChanged;

  const DashboardBody({
    super.key,
    required this.state,
    required this.tabController,
    required this.onEnvironmentChanged,
    required this.onExtensionSelected,
    required this.onShortcutPressed,
    this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }
    if (state.diagnostics == null) {
      return const Center(child: Text('No data'));
    }
    return Column(
      children: [
        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ExtensionsTab(
                extensions: state.diagnostics!.extensions,
                selectedExtension: state.selectedExtension,
                onExtensionSelected: onExtensionSelected,
                showList: state.showExtensionsList,
                onViewModeChanged: onViewModeChanged,
              ),
              BuildInfoTab(buildInfo: state.diagnostics!.buildInfo),
              ServerInfoTab(serverInfo: state.diagnostics!.serverInfo),
            ],
          ),
        ),
        // Tabs
        GFTabBar(
          controller: tabController,
          length: 3,
          tabBarColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withAlpha(178),
          tabs: [
            Tab(icon: Icon(Icons.apps), text: 'Extensions'),
            Tab(icon: Icon(Icons.build), text: 'Build Info'),
            Tab(icon: Icon(Icons.computer), text: 'Server Info'),
          ],
        ),
      ],
    );
  }
}
