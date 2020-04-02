import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/utility/coupon_provider.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/ui/coupon/promotion_item.dart';
import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPromotionTap extends StatefulWidget {
  @override
  _AllPromotionTapState createState() => _AllPromotionTapState();
}

class _AllPromotionTapState extends State<AllPromotionTap> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildData(),
        ],
      ),
    );
  }

  Widget _buildData() {
    final CouponProvider provider = Provider.of(context);

    if (provider.promotions.isLoading) {
      return SliverFillRemaining(
          child: Center(
        child: Indicator(),
      ));
    } else if (provider.promotions.isError) {
      return SliverFillRemaining(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: SomethingWentWrong(
                onReload: _reload,
              )));
    } else {
      if (Utility.isNullOrEmpty(provider.promotions.data)) {
        return const SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: EmptyListUI(
              title: 'Không có khuyến mãi nào',
              body:
                  'Các khuyến mãi mới nhất của bạn sẽ được cập nhật liên tục tại đây.',
            ),
          ),
        );
      } else {
        return SliverPadding(
          padding: EdgeInsets.all(defaultPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return PromotionItem(provider.promotions.data[index]);
            }, childCount: provider.promotions.data.length),
          ),
        );
      }
    }
  }

  Future _reload() async {
    await UserController.instance.refreshToken(context);
    await Provider.of<CouponProvider>(context, listen: false)
        .loadListPromotion();
  }
}
