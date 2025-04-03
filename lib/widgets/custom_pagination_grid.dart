import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../app_const/app_size.dart';
import 'cutom_loader.dart';

class InfiniteScrollGridList<T> extends StatefulWidget {
  final Widget Function(BuildContext, T, int) itemBuilder;
  final int pageSize;
  final void Function() fetchNextPage;
  final PagingState<int, T> state;
  const InfiniteScrollGridList({
    required this.itemBuilder,
    this.pageSize = 10,
    required this.fetchNextPage,
    required this.state,
    super.key,
  });

  @override
  _InfiniteScrollGridListState<T> createState() =>
      _InfiniteScrollGridListState<T>();
}

class _InfiniteScrollGridListState<T> extends State<InfiniteScrollGridList<T>> {
  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, T>(
      state: widget.state,
      fetchNextPage: widget.fetchNextPage,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Ensures 2 items per row
        crossAxisSpacing: AppSize.size10,
        mainAxisSpacing: AppSize.size10,
        childAspectRatio: 0.80, // Adjust as needed for item layout
      ),
      builderDelegate: PagedChildBuilderDelegate<T>(
        newPageProgressIndicatorBuilder:
            (context) => Center(child: CustomLoader()),
        firstPageProgressIndicatorBuilder:
            (context) => Center(child: CustomLoader()),
        itemBuilder: widget.itemBuilder,
        firstPageErrorIndicatorBuilder:
            (_) => Center(child: Text("Error loading data")),
        noItemsFoundIndicatorBuilder:
            (_) => Center(child: Text("No items available")),
      ),
    );
  }
}
