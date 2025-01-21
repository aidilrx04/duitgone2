import 'dart:convert';

import 'package:duitgone2/data/repositories/category/category_repository.dart';
import 'package:duitgone2/data/services/local_file_service.dart';
import 'package:duitgone2/models/category/category.dart';

class CategoryRepositoryLocal implements CategoryRepository {
  CategoryRepositoryLocal({required LocalFileService localFileService})
      : _localFileService = localFileService;

  final LocalFileService _localFileService;

  @override
  Future<Category> createCategory(Category category) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getCategories() async {
    final filename = "categories.json";

    final content = await _localFileService.readDocument(filename);

    if (content == null) return [];

    final decode = jsonDecode(content) as List;
    final result = decode.map((el) => Category.fromJson(el)).toList();

    return result;
  }
}
