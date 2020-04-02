import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:shop_flutter/repository/product_repository.dart';

class Product {
  int productID;
  String sku;
  String name;
  String slug;
  String materials;
  int badge;
  bool availability;
  String avatar;

  double regularPrice;
  double oldPrice;
  double retailPrice;

  List<String> images;

  Product({this.productID});

  String get getCover {
    return avatar;
  }

  final _save = '📌🌻🌸🌼👍👉🎋🐭🍀⭐🌟✨📚';

  getTextCopy({index, hasContent = true}) async{
    String value = index != null ? '$index: ' : '';
    if (CopyController.instance.copySetting.productCode) {
      value += sku;
      if (CopyController.instance.copySetting.productName) {
        value += ' - ';
        value += name + '\n';
      }
    } else {
      if (CopyController.instance.copySetting.productName) {
        value += name + '\n';
      }
    }
    value += '💲 ' +
        Utility.formatPrice(retailPrice + CopyController.instance.copySetting.bonusPrice) +
        ' vnđ\n';
    if (Utility.isNullOrEmpty(materials) == false) {
      value += '🔖 $materials\n';
    }

    /*
    if (hasContent) {
      String _getContent = getContent();
      if (Utility.isNullOrEmpty(_getContent) == false) {
        _getContent = HtmlUnescape().convert(_getContent);
        _getContent = _getContent.replaceAll("<br />", '\n');
        value += '🔖 $_getContent\n';
      }
    }
    if (Utility.isNullOrEmpty(colors) == false) {
      value += '\n📚 Màu: ';
      for (var item in colors) {
        value += item.name + '; ';
      }
    }
    if (Utility.isNullOrEmpty(sizes) == false) {
      value += '\n📚 Size: ';
      for (var item in sizes) {
        value += item.name + '; ';
      }
    }
    */
    if(hasContent){
      String result = await ProductRepository.instance.loadProductAdvertisementContent(productID);
      if(Utility.isNullOrEmpty(result)){
        value += result;
      }
    }

    return value;
  }

  Product.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    sku = json['sku'];
    name = json['name'];
    slug = json['slug'];
    materials = json['materials'];
    badge = json['badge'];
    availability = json['availability'];
    avatar = json['avatar'];
    images = json['images']==null?[]:json['images'].cast<String>();
    regularPrice = json['regularPrice'];
    oldPrice = json['oldPrice'];
    retailPrice = json['retailPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['materials'] = this.materials;
    data['badge'] = this.badge;
    data['availability'] = this.availability;
    data['avatar'] = this.avatar;
    data['images'] = this.images;
    data['regularPrice'] = this.regularPrice;
    data['oldPrice'] = this.oldPrice;
    data['retailPrice'] = this.retailPrice;
    return data;
  }
}

class ProductColor {
  int id;
  String name;

  ProductColor({this.id, this.name});

  ProductColor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ProductThumbnails {
  String size;
  String url;

  ProductThumbnails({this.size, this.url});

  ProductThumbnails.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['url'] = this.url;
    return data;
  }
}

class ProductSize {
  int id;
  String name;

  ProductSize({this.id, this.name});

  ProductSize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ProductSort {
  int id;
  String title;

  ProductSort({this.id, this.title});
}

class ProductBadge {
  int id;
  String title;

  ProductBadge({this.id, this.title});
}

class ProductTag {
  int id;
  String name;
  String slug;

  ProductTag({this.id, this.name, this.slug});

  ProductTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class ProductDiscount {
  String name;
  double price;

  ProductDiscount({this.name, this.price});

  ProductDiscount.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class ProductCarousel {
  String origin;
  String feature;
  String thumbnail;

  ProductCarousel({this.origin, this.feature, this.thumbnail});

  ProductCarousel.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
    feature = json['feature'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['origin'] = this.origin;
    data['feature'] = this.feature;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}