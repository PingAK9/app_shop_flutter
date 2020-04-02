import 'dart:core';

import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/blog_category.dart';
import 'package:shop_flutter/provider/response_provider.dart';
import 'package:shop_flutter/repository/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogProvider with ChangeNotifier {
  ResponseProvider<List<BlogCategory>> category;
  BlogCategory _currentCategory;

  BlogCategory get currentCategory => _currentCategory;

  set currentCategory(BlogCategory currentCategory) {
    _currentCategory = currentCategory;
    notifyListeners();
  }

  BlogProvider() {
    // init
    category = ResponseProvider();
    fetchBlog();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkReload() {
    if (category.isLoading == false) {
      if (category.isLoadFinish() == false) {
        fetchBlog();
      }
    }
  }

  fetchBlog() async {
    try {
      category.loading = 'loading';
      notifyListeners();
      var data = await BlogRepository.instance.loadCategoryBlog();
      if (data == null) {
        category.error = 'load error';
      } else {
        if (Utility.isNullOrEmpty(data) == false) {
          _currentCategory = data[0];
        }
        category.completed = data;
      }
    } catch (e) {
      print(e);
      category.error = 'Error exception' + e.toString();
    }
    notifyListeners();
  }
}
