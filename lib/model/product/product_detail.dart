import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product.dart';

class ProductDetail extends Product {
  String categoryName;
  String categorySlug;
  List<ProductColor> colors;
  List<ProductSize> sizes;
  List<ProductTag> tags;
  List<ProductDiscount> discounts;
  List<ProductCarousel> carousel;
  String content;
  List<String> contentImages;

  ProductDetail({this.content});

  String getContent() {
    return this
        .content
        .replaceAllMapped(RegExp(r"<img[\w\W]+?>"), (match) => '');
  }

  ProductDetail.fromProduct(Product product) {
    productID = product.productID;
    sku = product.sku;
    name = product.name;
    slug = product.slug;
    materials = product.materials;
    badge = product.badge;
    availability = product.availability;
    avatar = product.avatar;
    regularPrice = product.regularPrice;
    oldPrice = product.oldPrice;
    retailPrice = product.retailPrice;
    images = product.images;
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    Product _product = Product.fromJson(json);
    ProductDetail _detail = ProductDetail.fromProduct(_product);
    // _detail
    _detail.categoryName = json['categoryName'];
    _detail.categorySlug = json['categorySlug'];
    if (json['colors'] != null) {
      _detail.colors = new List<ProductColor>();
      json['colors'].forEach((v) {
        _detail.colors.add(new ProductColor.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      _detail.sizes = new List<ProductSize>();
      json['sizes'].forEach((v) {
        _detail.sizes.add(new ProductSize.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      _detail.tags = new List<ProductTag>();
      json['tags'].forEach((v) {
        _detail.tags.add(new ProductTag.fromJson(v));
      });
    }
    if (json['discounts'] != null) {
      _detail.discounts = new List<ProductDiscount>();
      json['discounts'].forEach((v) {
        _detail.discounts.add(new ProductDiscount.fromJson(v));
      });
    }
    if (json['carousel'] != null) {
      _detail.carousel = new List<ProductCarousel>();
      json['carousel'].forEach((v) {
        _detail.carousel.add(new ProductCarousel.fromJson(v));
      });
    }
    if(Utility.isNullOrEmpty(_detail.carousel)){
      _detail.carousel=[ProductCarousel(origin: '', feature: '', thumbnail: '')];
    }

    _detail.content = json['content'] ?? '';
    List<RegExpMatch> matches =
        RegExp(r"/uploads[\w\W]+?.jpg|/uploads[\w\W]+?.png")
            .allMatches(_detail.content)
            .toList();
    if (Utility.isNullOrEmpty(matches) == false) {
      _detail.contentImages = new List();
      matches.forEach((f) {
        String srcImage = f.group(0);
        if (Utility.isNullOrEmpty(srcImage) == false) {
          _detail.contentImages.add(srcImage);
        }
      });
    }
    return _detail;
  }

  Product toProduct(){
    Map map = toJson();
    return Product.fromJson(map);
  }
}
