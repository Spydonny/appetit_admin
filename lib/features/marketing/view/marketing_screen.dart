import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widgets/containers/default_container.dart';
import '../data/promo_data.dart';
import '../data/push_data.dart';
import '../service/marketing_service.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  List<PromoOut> promos = [];
  List<Map<String, dynamic>> banners = [
    {"title": "Скидка -20%", "image": null}
  ];
  List<String> notifications = [];

  final ImagePicker _picker = ImagePicker();
  bool _isLoadingPromos = false;

  @override
  void initState() {
    super.initState();
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    setState(() => _isLoadingPromos = true);
    try {
      final list = await GetIt.I<MarketingService>().listPromocodes();
      setState(() {
        promos = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка загрузки промокодов: $e")),
      );
    } finally {
      setState(() => _isLoadingPromos = false);
    }
  }

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
                onAdd: () => _showGeneratePromoDialog(),
                items: _isLoadingPromos
                    ? [const Center(child: CircularProgressIndicator())]
                    : promos.isEmpty
                    ? [const Text("Нет промокодов", style: TextStyle(color: Colors.grey))]
                    : promos
                    .map((e) => ListTile(
                  title: Text(e.code),
                  subtitle: Text('${e.value} ${e.kind == 'percent' ? '%' : ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        await GetIt.I<MarketingService>().deletePromocode(e.code);
                        _loadPromos();
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Ошибка удаления: $err")),
                        );
                      }
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
                onAdd: () => _showSendPushDialog(),
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

  /// 🔹 Диалог генерации промокода
  void _showGeneratePromoDialog() {
    final prefixController = TextEditingController();
    final valueController = TextEditingController(text: "10");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Сгенерировать промокоды"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prefixController,
                decoration: const InputDecoration(labelText: "Префикс (например: PIZZA)"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Скидка (%)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (prefixController.text.trim().isEmpty) return;

                final req = PromoGenerateRequest(
                  prefix: prefixController.text.trim().toUpperCase(),
                  value: double.tryParse(valueController.text) ?? 10.0,
                  kind: "percent",
                );

                try {
                  await GetIt.I<MarketingService>().generatePromos(req);
                  Navigator.pop(context);
                  _loadPromos();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка: $e")),
                  );
                }
              },
              child: const Text("Сгенерировать"),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Диалог отправки push
  void _showSendPushDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Отправить push-уведомление"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Заголовок"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: "Сообщение"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    bodyController.text.trim().isEmpty) {
                  return;
                }

                final req = AdminPushRequest(
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                );

                try {
                  final res = await GetIt.I<MarketingService>().sendPushNotification(req);

                  setState(() {
                    notifications.add("${req.title}: ${req.body}");
                  });

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка: $e")),
                  );
                }
              },
              child: const Text("Отправить"),
            ),
          ],
        );
      },
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