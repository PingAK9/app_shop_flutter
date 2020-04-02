import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatefulWidget {
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Focus the keyboard when open the search page
    final provider = Provider.of<SearchProvider>(context);

    if (provider.openKeyboard) {
      FocusScope.of(context).requestFocus(provider.focusNode);
    } else {
      provider.focusNode.unfocus();
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: ANNColor.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: TextField(
          controller: provider.controller,
          focusNode: provider.focusNode,
          style: Theme.of(context).textTheme.body1,
          cursorColor: Colors.black87,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              icon: Icon(
                AppIcons.search,
                size: 20,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .merge(TextStyle(fontStyle: FontStyle.italic)),
              hintText: 'Tên sản phẩm, Mã sản phẩm...'),
          onSubmitted: (text) {
            final searchProvider =
                Provider.of<SearchProvider>(context, listen: false);
            final strSearch = searchProvider.controller.text;

            searchProvider.onSearch(context, strSearch);
          }),
    );
  }
}
