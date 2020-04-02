import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/promotion.dart';
import 'package:shop_flutter/provider/utility/coupon_provider.dart';
import 'package:shop_flutter/repository/coupon_repository.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/app_popup.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class PromotionItem extends StatefulWidget {
  const PromotionItem(this.data);

  final Promotion data;

  @override
  _PromotionItemState createState() => _PromotionItemState();
}

class _PromotionItemState extends State<PromotionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _receivePromotion,
      child: Card(
        child: ListTile(
          title: Text(widget.data.name),
          leading: Icon(MaterialCommunityIcons.ticket_percent),
        ),
      ),
    );
  }

  void _receivePromotion() {
    AppPopup.showBottomSheet(context, content: [
      AvatarGlow(
        endRadius: 50,
        duration: const Duration(milliseconds: 1000),
        glowColor: Theme.of(context).primaryColor,
        child: Icon(
          MaterialCommunityIcons.ticket_percent,
          size: 50,
          color: Theme.of(context).primaryColor,
        ),
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: 'Nhận mã khuyến mãi ',
              style: Theme.of(context).textTheme.body1),
          TextSpan(
              text: '\"${widget.data.name}\"',
              style: Theme.of(context).textTheme.body2),
        ]),
      ),
      const SizedBox(height: 15),
      CenterButtonPopup(
        normal: ButtonData('Để sau'),
        highlight: ButtonData('Nhận', onPressed: _submit),
      ),
    ]);
  }

  Future _submit() async {
    var loadingDialog = new LoadingDialog(context, message: 'Đang xử lý...');

    loadingDialog.show();
    final _result =
        await CouponRepository.instance.receiveCoupon(widget.data.code);
    loadingDialog.close();

    if (Utility.isNullOrEmpty(_result)) {
      await AppPopup.showCustomDialog(context, content: [
        AvatarGlow(
          endRadius: 40,
          duration: const Duration(milliseconds: 1000),
          glowColor: Theme.of(context).primaryColor,
          child: Icon(
            MaterialCommunityIcons.ticket_percent,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: 'Chúc mừng bạn đã nhận được mã khuyến mãi ',
                style: Theme.of(context).textTheme.body1),
            TextSpan(
                text: widget.data.code,
                style: Theme.of(context).textTheme.subtitle),
            TextSpan(
                text:
                    ' \"${widget.data.name}\". Hạn sử dụng đến ngày ${Utility.fixFormatDate(widget.data.endDate)}',
                style: Theme.of(context).textTheme.body1),
          ]),
        ),
        CenterButtonPopup(
          highlight: ButtonData('Đóng'),
        )
      ]);
      Provider.of<CouponProvider>(context, listen: false).loadMyCoupon();
      Provider.of<CouponProvider>(context, listen: false).loadListPromotion();
    } else {
      AppSnackBar.showFlushbar(context, _result);
    }
  }
}
