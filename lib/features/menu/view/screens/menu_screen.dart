import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/theme/app_icons.dart';
import '../widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<String> categories = ['dishes', 'snacks', 'sauces', 'drinks'];

  final Map<String, List<String>> _items = {};
  final Set<String> collapsedCategories = {};

  // 🔹 контроллеры scrollable_positioned_list
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
  ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    _items.addAll({
      'dishes': ['Burger 0', 'Burger 1'],
      'snacks': ['Fries 0'],
      'sauces': ['Sauce 0'],
      'drinks': ['Cola 0'],
    });
  }

  void _scrollToCategory(String category) {
    final index = categories.indexOf(category);
    if (index == -1) return;

    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _addItem(String category) async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Добавить ${tr(category)}"),
              content: SizedBox(
                width: 400,
                height: 120,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setDialogState(() => _currentPage = index);
                  },
                  children: [
                    // шаг 1: название + цена
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          autofocus: true,
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: "Название",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Цена",
                            suffixText: '₸',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),

                    // шаг 2: описание
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: descriptionCtrl,
                          textInputAction: TextInputAction.newline,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Описание",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),

                    // шаг 3: картинка
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: pickImage();
                        },
                        icon: const Icon(Icons.image, color: Colors.black87),
                        label: const Text(
                          'Загрузить фото',
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Отмена"),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_currentPage != 0)
                      ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text("Назад"),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == 2) {
                          setState(() {
                            _items.putIfAbsent(category, () => []);
                            _items[category]!.add(nameCtrl.text);
                          });
                          Navigator.pop(context);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(_currentPage == 2 ? "Добавить" : "Далее"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addCategory() async {
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
              onPressed: () {
                if (newCat.isNotEmpty) {
                  setState(() {
                    categories.add(newCat);
                    _items[newCat] = [];
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

  void _toggleCollapse(String category) {
    setState(() {
      if (collapsedCategories.contains(category)) {
        collapsedCategories.remove(category);
      } else {
        collapsedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // кнопки категорий
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => _scrollToCategory(cat),
                        child: Text(tr(cat)),
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

        // контент
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final collapsed = collapsedCategories.contains(cat);
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // заголовок категории
                    Row(
                      children: [
                        Text(
                          tr(cat),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _toggleCollapse(cat),
                          icon: Icon(
                              collapsed ? Icons.expand_more : Icons.expand_less),
                        ),
                      ],
                    ),
                    if (!collapsed) ...[
                      const SizedBox(height: 12),
                      ..._items[cat]!.map((name) => DishContainerShortcut(
                        name: name,
                        price: 1200,
                        assetImage: AppIcons.logoAppetite,
                        description: '${tr("description")} $name',
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
                                    name: name,
                                    price: 1200,
                                    description:
                                    '${tr("full_description")} $name',
                                    additions: [
                                      {tr("cheese"): 200},
                                      {tr("bacon"): 300},
                                    ],
                                    reductions: [
                                      {tr("no_onion"): 0},
                                      {tr("no_sauce"): 0},
                                    ],
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

  Widget _buildAddSection(String category) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _addItem(category),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: const Radius.circular(12),
            dashPattern: const [6, 4],
            color: Colors.grey,
            strokeWidth: 1,
          ),
          child: Container(
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              tr("add"),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

