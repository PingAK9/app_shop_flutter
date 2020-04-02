import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/utility/coupon_provider.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/ui/coupon/coupon_item.dart';
import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCouponTap extends StatefulWidget {
  @override
  _MyCouponTapState createState() => _MyCouponTapState();
}

class _MyCouponTapState extends State<MyCouponTap> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          ..._buildData(),
        ],
      ),
    );
  }

  List<Widget> _buildData() {
    final CouponProvider provider = Provider.of(context);

    if (provider.myCoupons.isLoading) {
      return [
        SliverFillRemaining(
            child: Center(
          child: Indicator(),
        ))
      ];
    } else if (provider.myCoupons.isError) {
      return [
        SliverFillRemaining(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: SomethingWentWrong(
                  onReload: _reload,
                )))
      ];
    } else {
      if (Utility.isNullOrEmpty(provider.myCoupons.data)) {
        return const [
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: EmptyListUI(
                title: 'Bạn không có mã khuyến mãi nào',
                body:
                    'Đứng lo lắng, ANN sẽ sớm cập nhật thêm nhiều chương trình khuyến mại tại đây.',
              ),
            ),
          )
        ];
      } else {
        return [
          SliverPadding(
            padding: EdgeInsets.all(defaultPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return CouponItem(provider.myCoupons.data[index]);
              }, childCount: provider.myCoupons.data.length),
            ),
          ),
          const SliverFillRemaining(),
        ];
      }
    }
  }

  Future _reload() async {
    await UserController.instance.refreshToken(context);
    await Provider.of<CouponProvider>(context, listen: false).loadMyCoupon();
  }
}
