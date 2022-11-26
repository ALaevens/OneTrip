import "package:flutter/material.dart";

enum ListViewState { inUse, changed, inactive }

class PaginationListView extends StatefulWidget {
  final Widget Function(BuildContext context, dynamic data) itemBuilder;
  final Widget Function(BuildContext context, dynamic data) seperatorBuilder;
  final bool? shrinkWrap;
  final ListViewState state;
  final Future<List<dynamic>> Function(int page) dataProvider;

  const PaginationListView(
      {super.key,
      required this.itemBuilder,
      required this.dataProvider,
      required this.state,
      required this.seperatorBuilder,
      this.shrinkWrap});

  @override
  State<PaginationListView> createState() => _PaginationListViewState();
}

class _PaginationListViewState extends State<PaginationListView> {
  int _pagesLoaded = 0;
  List<dynamic> _data = [];
  bool _dataLeft = true;
  bool _isLoading = false;
  ListViewState _state = ListViewState.inactive;
  late ScrollController _scrollController;

  void consumeData() async {
    if (_state != ListViewState.inUse || _isLoading || !_dataLeft) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<dynamic> newData = await widget.dataProvider(_pagesLoaded + 1);
    if (newData[newData.length - 1] == null) {
      newData.removeAt(newData.length - 1);
      _dataLeft = false;
    }

    _pagesLoaded++;

    setState(() {
      _data.addAll(newData);
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _state = widget.state;
  }

  @override
  void didUpdateWidget(covariant PaginationListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _state = widget.state;
    if (_state == ListViewState.changed) {
      _state = ListViewState.inUse;
      _data = [];
      _dataLeft = true;
      _isLoading = false;
      _pagesLoaded = 0;
      consumeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) {
            consumeData();
          }
          return true;
        },
        // child: Scrollbar(
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _data.length,
          shrinkWrap: widget.shrinkWrap ?? false,
          itemBuilder: (context, index) =>
              widget.itemBuilder(context, _data[index]),
          separatorBuilder: (context, index) =>
              widget.seperatorBuilder(context, _data[index]),
        ),
      ),
      // )
    ];

    if (_isLoading) {
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Stack(
      children: stackChildren,
    );
  }
}
