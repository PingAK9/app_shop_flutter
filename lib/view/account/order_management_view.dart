import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:flutter/material.dart';

class OrderManagementView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyListUI(
          title: 'Bạn chưa có hoá đơn nào',
          body: 'Các hoá đơn mới nhất của bạn sẽ được cập nhật liên tục tại đây.',
        ),
      ),
    );
  }
}
