import 'package:shop_flutter/model/utility/app_filter.dart';
import 'package:shop_flutter/provider/utility/config_provider.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigProductUI extends StatelessWidget {
  ConfigProductUI(this.filter);

  final AppFilter filter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ANNColor.white,
        border: Border(
          bottom: BorderSide(width: 2, color: ANNColor.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: _buildSort(context),
            ),
          ),
          _buildIconButton(context, Icons.view_module, ViewType.grid),
          _buildIconButton(context, Icons.view_stream, ViewType.list),
          _buildIconButton(context, Icons.view_day, ViewType.big),
          _buildFilter(context),
        ],
      ),
    );
  }

  _buildIconButton(context, IconData icon, int index) {
    ConfigProvider config = Provider.of(context);

    bool highlight = index == config.view;
    return InkWell(
      onTap: () {
        if (highlight == false) {
          config.view = index;
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlight ? Theme.of(context).primaryColor : ANNColor.white,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: highlight ? ANNColor.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    return InkWell(
      onTap: () {
        showFilterPage(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: ANNColor.white,
          border: Border(
            left: BorderSide(width: 2, color: ANNColor.dividerColor),
          ),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Icon(Icons.filter_list),
            ),
            Text(' Lọc'),
            filter.countSet == 0
                ? Container()
                : Text(
                    ' (${filter.countSet})',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSort(BuildContext context) {
    ConfigProvider config = Provider.of(context);
    if (MediaQuery.of(context).size.width > 350) {
      return DropdownButton<int>(
        value: filter.sort,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        underline: Container(),
        onChanged: (newValue) {
          filter.sort = newValue;
          config.forceUpdate();
        },
        items: ProductRepository.instance.productSorts
            .map<DropdownMenuItem<int>>((sort) {
          return DropdownMenuItem<int>(
            value: sort.id,
            child: Text(sort.title),
          );
        }).toList(),
      );
    } else {
      return PopupMenuButton<int>(
        icon: Icon(Icons.sort),
        onSelected: (newValue) {
          filter.sort = newValue;
          config.forceUpdate();
        },
        itemBuilder: (BuildContext context) => ProductRepository
            .instance.productSorts
            .map<PopupMenuItem<int>>((sort) {
          return PopupMenuItem<int>(
            value: sort.id,
            child: Text(sort.title),
          );
        }).toList(),
      );
    }
  }

  showFilterPage(BuildContext context) {
    Navigator.pushNamed(context, 'product/filter', arguments: filter);
  }
}
