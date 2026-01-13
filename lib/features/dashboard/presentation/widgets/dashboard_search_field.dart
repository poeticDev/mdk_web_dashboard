/// ROLE
/// - 대시보드 검색 입력 UI를 제공한다
///
/// RESPONSIBILITY
/// - 검색어 입력과 디바운스 처리를 관리한다
///
/// DEPENDS ON
/// - 없음
library;

import 'dart:async';

import 'package:flutter/material.dart';

const Duration _defaultDebounce = Duration(milliseconds: 250);

class DashboardSearchField extends StatefulWidget {
  const DashboardSearchField({
    required this.onQueryChanged,
    super.key,
    this.initialValue = '',
    this.hintText = '검색 (건물명, 강의실, 학과)',
    this.debounceDuration = _defaultDebounce,
  });

  final String initialValue;
  final String hintText;
  final Duration debounceDuration;
  final ValueChanged<String> onQueryChanged;

  @override
  State<DashboardSearchField> createState() => _DashboardSearchFieldState();
}

class _DashboardSearchFieldState extends State<DashboardSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant DashboardSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: _clearQuery,
                icon: const Icon(Icons.clear),
                tooltip: '지우기',
              ),
      ),
    );
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onQueryChanged(value);
    });
    setState(() {});
  }

  void _clearQuery() {
    _controller.clear();
    widget.onQueryChanged('');
    setState(() {});
  }
}
