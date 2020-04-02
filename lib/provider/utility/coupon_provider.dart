import 'package:shop_flutter/model/utility/coupon.dart';
import 'package:shop_flutter/model/utility/promotion.dart';
import 'package:shop_flutter/provider/response_provider.dart';
import 'package:shop_flutter/repository/coupon_repository.dart';
import 'package:flutter/material.dart';

class CouponProvider extends ChangeNotifier {
  CouponProvider() {
    loadListPromotion();
    loadMyCoupon();
  }

  ResponseProvider<List<Coupon>> myCoupons = ResponseProvider();
  ResponseProvider<List<Promotion>> promotions = ResponseProvider();

  Future loadMyCoupon() async {
    try {
      myCoupons.loading = 'try load categories';
      notifyListeners();
      final data = await CouponRepository.instance.loadMyCoupon();
      if (data != null) {
        myCoupons.completed = data;
        notifyListeners();
        return;
      }
    } catch (e) {
      print(e);
    }
    myCoupons.error = 'Load fail';
    notifyListeners();
  }

  Future loadListPromotion() async {
    try {
      promotions.loading = 'try load categories';
      notifyListeners();
      final data = await CouponRepository.instance.loadListPromotion();
      if (data != null) {
        promotions.completed = data;
        notifyListeners();
        return;
      }
    } catch (e) {
      print(e);
    }
    promotions.error = 'Load fail';
    notifyListeners();
  }
}
