import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'cutom_loader.dart';

class InfiniteScrollList<T> extends StatefulWidget {
  final Widget Function(BuildContext, T, int) itemBuilder;
  final int pageSize;
  final void Function() fetchNextPage;
  final PagingState<int, T> state;
  const InfiniteScrollList({
    required this.itemBuilder,
    this.pageSize = 10,
    required this.fetchNextPage,
    required this.state,
    super.key,
  });

  @override
  _InfiniteScrollListState<T> createState() => _InfiniteScrollListState<T>();
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollList<T>> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      state: widget.state,
      fetchNextPage: widget.fetchNextPage,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: widget.itemBuilder,
        firstPageErrorIndicatorBuilder: (_) =>
            Center(child: Text("Error loading data")),
        noItemsFoundIndicatorBuilder: (_) =>
            Center(child: Text("No items available")),
        firstPageProgressIndicatorBuilder: (context) =>
            Center(child: CustomLoader()),
        newPageProgressIndicatorBuilder: (context) =>
            Center(child: CustomLoader()),
      ),
    );
  }
}
