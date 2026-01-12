import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/widgets/entity_search/controllers/entity_search_args.dart';
import 'package:web_dashboard/common/widgets/entity_search/controllers/entity_search_controller.dart';
import 'package:web_dashboard/common/widgets/entity_search/state/entity_search_state.dart';
import 'package:web_dashboard/common/widgets/entity_search/viewmodels/entity_option.dart';

/// 학과/유저 등 연관 엔티티를 검색해 선택할 수 있는 공통 입력 필드.
class EntitySearchField extends ConsumerStatefulWidget {
  const EntitySearchField({
    required this.searchType,
    required this.onSelected,
    this.labelText,
    this.hintText,
    this.initialOption,
    this.limit = 20,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.enableBottomSheetOnNarrow = true,
    this.emptyPlaceholder = '검색 결과가 없습니다.',
    this.errorPlaceholder = '검색 중 오류가 발생했습니다.',
    super.key,
    this.onCleared,
  });

  final EntitySearchType searchType;
  final ValueChanged<EntityOption> onSelected;
  final String? labelText;
  final String? hintText;
  final EntityOption? initialOption;
  final int limit;
  final Duration debounceDuration;
  final bool enableBottomSheetOnNarrow;
  final String emptyPlaceholder;
  final String errorPlaceholder;
  final VoidCallback? onCleared;

  @override
  ConsumerState<EntitySearchField> createState() => _EntitySearchFieldState();
}

class _EntitySearchFieldState extends ConsumerState<EntitySearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late EntitySearchArgs _args;
  Timer? _debounce;
  bool _isSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialOption?.label ?? '');
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    _args = _buildArgs(widget);
  }

  @override
  void didUpdateWidget(covariant EntitySearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialOption?.id != oldWidget.initialOption?.id) {
      _controller.text = widget.initialOption?.label ?? '';
    }
    if (widget.searchType != oldWidget.searchType ||
        widget.limit != oldWidget.limit ||
        widget.initialOption?.id != oldWidget.initialOption?.id) {
      _args = _buildArgs(widget);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<EntitySearchState> asyncState =
        ref.watch(entitySearchControllerProvider(_args));
    final EntitySearchState? currentState = asyncState.asData?.value;
    final bool useBottomSheet = _shouldUseBottomSheet(context);
    final bool showDropdown = !useBottomSheet &&
        _focusNode.hasFocus &&
        (currentState?.options.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        Semantics(
          label: '검색어 입력',
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: useBottomSheet,
            onChanged: useBottomSheet ? null : _handleQueryChanged,
            onTap: useBottomSheet ? _openBottomSheet : null,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '검색어를 입력하세요',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      onPressed: _handleClear,
                      icon: const Icon(Icons.clear),
                      tooltip: '지우기',
                    ),
                  if (asyncState.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (asyncState.hasError && !useBottomSheet)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorPlaceholder,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (showDropdown)
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: _EntitySearchResultsList(
                asyncState: asyncState,
                state: currentState,
                emptyPlaceholder: widget.emptyPlaceholder,
                errorPlaceholder: widget.errorPlaceholder,
                onSelected: _handleSelect,
                onLoadMore: _loadMore,
              ),
            ),
          ),
        if (!useBottomSheet &&
            !asyncState.isLoading &&
            (_controller.text.isNotEmpty) &&
            (currentState?.options.isEmpty ?? true))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.emptyPlaceholder,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  EntitySearchArgs _buildArgs(EntitySearchField widget) {
    return EntitySearchArgs(
      type: widget.searchType,
      limit: widget.limit,
      initialQuery: widget.initialOption?.label,
      initialSelection: widget.initialOption?.id,
    );
  }

  bool _shouldUseBottomSheet(BuildContext context) {
    if (!widget.enableBottomSheetOnNarrow) {
      return false;
    }
    final MediaQueryData media = MediaQuery.of(context);
    return media.size.width < 640;
  }

  void _handleQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      ref
          .read(entitySearchControllerProvider(_args).notifier)
          .search(value);
    });
  }

  void _handleClear() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(entitySearchControllerProvider(_args).notifier).clearSelection();
    widget.onCleared?.call();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      return;
    }
    if (_shouldUseBottomSheet(context)) {
      _openBottomSheet();
    } else if (_controller.text.isNotEmpty) {
      ref
          .read(entitySearchControllerProvider(_args).notifier)
          .search(_controller.text);
    }
  }

  Future<void> _openBottomSheet() async {
    if (_isSheetOpen) {
      return;
    }
    _isSheetOpen = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _EntitySearchBottomSheet(
            args: _args,
            initialText: _controller.text,
            debounceDuration: widget.debounceDuration,
            emptyPlaceholder: widget.emptyPlaceholder,
            errorPlaceholder: widget.errorPlaceholder,
            hintText: widget.hintText ?? '검색어를 입력하세요',
            onSelected: (EntityOption option) {
              Navigator.of(ctx).pop();
              _handleSelect(option);
            },
            onCleared: () {
              Navigator.of(ctx).pop();
              _handleClear();
            },
          ),
        );
      },
    );
    _isSheetOpen = false;
  }

  void _handleSelect(EntityOption option) {
    _controller.text = option.label;
    ref
        .read(entitySearchControllerProvider(_args).notifier)
        .selectOption(option);
    widget.onSelected(option);
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _loadMore() {
    ref.read(entitySearchControllerProvider(_args).notifier).loadMore();
  }
}

/// 검색 옵션 리스트와 더보기 버튼을 그리는 내부 위젯.
class _EntitySearchResultsList extends StatelessWidget {
  const _EntitySearchResultsList({
    required this.asyncState,
    required this.state,
    required this.onSelected,
    required this.onLoadMore,
    required this.emptyPlaceholder,
    required this.errorPlaceholder,
  });

  final AsyncValue<EntitySearchState> asyncState;
  final EntitySearchState? state;
  final ValueChanged<EntityOption> onSelected;
  final VoidCallback onLoadMore;
  final String emptyPlaceholder;
  final String errorPlaceholder;

  @override
  Widget build(BuildContext context) {
    final List<EntityOption> options = state?.options ?? const <EntityOption>[];
    if (asyncState.isLoading && options.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (asyncState.hasError && options.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            errorPlaceholder,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
    if (options.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(emptyPlaceholder),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        for (final EntityOption option in options)
          ListTile(
            title: Text(option.label),
            subtitle:
                option.subtitle != null ? Text(option.subtitle!) : null,
            onTap: () => onSelected(option),
          ),
        if (state?.hasMore ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: onLoadMore,
              icon: state!.isLoadingMore
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.expand_more),
              label: const Text('더 불러오기'),
            ),
          ),
      ],
    );
  }
}

/// 모바일 환경에서 전체 화면 검색 경험을 제공하는 바텀시트.
class _EntitySearchBottomSheet extends ConsumerStatefulWidget {
  const _EntitySearchBottomSheet({
    required this.args,
    required this.initialText,
    required this.debounceDuration,
    required this.emptyPlaceholder,
    required this.errorPlaceholder,
    required this.hintText,
    required this.onSelected,
    this.onCleared,
  });

  final EntitySearchArgs args;
  final String initialText;
  final Duration debounceDuration;
  final String emptyPlaceholder;
  final String errorPlaceholder;
  final String hintText;
  final ValueChanged<EntityOption> onSelected;
  final VoidCallback? onCleared;

  @override
  ConsumerState<_EntitySearchBottomSheet> createState() =>
      _EntitySearchBottomSheetState();
}

class _EntitySearchBottomSheetState
    extends ConsumerState<_EntitySearchBottomSheet> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.text.isNotEmpty) {
        ref
            .read(entitySearchControllerProvider(widget.args).notifier)
            .search(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<EntitySearchState> asyncState =
        ref.watch(entitySearchControllerProvider(widget.args));
    final EntitySearchState? currentState = asyncState.asData?.value;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Semantics(
              label: '검색어 입력',
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            ref
                                .read(entitySearchControllerProvider(widget.args)
                                    .notifier)
                                .clearSelection();
                            widget.onCleared?.call();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: _handleChanged,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: _EntitySearchResultsList(
                asyncState: asyncState,
                state: currentState,
                emptyPlaceholder: widget.emptyPlaceholder,
                errorPlaceholder: widget.errorPlaceholder,
                onSelected: widget.onSelected,
                onLoadMore: () => ref
                    .read(
                        entitySearchControllerProvider(widget.args).notifier)
                    .loadMore(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      ref
          .read(entitySearchControllerProvider(widget.args).notifier)
          .search(value);
    });
  }
}
