// ignore_for_file: use_build_context_synchronously

import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/helper/operating_system.dart';
import 'package:vm_log_api/model/vm_log_api_export_result.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/model/vm_log_api_menu_item.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_sort_option.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_tab_item.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_inspector_screen.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_sort_dialog.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_dialog.dart';
import 'package:vm_log_api/ui/common/vm_log_api_navigation.dart';
import 'package:vm_log_api/ui/common/vm_log_api_page.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_logs_screen.dart';
import 'package:vm_log_api/ui/common/vm_log_api_theme.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

/// Page which displays list of calls caught by VmLogApi. It displays tab view
/// where calls and logs can be inspected. It allows to sort calls, delete calls
/// and search calls.
class VmLogApiCallsListPage extends StatefulWidget {
  final VmLogApiCore core;

  const VmLogApiCallsListPage({required this.core, super.key});

  @override
  State<VmLogApiCallsListPage> createState() => _VmLogApiCallsListPageState();
}

class _VmLogApiCallsListPageState extends State<VmLogApiCallsListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _queryTextEditingController =
      TextEditingController();
  final List<VmLogApiCallsListTabItem> _tabItems = VmLogApiCallsListTabItem.values;
  final ScrollController _scrollController = ScrollController();
  late final TabController? _tabController;

  VmLogApiCallsListSortOption _sortOption = VmLogApiCallsListSortOption.time;
  bool _sortAscending = false;
  bool _searchEnabled = false;
  bool isAndroidRawLogsEnabled = false;
  int _selectedIndex = 0;

  VmLogApiCore get core => widget.core;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: _tabItems.length,
      initialIndex: _tabItems.first.index,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController?.addListener(() {
        _onTabChanged(_tabController.index);
      });
    });
  }

  @override
  void dispose() {
    _queryTextEditingController.dispose();
    _tabController?.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  /// Returns [true] when logger tab is opened.
  bool get isLoggerTab => _selectedIndex == 1;

  @override
  Widget build(BuildContext context) {
    return VmLogApiPage(
      core: core,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
          title:
              _searchEnabled
                  ? _SearchTextField(
                    textEditingController: _queryTextEditingController,
                    onChanged: _updateSearchQuery,
                  )
                  : Text(core.configuration.inspectorTitle),
          actions:
              isLoggerTab
                  ? <Widget>[
                    IconButton(
                      icon: const Icon(Icons.terminal),
                      onPressed: _onLogsChangePressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _onClearLogsPressed,
                    ),
                  ]
                  : <Widget>[
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _onSearchPressed,
                    ),
                    _ContextMenuButton(onMenuItemSelected: _onMenuItemSelected),
                  ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: VmLogApiTheme.lightRed,
            tabs:
                VmLogApiCallsListTabItem.values.map((item) {
                  return Tab(text: _getTabName(item: item));
                }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            VmLogApiInspectorScreen(
              core: core,
              queryTextEditingController: _queryTextEditingController,
              sortOption: _sortOption,
              sortAscending: _sortAscending,
              onListItemPressed: _onListItemPressed,
            ),
            VmLogApiLogsScreen(
              scrollController: _scrollController,
              logger: widget.core.configuration.logger,
              isAndroidRawLogsEnabled: isAndroidRawLogsEnabled,
            ),
          ],
        ),
        floatingActionButton:
            isLoggerTab
                ? _LoggerFloatingActionButtons(scrollLogsList: _scrollLogsList)
                : const SizedBox(),
      ),
    );
  }

  /// Get tab name based on [item] type.
  String _getTabName({required VmLogApiCallsListTabItem item}) {
    switch (item) {
      case VmLogApiCallsListTabItem.inspector:
        return context.i18n(VmLogApiTranslationKey.callsListInspector);
      case VmLogApiCallsListTabItem.logger:
        return context.i18n(VmLogApiTranslationKey.callsListLogger);
    }
  }

  /// Called when back button has been pressed. It navigates back to original
  /// application.
  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  /// Called when clear logs has been pressed. It displays dialog and awaits for
  /// user confirmation.
  void _onClearLogsPressed() => VmLogApiGeneralDialog.show(
    context: context,
    title: context.i18n(VmLogApiTranslationKey.callsListDeleteLogsDialogTitle),
    description: context.i18n(
      VmLogApiTranslationKey.callsListDeleteLogsDialogDescription,
    ),
    firstButtonTitle: context.i18n(VmLogApiTranslationKey.callsListNo),
    secondButtonTitle: context.i18n(VmLogApiTranslationKey.callsListYes),
    secondButtonAction: _onLogsClearPressed,
  );

  /// Called when logs type mode pressed.
  void _onLogsChangePressed() => setState(() {
    isAndroidRawLogsEnabled = !isAndroidRawLogsEnabled;
  });

  /// Called when logs clear button has been pressed.
  void _onLogsClearPressed() => setState(() {
    if (isAndroidRawLogsEnabled) {
      widget.core.configuration.logger.clearAndroidRawLogs();
    } else {
      widget.core.configuration.logger.clearLogs();
    }
  });

  /// Called when search button. It displays search text field.
  void _onSearchPressed() => setState(() {
    _searchEnabled = !_searchEnabled;
    if (!_searchEnabled) {
      _queryTextEditingController.text = '';
    }
  });

  /// Called on tab has been changed.
  void _onTabChanged(int index) => setState(() {
    _selectedIndex = index;
    if (_selectedIndex == 1) {
      _searchEnabled = false;
      _queryTextEditingController.text = '';
    }
  });

  /// Called when menu item from overflow menu has been pressed.
  void _onMenuItemSelected(VmLogApiCallDetailsMenuItemType menuItem) {
    switch (menuItem) {
      case VmLogApiCallDetailsMenuItemType.sort:
        _onSortPressed();
      case VmLogApiCallDetailsMenuItemType.delete:
        _onRemovePressed();
      case VmLogApiCallDetailsMenuItemType.stats:
        _onStatsPressed();
      case VmLogApiCallDetailsMenuItemType.save:
        _saveToFile();
    }
  }

  /// Called when item from the list has been pressed. It opens details page.
  void _onListItemPressed(VmLogApiHttpCall call) =>
      VmLogApiNavigation.navigateToCallDetails(
        call: call,
        core: core,
        context: context,
      );

  /// Called when remove all calls button has been pressed.
  void _onRemovePressed() => VmLogApiGeneralDialog.show(
    context: context,
    title: context.i18n(VmLogApiTranslationKey.callsListDeleteCallsDialogTitle),
    description: context.i18n(
      VmLogApiTranslationKey.callsListDeleteCallsDialogDescription,
    ),
    firstButtonTitle: context.i18n(VmLogApiTranslationKey.callsListNo),
    firstButtonAction: () => <String, dynamic>{},
    secondButtonTitle: context.i18n(VmLogApiTranslationKey.callsListYes),
    secondButtonAction: _removeCalls,
  );

  /// Removes all calls from VmLogApi.
  void _removeCalls() => core.removeCalls();

  /// Called when stats button has been pressed. Navigates to stats page.
  void _onStatsPressed() {
    VmLogApiNavigation.navigateToStats(core: core, context: context);
  }

  /// Called when save to file has been pressed. It saves data to file.
  void _saveToFile() async {
    if (!mounted) return;
    final result = await core.saveCallsToFile(context);

    if (result.success && result.path != null) {
      VmLogApiGeneralDialog.show(
        context: context,
        title: context.i18n(VmLogApiTranslationKey.saveSuccessTitle),
        description: context
            .i18n(VmLogApiTranslationKey.saveSuccessDescription)
            .replaceAll("[path]", result.path!),
        secondButtonTitle:
            OperatingSystem.isAndroid
                ? context.i18n(VmLogApiTranslationKey.saveSuccessView)
                : null,
        secondButtonAction:
            () =>
                OperatingSystem.isAndroid ? OpenFilex.open(result.path!) : null,
      );
    } else {
      final [String title, String description] = switch (result.error) {
        VmLogApiExportResultError.logGenerate => [
          context.i18n(VmLogApiTranslationKey.saveDialogPermissionErrorTitle),
          context.i18n(
            VmLogApiTranslationKey.saveDialogPermissionErrorDescription,
          ),
        ],
        VmLogApiExportResultError.empty => [
          context.i18n(VmLogApiTranslationKey.saveDialogEmptyErrorTitle),
          context.i18n(VmLogApiTranslationKey.saveDialogEmptyErrorDescription),
        ],
        VmLogApiExportResultError.permission => [
          context.i18n(VmLogApiTranslationKey.saveDialogPermissionErrorTitle),
          context.i18n(
            VmLogApiTranslationKey.saveDialogPermissionErrorDescription,
          ),
        ],
        VmLogApiExportResultError.file => [
          context.i18n(VmLogApiTranslationKey.saveDialogFileSaveErrorTitle),
          context.i18n(VmLogApiTranslationKey.saveDialogFileSaveErrorDescription),
        ],
        _ => ["", ""],
      };

      VmLogApiGeneralDialog.show(
        context: context,
        title: title,
        description: description,
      );
    }
  }

  /// Filters calls based on query.
  void _updateSearchQuery(String query) => setState(() {});

  /// Called when sort button has been pressed. It opens dialog where filters
  /// can be picked.
  Future<void> _onSortPressed() async {
    VmLogApiSortDialogResult? result = await showDialog<VmLogApiSortDialogResult>(
      context: context,
      builder:
          (_) => VmLogApiSortDialog(
            sortOption: _sortOption,
            sortAscending: _sortAscending,
          ),
    );
    if (result != null) {
      setState(() {
        _sortOption = result.sortOption;
        _sortAscending = result.sortAscending;
      });
    }
  }

  /// Scrolls logs list based on [top] parameter.
  void _scrollLogsList(bool top) => top ? _scrollToTop() : _scrollToBottom();

  /// Scrolls logs list to the top.
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(microseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  /// Scrolls logs list to the bottom.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 500),
        curve: Curves.ease,
      );
    }
  }
}

/// Text field displayed in app bar. Used to search call logs.
class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.textEditingController,
    required this.onChanged,
  });

  final TextEditingController textEditingController;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: context.i18n(VmLogApiTranslationKey.callsListSearchHint),
        hintStyle: const TextStyle(fontSize: 16, color: VmLogApiTheme.grey),
        border: InputBorder.none,
      ),
      style: const TextStyle(fontSize: 16),
      onChanged: onChanged,
    );
  }
}

/// Menu button displayed in app bar. It displays overflow menu with additional
/// actions.
class _ContextMenuButton extends StatelessWidget {
  const _ContextMenuButton({required this.onMenuItemSelected});

  final void Function(VmLogApiCallDetailsMenuItemType) onMenuItemSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VmLogApiCallDetailsMenuItemType>(
      onSelected: onMenuItemSelected,
      itemBuilder:
          (BuildContext context) => [
            for (final VmLogApiCallDetailsMenuItemType item
                in VmLogApiCallDetailsMenuItemType.values)
              PopupMenuItem<VmLogApiCallDetailsMenuItemType>(
                value: item,
                child: Row(
                  children: [
                    Icon(_getIcon(itemType: item), color: VmLogApiTheme.lightRed),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(_getTitle(context: context, itemType: item)),
                  ],
                ),
              ),
          ],
    );
  }

  /// Get title of the menu item based on [itemType].
  String _getTitle({
    required BuildContext context,
    required VmLogApiCallDetailsMenuItemType itemType,
  }) {
    switch (itemType) {
      case VmLogApiCallDetailsMenuItemType.sort:
        return context.i18n(VmLogApiTranslationKey.callsListSort);
      case VmLogApiCallDetailsMenuItemType.delete:
        return context.i18n(VmLogApiTranslationKey.callsListDelete);
      case VmLogApiCallDetailsMenuItemType.stats:
        return context.i18n(VmLogApiTranslationKey.callsListStats);
      case VmLogApiCallDetailsMenuItemType.save:
        return context.i18n(VmLogApiTranslationKey.callsListSave);
    }
  }

  /// Get icon of the menu item based [itemType].
  IconData _getIcon({required VmLogApiCallDetailsMenuItemType itemType}) {
    switch (itemType) {
      case VmLogApiCallDetailsMenuItemType.sort:
        return Icons.sort;
      case VmLogApiCallDetailsMenuItemType.delete:
        return Icons.delete;
      case VmLogApiCallDetailsMenuItemType.stats:
        return Icons.insert_chart;
      case VmLogApiCallDetailsMenuItemType.save:
        return Icons.save;
    }
  }
}

/// FAB buttons used to scroll logs. Displayed only in logs tab.
class _LoggerFloatingActionButtons extends StatelessWidget {
  const _LoggerFloatingActionButtons({required this.scrollLogsList});

  final void Function(bool) scrollLogsList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'h1',
          backgroundColor: VmLogApiTheme.lightRed,
          onPressed: () => scrollLogsList(true),
          child: const Icon(Icons.arrow_upward, color: VmLogApiTheme.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'h2',
          backgroundColor: VmLogApiTheme.lightRed,
          onPressed: () => scrollLogsList(false),
          child: const Icon(Icons.arrow_downward, color: VmLogApiTheme.white),
        ),
      ],
    );
  }
}
