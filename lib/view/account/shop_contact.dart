import 'dart:io';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/repository/utility_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopContact extends StatefulWidget {
  @override
  _ShopContactState createState() => _ShopContactState();
}

class _ShopContactState extends State<ShopContact> {
  final styleTitle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87);

  final styleBody = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87);

  final styleLink = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin liên hệ'),
      ),
      body: FutureProvider<Map>(
          create: (_) => UtilityRepository.instance.loadContact(),
          child: Consumer<Map>(
            builder: (key, Map data, child) {
              if (data == null) {
                return Indicator();
              } else {
                final urlMap = data['urlMap'];
                final urlFB = data['urlFB'];
                final urlWebsite = data['urlWebsite'];
                final address = data['address'];
                final timeWork = data['timeWork'];
                final List<String> phones =
                    data['phone'] == null ? [] : data['phone'].cast<String>();

                List<Widget> children = [
                  _buildTitle('Địa chỉ', Icons.location_on)
                ];
                if (Utility.isNullOrEmpty(address) == false) {
                  children.add(_buildSubMenu(address));
                }
                if (Utility.isNullOrEmpty(urlMap) == false) {
                  children.add(_buildSubLink('Xem trên bản đồ', onTap: () {
                    launch(urlMap);
                  }));
                }
                children.add(_buildTitle('Website', Icons.web));
                if (Utility.isNullOrEmpty(urlWebsite) == false) {
                  children.add(_buildSubLink(urlWebsite, onTap: () {
                    launch(urlWebsite);
                  }));
                }
                if (Utility.isNullOrEmpty(urlFB) == false) {
                  children.add(_buildSubLink('Xem Facebook', onTap: () {
                    launch(urlFB);
                  }));
                }
                if (Utility.isNullOrEmpty(phones) == false) {
                  children.add(_buildTitle('Zalo/Điện thoại', Icons.phone));
                  children.addAll(
                    phones
                        .map((item) => _buildSubLink(item, onTap: () {
                              _callPhone(item);
                            }))
                        .toList(),
                  );
                }
                if (Utility.isNullOrEmpty(timeWork) == false) {
                  children.add(
                      _buildTitle('Thời gian làm việc', Icons.access_time));
                  children.add(_buildSubMenu(timeWork));
                }
                children.add(SizedBox(height: 20));

                return ListView(
                  children: children,
                );
              }
            },
          )),
    );
  }

  Widget _buildTitle(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        border:
            Border(top: BorderSide(width: 1, color: ANNColor.dividerColor)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        contentPadding: EdgeInsets.all(0),
        dense: false,
        isThreeLine: false,
        title: Text(
          title,
          style: styleTitle,
        ),
      ),
    );
  }

  Widget _buildSubMenu(String item,
      {GestureTapCallback onTap, Widget leading}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: leading == null ? 15 : 0),
        dense: true,
        leading: leading,
        title: Text(
          item,
          style: styleBody,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSubLink(String item,
      {GestureTapCallback onTap, Widget leading}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: leading == null ? 15 : 0),
        dense: true,
        leading: leading,
        title: Text(
          item,
          style: styleLink,
        ),
        onTap: onTap,
      ),
    );
  }

  _callPhone(phoneNumber) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: ANNColor.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            padding: EdgeInsets.fromLTRB(15, 30, 15, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (Platform.isIOS) {
                        launch("tel:/$phoneNumber");
                      } else {
                        launch("tel:$phoneNumber");
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Icon(
                              Icons.phone,
                              color: ANNColor.white,
                              size: 30,
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Điện thoại'),
                      ],
                    )),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                    onTap: () {
                      launch("https://zalo.me/$phoneNumber");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Image.asset(
                                  'assets/images/ui/zalo-logo.png')),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Zalo'),
                      ],
                    ))
              ],
            ),
          );
        });
  }
}
