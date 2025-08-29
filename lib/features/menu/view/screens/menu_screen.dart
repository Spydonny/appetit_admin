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
  final List<Category> _categories = [
    Category(
      id: 10,
      name: 'Комбо',
      sort: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 11,
      name: 'Блюда',
      sort: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 12,
      name: 'Закуски',
      sort: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Category(
      id: 13,
      name: 'Соусы',
      sort: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final Map<int, List<MenuItem>> _items = {
    10: [
      MenuItem(
        id: 100,
        name: 'Пепси с фри',
        price: 598,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/fries_pepsi.jpg",
      ),
    ],
    11: [
      MenuItem(
        id: 110,
        name: "Шаурма куриная",
        price: 378,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/shaurm_chick.jpg",
      ),
      MenuItem(
        id: 111,
        name: "Шаурма классическая",
        price: 438,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/shaurm_class.jpg",
      ),
      MenuItem(
        id: 112,
        name: "Шаурма с сыром",
        price: 498,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/shaurm_cheese.jpg",
      ),
      MenuItem(
        id: 113,
        name: "Донер",
        price: 698,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/doner.jpg",
      ),
      MenuItem(
        id: 114,
        name: "Чебуреки (2 шт)",
        price: 358,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/chebureki.jpg",
      ),
    ],
    12: [
      MenuItem(
        id: 120,
        name: "Картофель фри",
        price: 258,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/fries.jpg",
      ),
    ],
    13: [
      MenuItem(
        id: 130,
        name: "Сырный соус",
        price: 98,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/sauce_cheese.jpg",
      ),
      MenuItem(
        id: 131,
        name: "Чесночный соус",
        price: 98,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/sauce_garlic.jpg",
      ),
      MenuItem(
        id: 132,
        name: "Острый соус",
        price: 98,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/sauce_spicy.jpg",
      ),
      MenuItem(
        id: 133,
        name: "Томатный соус",
        price: 98,
        isActive: true,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: "$baseUrl/upload/sauce_tomato.jpg",
      ),
    ],
  };
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
        _categories.addAll(cats);
        _items.addAll(itemsMap);
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
                        child: Text(cat.name),
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
                          cat.name,
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
                        name: item.name,
                        price: item.price,
                        imageUrl: item.imageUrl ?? '',
                        description: item.descriptionTranslations?[lcl] ?? '',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.9,
                                child: SingleChildScrollView(
                                  child: DishContainer(
                                    imageUrl: item.imageUrl ?? '',
                                    name: (item.nameTranslations?[lcl] ?? item.name),
                                    price: item.price,
                                    description: item.descriptionTranslations?[lcl] ?? "",
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


