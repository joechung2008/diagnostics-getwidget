import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../models.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Environment selectedEnvironment;
  final bool showExtensionsList;
  final int currentTabIndex;
  final Map<String, Extension>? extensions;
  final VoidCallback onToggleExtensionsList;
  final ValueChanged<String> onShortcutPressed;
  final ValueChanged<Environment?> onEnvironmentChanged;

  const DashboardAppBar({
    super.key,
    required this.selectedEnvironment,
    required this.showExtensionsList,
    required this.currentTabIndex,
    this.extensions,
    required this.onToggleExtensionsList,
    required this.onShortcutPressed,
    required this.onEnvironmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        selectedEnvironment.displayName,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      leading:
          (currentTabIndex == 0 && MediaQuery.of(context).size.width <= 600)
          ? Semantics(
              label: showExtensionsList ? 'Show Details' : 'Show List',
              child: GFIconButton(
                icon: Icon(
                  showExtensionsList ? Icons.view_list : Icons.article,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: onToggleExtensionsList,
                type: GFButtonType.transparent,
              ),
            )
          : null,
      actions: [
        PopupMenuButton<Object>(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onSelected: (value) {
            if (value is String) {
              onShortcutPressed(value);
            } else if (value is Environment) {
              onEnvironmentChanged(value);
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
            if (extensions?.containsKey('paasserverless') ?? false)
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
