import 'dart:math';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/utility/app_filter.dart';
import 'package:shop_flutter/provider/utility/config_provider.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFilterView extends StatefulWidget {
  ProductFilterView(this.filter);

  final filter;

  @override
  _ProductFilterViewState createState() => _ProductFilterViewState(filter);
}

class _ProductFilterViewState extends State<ProductFilterView> {
  _ProductFilterViewState(this.filter);

  AppFilter filter;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context, filter);
            },
          ),
          title: Text('Lọc sản phẩm theo?'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    int _count = filter.countSet;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Giá sản phẩm: ',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                TextSpan(
                  text: getTextMinMax((filter.priceMin / 1000).round(),
                      (filter.priceMax / 1000).round()),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                )
              ]),
            ),
            SizedBox(height: 10),
            _buildPriceRecommendWrap(),
            _buildSliderRangePrice(),
            SizedBox(height: 10),
            Text(
              'Sản phẩm:',
              style: Theme.of(context).textTheme.subtitle,
            ),
            Column(
              children: ProductRepository.instance.productBadge
                  .map((item) => _buildCheckBoxBadge(item))
                  .toList(),
            ),
            _count == 0
                ? Container()
                : FlatButton(
                    child: Text(
                      'Xoá bộ lọc ($_count)',
                      style: Theme.of(context).textTheme.button.merge(
                            TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                    ),
                    onPressed: () {
                      setState(() {
                        filter.priceMin = 0;
                        filter.priceMax = 0;
                        filter.badge = 0;
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBoxBadge(ProductBadge badge) {
    ConfigProvider provider = Provider.of(context);
    bool isChoose = badge.id == filter.badge;
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: isChoose
                ? Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.radio_button_unchecked),
            onPressed: () {
              setState(() {
                if (isChoose) {
                  filter.badge = 0;
                } else {
                  filter.badge = badge.id;
                }
              });
            },
          ),
          Text(badge.title),
        ],
      ),
    );
  }

  /// Price
  String getTextMinMax(int _min, int _max) {
    String _text = _min <= 0 && _max <= 0
        ? ''
        : _min <= 0
            ? 'Dưới ${_max}k'
            : _max == 0 ? 'Trên ${_min}k' : 'Từ ${_min}k - ${_max}k';
    return _text;
  }

  _buildPriceRecommendWrap() {
    return Wrap(
      children: <Widget>[
        _buildPriceRecommendItem(0, 50),
        SizedBox(width: 5),
        _buildPriceRecommendItem(50, 80),
        SizedBox(width: 5),
        _buildPriceRecommendItem(80, 100),
        SizedBox(width: 5),
        _buildPriceRecommendItem(100, 120),
        SizedBox(width: 5),
        _buildPriceRecommendItem(120, 150),
        SizedBox(width: 5),
        _buildPriceRecommendItem(150, 180),
        SizedBox(width: 5),
        _buildPriceRecommendItem(180, 0),
      ],
    );
  }

  _buildPriceRecommendItem(int min, int max) {
    int priceMin = min * 1000;
    int priceMax = max * 1000;
    bool isChoose = filter.priceMin == priceMin && filter.priceMax == priceMax;
    Color _color = isChoose ? Theme.of(context).primaryColor : Colors.black87;
    return ActionChip(
      avatar: Icon(
        Icons.attach_money,
        color: _color,
      ),
      label: Text(
        getTextMinMax(min, max),
        style: TextStyle(color: _color),
      ),
      onPressed: () {
        setState(() {
          filter.priceMin = priceMin;
          filter.priceMax = priceMax;
        });
      },
    );
  }

  Widget _buildSliderRangePrice() {
    ConfigProvider provider = Provider.of(context);
    double _min = (filter.priceMin / 1000).round().toDouble();
    double _max = (filter.priceMax / 1000).round().toDouble();
    if (_max <= 0 || _max > 201) {
      _max = 201;
    }
    if (_min >= _max) {
      _min = _max - 3;
    }

    return SliderTheme(
      data: SliderThemeData(showValueIndicator: ShowValueIndicator.always),
      child: RangeSlider(
        min: 0,
        max: 201,
        values: RangeValues(_min, _max),
        onChanged: (newValue) {
          setState(() {
            int _newMin = newValue.start.round();
            int _newMax = newValue.end.round();
            if ((_newMax - _newMin) >= 2) {
              filter.priceMin = (_newMin * 1000).round();
              filter.priceMax = (_newMax > 200 ? 0 : _newMax * 1000).round();
            } else {
              if (_min == _newMin) {
                var end = _newMin + 3;
                filter.priceMax = end > 200 ? 0 : end * 1000;
              } else {
                filter.priceMin = min(0, ((_newMax - 3) * 100).round());
              }
            }
          });
        },
        onChangeStart: (newValue) {},
        onChangeEnd: (newValue) {},
      ),
    );
  }
}
