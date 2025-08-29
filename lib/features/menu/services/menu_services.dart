import '../data/data.dart';

class MenuService {
  final MenuRepo repo;

  MenuService(this.repo);

  // ------------------- PUBLIC -------------------
  Future<List<Category>> fetchCategories({String locale = "ru"}) {
    return repo.getCategories(lc: locale);
  }

  Future<List<MenuItem>> fetchItems({
    int? categoryId,
    String? search,
    bool? active,
    String locale = "ru",
  }) {
    return repo.getItems(
      categoryId: categoryId,
      search: search,
      active: active,
      lc: locale,
    );
  }

  Future<MenuItem> fetchItem(int id, {String locale = "ru"}) {
    return repo.getItem(id, lc: locale);
  }

  // ------------------- ADMIN -------------------
  Future<Category> createCategory(Map<String, dynamic> payload) {
    return repo.createCategory(payload);
  }

  Future<Category> updateCategory(int id, Map<String, dynamic> payload) {
    return repo.updateCategory(id, payload);
  }

  Future<void> deleteCategory(int id) {
    return repo.deleteCategory(id);
  }

  Future<MenuItem> createMenuItem(Map<String, dynamic> payload) {
    return repo.createMenuItem(payload);
  }

  Future<MenuItem> updateMenuItem(int id, Map<String, dynamic> payload) {
    return repo.updateMenuItem(id, payload);
  }

  Future<void> deleteMenuItem(int id) {
    return repo.deleteMenuItem(id);
  }

  Future<String> uploadImage(String filePath) {
    return repo.uploadImage(filePath);
  }

  Future<MenuItem> updateMenuItemImage(int itemId, String filePath) {
    return repo.updateMenuItemImage(itemId, filePath);
  }

  Future<void> removeMenuItemImage(int itemId) {
    return repo.removeMenuItemImage(itemId);
  }
}
