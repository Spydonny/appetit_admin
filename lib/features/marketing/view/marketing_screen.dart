import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  // фиктивные данные
  List<String> promoCodes = ["PIZZA10", "SUMMER2025"];
  List<Map<String, dynamic>> banners = [
    {"title": "Скидка -20%", "image": null}
  ];
  List<String> notifications = ["2 по цене 1 на пиццу!", "С Днём рождения! 🎉"];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final crossAxisCount = constraints.maxWidth > 1400
            ? 3
            : isWide
            ? 2
            : 1;

        return DefaultContainer(
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _buildSection(
                title: "Промокоды и скидки",
                onAdd: () {
                  _showAddDialog("Промокод", promoCodes, (value) {
                    setState(() => promoCodes.add(value));
                  });
                },
                items: promoCodes
                    .map((e) => ListTile(
                  title: Text(e),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => promoCodes.remove(e));
                    },
                  ),
                ))
                    .toList(),
              ),
              _buildSection(
                title: "Баннеры и акции",
                onAdd: () => _showAddBannerDialog(),
                items: banners
                    .map((banner) => ListTile(
                  leading: banner["image"] != null
                      ? Image.file(
                    File(banner["image"]),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image, size: 40),
                  title: Text(banner["title"] ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => banners.remove(banner));
                    },
                  ),
                ))
                    .toList(),
              ),
              _buildSection(
                title: "Push-уведомления",
                onAdd: () {
                  _showAddDialog("Push-уведомление", notifications, (value) {
                    setState(() => notifications.add(value));
                  });
                },
                items: notifications
                    .map((e) => ListTile(
                  title: Text(e),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => notifications.remove(e));
                    },
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }


  /// 🔹 Общая секция
  Widget _buildSection({
    required String title,
    required VoidCallback onAdd,
    required List<Widget> items,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок + кнопка
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text("Добавить"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const Text("Нет элементов",
                  style: TextStyle(color: Colors.grey))
            else
              Column(children: items),
          ],
        ),
      ),
    );
  }

  /// 🔹 Диалог добавления (текстовый)
  void _showAddDialog(
      String title, List<String> target, Function(String) onSave) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Добавить $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "$title..."),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Сохранить"),
          )
        ],
      ),
    );
  }

  /// 🔹 Диалог добавления баннера
  void _showAddBannerDialog() {
    final titleController = TextEditingController();
    String? imagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Добавить баннер/акцию"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Название акции"),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setDialogState(() {
                        imagePath = picked.path;
                      });
                    }
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    alignment: Alignment.center,
                    child: imagePath == null
                        ? const Text("Нажмите, чтобы выбрать изображение")
                        : Image.file(File(imagePath!),
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Отмена")),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty &&
                      imagePath != null) {
                    setState(() {
                      banners.add({
                        "title": titleController.text.trim(),
                        "image": imagePath,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Сохранить"),
              )
            ],
          );
        });
      },
    );
  }
}
