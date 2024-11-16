import 'package:freezed_annotation/freezed_annotation.dart';

import '../category.dart';

class CategoryConverter implements JsonConverter<Category, String> {
  const CategoryConverter();

  @override
  Category fromJson(String json) {
    var category = Category.values.where((c) => c.val == json).firstOrNull;
    return category ?? Category.unlisted;
  }

  @override
  String toJson(Category category) {
    return category.val;
  }
}
