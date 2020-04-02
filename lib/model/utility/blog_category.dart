class BlogCategory {
  String name;
  String icon;
  String description;
  BlogCategoryFilter filter;
  List<BlogCategory> children;

  BlogCategory(
      {this.name, this.icon, this.description, this.filter, this.children});

  BlogCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    filter =
    json['filter'] != null ? new BlogCategoryFilter.fromJson(json['filter']) : BlogCategoryFilter();
    if (json['children'] != null) {
      children = new List<BlogCategory>();
      json['children'].forEach((v) {
        children.add(new BlogCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlogCategoryFilter {
  String categorySlug;

  BlogCategoryFilter({this.categorySlug});

  BlogCategoryFilter.fromJson(Map<String, dynamic> json) {
    categorySlug = json['categorySlug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categorySlug'] = this.categorySlug;
    return data;
  }

  BlogCategoryFilter.clone(BlogCategoryFilter filter) {
    categorySlug = filter.categorySlug;
  }

  bool compare(BlogCategoryFilter _other) {
    if (_other == null) {
      return false;
    }
    if (categorySlug != _other.categorySlug) {
      return false;
    }
    return true;
  }
}
