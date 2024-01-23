import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
    this.value, {
    super.key,
    required this.data,
    this.error,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: error ?? _defaultError,
      loading: loading ?? _defaultLoading,
    );
  }

  Widget _defaultError(Object error, StackTrace stackTrace) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget _defaultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
