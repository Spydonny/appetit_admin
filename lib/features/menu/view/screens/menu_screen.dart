import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/core.dart';
import '../../data/models/category.dart';
import '../../data/models/menu_item.dart';
import '../../services/menu_services.dart';
import '../widgets/widgets.dart';

const lcl = 'ru';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();

  late final MenuService _menuService;
  List<Category> _categories = [];
  Map<int, List<MenuItem>> _items = {};
  final Set<int> _collapsedCategories = {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _menuService = getIt<MenuService>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final cats = await _menuService.fetchCategories();
      final itemsMap = <int, List<MenuItem>>{};
      for (final cat in cats) {
        itemsMap[cat.id] = await _menuService.fetchItems(categoryId: cat.id);
      }
      setState(() {
        _categories = cats;
        _items = itemsMap;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addCategory() async {
    String newCat = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Добавить категорию"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Название категории"),
            onChanged: (val) => newCat = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newCat.isNotEmpty) {
                  final cat = await _menuService.createCategory({
                    "name": newCat,
                    "order": 0
                  });
                  setState(() {
                    _categories.add(cat);
                    _items[cat.id] = [];
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Добавить"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addItem(Category category) async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Добавить ${category.nameTranslations![lcl]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Название")),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Цена"), keyboardType: TextInputType.number),
              TextField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: "Описание")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
            ElevatedButton(
              onPressed: () async {
                final newItem = await _menuService.createMenuItem({
                  "category_id": category.id,
                  "name": nameCtrl.text,
                  "description": descriptionCtrl.text,
                  "price": double.tryParse(priceCtrl.text) ?? 0,
                });
                setState(() {
                  _items[category.id]!.add(newItem);
                });
                Navigator.pop(context);
              },
              child: const Text("Добавить"),
            ),
          ],
        );
      },
    );
  }

  void _toggleCollapse(Category category) {
    setState(() {
      if (_collapsedCategories.contains(category.id)) {
        _collapsedCategories.remove(category.id);
      } else {
        _collapsedCategories.add(category.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // 🔹 Кнопки категорий
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          final index = _categories.indexOf(cat);
                          _itemScrollController.scrollTo(
                            index: index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: Text(cat.nameTranslations![lcl] ?? cat.name),
                      ),
                    );
                  }),
                  OutlinedButton.icon(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add),
                    label: const Text("Категория"),
                  )
                ],
              ),
            ),
          ),
        ),

        // 🔹 Список категорий + блюд
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final collapsed = _collapsedCategories.contains(cat.id);
              final items = _items[cat.id] ?? [];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cat.nameTranslations![lcl] ?? cat.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _toggleCollapse(cat),
                          icon: Icon(collapsed ? Icons.expand_more : Icons.expand_less),
                        ),
                      ],
                    ),
                    if (!collapsed) ...[
                      const SizedBox(height: 12),
                      ...items.map((item) => DishContainerShortcut(
                        name: item.nameTranslations![lcl] ?? item.name,
                        price: item.price,
                        assetImage: AppIcons.logoAppetite,
                        description: item.descriptionTranslations![lcl] ?? 'Описание отсутсвует',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.9,
                                child: SingleChildScrollView(
                                  child: DishContainer(
                                    image: AppIcons.logoAppetite,
                                    name: (item.nameTranslations![lcl] ?? item.name),
                                    price: item.price,
                                    description: item.descriptionTranslations![lcl] ?? "Не указан",
                                    additions: [],
                                    reductions: [],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                      _buildAddSection(cat),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddSection(Category category) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _addItem(category),
        child: Container(
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Добавить',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}


