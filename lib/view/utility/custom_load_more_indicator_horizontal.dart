import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CustomLoadMoreIndicatorHorizontal extends StatelessWidget {
  final LoadingMoreBase listSourceRepository;
  final IndicatorStatus status;

  CustomLoadMoreIndicatorHorizontal(this.listSourceRepository, this.status);

  @override
  Widget build(BuildContext context) {
    bool isSliver = true;

    Widget widget;
    switch (status) {
      case IndicatorStatus.loadingMoreBusying:
        widget = Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Indicator(),
        );
        widget = _setBackGround(false, widget, 35.0);
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Indicator(),
        );
        widget = _setBackGround(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Icon(Icons.error, size: 25));
        widget = _setBackGround(false, widget, 35.0);

        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Icon(Icons.error, size: 25));
        widget = _setBackGround(true, widget, double.infinity);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = SizedBox(width: 15,);
        break;
      case IndicatorStatus.empty:
        widget = Container();
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        }
        break;
      default:
        widget = Container(height: 0.0);
        break;
    }
    return widget;
  }

  Widget _setBackGround(bool full, Widget widget, double height,
      {BuildContext context}) {
    widget = ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: context != null
              ? MediaQuery.of(context).size.height - 140
              : height),
      child: Container(
        child: widget,
        color: Colors.transparent,
        alignment: Alignment.center,
      ),
    );
    return widget;
  }
}
