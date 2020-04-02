import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/ui/utility/ask_login.dart';
import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CustomLoadMoreIndicator extends StatelessWidget {
  final LoadingMoreBase listSourceRepository;
  final IndicatorStatus status;
  final noMoreLoadText;
  final emptyText;

  CustomLoadMoreIndicator(this.listSourceRepository, this.status,
      {this.noMoreLoadText = 'Đã hiển thị tất cả sản phẩm',
      this.emptyText = 'Không tìm thấy sản phẩm nào'});

  @override
  Widget build(BuildContext context) {
    bool isSliver = true;

    Widget widget;
    switch (status) {
      case IndicatorStatus.loadingMoreBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7.0),
              height: 15.0,
              width: 15.0,
              child: Indicator(),
            ),
            Text('Đang tải..') // load more item when scroll position at bottom
          ],
        );
        widget = _setBackGround(false, widget, 35.0);
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7.0),
              height: 30.0,
              width: 30.0,
              child: Indicator(),
            ),
            Text('Đang tải..') // load more item when scroll position at bottom
          ],
        );
        widget = _setBackGround(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error, size: 25),
              Text(
                AccountController.instance.isLogin
                    ? "Có lỗi xảy ra, chạm để thử lại..."
                    : "Bạn cần đăng nhập hoặc đăng ký để xem thêm sản phẩm!",
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
        widget = _setBackGround(false, widget, 35.0);

        widget = GestureDetector(
          onTap: () {
            if (AccountController.instance.isLogin) {
              listSourceRepository.errorRefresh();
            } else {
              AskLogin.show(context,
                  message:
                      'Vui lòng đăng nhập hoặc đăng ký để xem thêm sản phẩm');
            }
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = SomethingWentWrong();
        widget = _setBackGround(true, widget, double.infinity);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Text(noMoreLoadText);
        widget = _setBackGround(false, widget, 60.0);
        break;
      case IndicatorStatus.empty:
        widget = EmptyListUI(
          body: emptyText,
        );
        widget =
            _setBackGround(true, widget, double.infinity, context: context);

        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
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

class CommonSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  CommonSliverPersistentHeaderDelegate(this.child, this.height);

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonSliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
