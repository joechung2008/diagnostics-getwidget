import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dashboard_controller.dart';
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
      appBar: DashboardAppBar(
        selectedEnvironment: dashboardState.selectedEnvironment,
        showExtensionsList: dashboardState.showExtensionsList,
        currentTabIndex: _tabController.index,
        extensions: dashboardState.diagnostics?.extensions,
        onToggleExtensionsList: controller.toggleExtensionsList,
        onShortcutPressed: (extensionName) {
          controller.handleShortcut(extensionName);
          _tabController.index = 0;
        },
        onEnvironmentChanged: (environment) {
          if (environment != null) {
            controller.setEnvironment(environment);
            _tabController.index = 0;
          }
        },
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
