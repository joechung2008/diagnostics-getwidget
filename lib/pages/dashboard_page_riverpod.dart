import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../controllers/dashboard_controller.dart';
import '../models.dart';
import '../widgets.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with TickerProviderStateMixin {
  static const int _tabCount = 3;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardControllerProvider.notifier).loadDiagnostics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: GFAppBar(
        centerTitle: true,
        title: Text(dashboardState.selectedEnvironment.displayName),
        leading:
            (_tabController.index == 0 &&
                MediaQuery.of(context).size.width <= 600)
            ? Semantics(
                label: dashboardState.showExtensionsList
                    ? 'Show Details'
                    : 'Show List',
                child: GFIconButton(
                  icon: Icon(
                    dashboardState.showExtensionsList
                        ? Icons.view_list
                        : Icons.article,
                  ),
                  onPressed: controller.toggleExtensionsList,
                  type: GFButtonType.transparent,
                ),
              )
            : null,
        actions: [
          PopupMenuButton<Object>(
            icon: Icon(Icons.menu),
            onSelected: (value) {
              if (value is String) {
                controller.handleShortcut(value);
                _tabController.index = 0; // Switch to Extensions tab
              } else if (value is Environment) {
                controller.setEnvironment(value);
                _tabController.index = 0; // Reset to Extensions tab
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<Environment>(
                value: Environment.public,
                child: Text('Public Cloud'),
              ),
              const PopupMenuItem<Environment>(
                value: Environment.fairfax,
                child: Text('Fairfax'),
              ),
              const PopupMenuItem<Environment>(
                value: Environment.mooncake,
                child: Text('Mooncake'),
              ),
              const PopupMenuDivider(),
              if (dashboardState.diagnostics?.extensions.containsKey(
                    'paasserverless',
                  ) ??
                  false)
                const PopupMenuItem<String>(
                  value: 'paasserverless',
                  child: Text('paasserverless'),
                ),
              const PopupMenuItem<String>(
                value: 'websites',
                child: Text('websites'),
              ),
            ],
          ),
        ],
      ),
      body: DashboardBody(
        state: dashboardState,
        tabController: _tabController,
        onEnvironmentChanged: controller.setEnvironment,
        onExtensionSelected: controller.selectExtension,
        onShortcutPressed: (extensionName) {
          controller.handleShortcut(extensionName);
          _tabController.index = 0;
        },
        onViewModeChanged: () {
          // This could be moved to controller if needed
          ref.read(dashboardControllerProvider.notifier).toggleExtensionsList();
        },
      ),
    );
  }
}
