import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
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
                        onPressed: () => context.read<DashboardBloc>().add(
                          ToggleExtensionsListEvent(),
                        ),
                        type: GFButtonType.transparent,
                      ),
                    )
                  : null,
              actions: [
                PopupMenuButton<Object>(
                  icon: Icon(Icons.menu),
                  onSelected: (value) {
                    if (value is String) {
                      context.read<DashboardBloc>().add(
                        HandleShortcutEvent(value),
                      );
                      _tabController.index = 0; // Switch to Extensions tab
                    } else if (value is Environment) {
                      context.read<DashboardBloc>().add(
                        ChangeEnvironmentEvent(value),
                      );
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
