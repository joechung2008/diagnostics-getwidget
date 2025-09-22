import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../models.dart';
import '../services.dart';
import '../widgets.dart';

class DashboardPageBloc extends StatefulWidget {
  const DashboardPageBloc({super.key, this.diagnosticsService});

  final DiagnosticsService? diagnosticsService;

  @override
  State<DashboardPageBloc> createState() => _DashboardPageBlocState();
}

class _DashboardPageBlocState extends State<DashboardPageBloc>
    with TickerProviderStateMixin {
  static const int _tabCount = 3;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardBloc(widget.diagnosticsService ?? DiagnosticsService())
            ..add(LoadDiagnosticsEvent()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, dashboardState) {
          return Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: dashboardState.selectedEnvironment,
              showExtensionsList: dashboardState.showExtensionsList,
              currentTabIndex: _tabController.index,
              extensions: dashboardState.diagnostics?.extensions,
              onToggleExtensionsList: () => context.read<DashboardBloc>().add(
                ToggleExtensionsListEvent(),
              ),
              onShortcutPressed: (extensionName) {
                context.read<DashboardBloc>().add(
                  HandleShortcutEvent(extensionName),
                );
                _tabController.index = 0;
              },
              onEnvironmentChanged: (environment) {
                if (environment != null) {
                  context.read<DashboardBloc>().add(
                    ChangeEnvironmentEvent(environment),
                  );
                  _tabController.index = 0;
                }
              },
            ),
            body: DashboardBody(
              state: dashboardState,
              tabController: _tabController,
              onEnvironmentChanged: (environment) => context
                  .read<DashboardBloc>()
                  .add(ChangeEnvironmentEvent(environment)),
              onExtensionSelected: (extension) => context
                  .read<DashboardBloc>()
                  .add(SelectExtensionEvent(extension)),
              onShortcutPressed: (extensionName) {
                context.read<DashboardBloc>().add(
                  HandleShortcutEvent(extensionName),
                );
                _tabController.index = 0;
              },
              onViewModeChanged: () {
                context.read<DashboardBloc>().add(ToggleExtensionsListEvent());
              },
            ),
          );
        },
      ),
    );
  }
}
