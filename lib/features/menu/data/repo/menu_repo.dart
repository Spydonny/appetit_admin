import 'dart:convert';
import 'package:appetit_admin/core/core.dart';
import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/menu_item.dart';

class MenuRepo {
  final String baseUrl;
  final http.Client client;

  MenuRepo({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${getIt<TokenNotifier>().token}",
  };

  // ------------------- PUBLIC -------------------
  Future<List<Category>> getCategories({String lc = "en"}) async {
    final response = await client.get(
      Uri.parse("$baseUrl/menu/categories?lc=$lc"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<List<MenuItem>> getItems({
    int? categoryId,
    String? search,
    bool? active,
    String lc = "en",
  }) async {
    final query = {
      if (categoryId != null) "category_id": "$categoryId",
      if (search != null) "search": search,
      if (active != null) "active": "$active",
      "lc": lc,
    };

    final uri = Uri.parse("$baseUrl/menu/items").replace(queryParameters: query);

    final response = await client.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => MenuItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load items");
    }
  }

  Future<MenuItem> getItem(int id, {String lc = "en"}) async {
    final response = await client.get(
      Uri.parse("$baseUrl/menu/items/$id?lc=$lc"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load item");
    }
  }

  // ------------------- ADMIN -------------------

  /// Create category
  Future<Category> createCategory(Map<String, dynamic> payload) async {
    final response = await client.post(
      Uri.parse("$baseUrl/menu/categories"),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create category: ${response.body}");
    }
  }

  /// Update category
  Future<Category> updateCategory(int id, Map<String, dynamic> payload) async {
    final response = await client.put(
      Uri.parse("$baseUrl/menu/categories/$id"),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update category: ${response.body}");
    }
  }

  /// Delete category
  Future<void> deleteCategory(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/menu/categories/$id"),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete category: ${response.body}");
    }
  }

  /// Create menu item
  Future<MenuItem> createMenuItem(Map<String, dynamic> payload) async {
    payload.addAll({
      "is_active": true,
      "is_available": true,
    });

    final response = await client.post(
      Uri.parse("$baseUrl/menu/items"),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create menu item: ${response.body}");
    }
  }

  /// Update menu item
  Future<MenuItem> updateMenuItem(int id, Map<String, dynamic> payload) async {
    final response = await client.put(
      Uri.parse("$baseUrl/menu/items/$id"),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update menu item: ${response.body}");
    }
  }

  /// Delete menu item
  Future<void> deleteMenuItem(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/menu/items/$id"),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete menu item: ${response.body}");
    }
  }

  /// Upload image
  Future<String> uploadImage(String filePath) async {
    final request =
    http.MultipartRequest("POST", Uri.parse("$baseUrl/menu/images/upload"));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath("file", filePath));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(body);
      return data["image_url"] as String;
    } else {
      throw Exception("Failed to upload image: $body");
    }
  }

  /// Update item image
  Future<MenuItem> updateMenuItemImage(int itemId, String filePath) async {
    final request = http.MultipartRequest(
        "PUT", Uri.parse("$baseUrl/menu/items/$itemId/image"));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath("file", filePath));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(body));
    } else {
      throw Exception("Failed to update menu item image: $body");
    }
  }

  /// Remove item image
  Future<void> removeMenuItemImage(int itemId) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/menu/items/$itemId/image"),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to remove menu item image: ${response.body}");
    }
  }
}

