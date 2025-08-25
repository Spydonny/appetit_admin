import 'package:flutter/material.dart';

// -------- твой контейнер --------
class DishContainer extends StatefulWidget {
  const DishContainer({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.additions,
    required this.reductions,
  });

  final AssetImage image;
  final String name;
  final double price;
  final String description;
  final List<Map<String, double>> additions;
  final List<Map<String, double>> reductions;

  @override
  State<DishContainer> createState() => _DishContainerState();
}

class _DishContainerState extends State<DishContainer> {
  late String name;
  late double price;
  late String description;
  late List<Map<String, double>> additions;
  late List<Map<String, double>> reductions;

  int quantity = 1;
  final Set<String> selectedAdditions = {};
  final Set<String> selectedReductions = {};

  @override
  void initState() {
    super.initState();
    name = widget.name;
    price = widget.price;
    description = widget.description;
    additions = List.from(widget.additions);
    reductions = List.from(widget.reductions);
  }

  double get totalPrice {
    final additionsPrice = additions
        .where((map) => selectedAdditions.contains(map.keys.first))
        .fold<double>(0, (sum, map) => sum + map.values.first);

    final reductionsPrice = reductions
        .where((map) => selectedReductions.contains(map.keys.first))
        .fold<double>(0, (sum, map) => sum + map.values.first);

    return price * quantity + additionsPrice - reductionsPrice;
  }

  // ------------------ диалог изменения блюда ------------------
  Future<void> _editDish() async {
    final nameCtrl = TextEditingController(text: name);
    final priceCtrl = TextEditingController(text: price.toString());
    final descCtrl = TextEditingController(text: description);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Редактировать блюдо"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Название")),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Цена")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Описание")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameCtrl.text;
                  price = double.tryParse(priceCtrl.text) ?? price;
                  description = descCtrl.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            )
          ],
        );
      },
    );
  }

  // ------------------ диалог добавления модификации ------------------
  Future<void> _addModification(bool isAddition) async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAddition ? "Добавить вкус" : "Убрать лишнее"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Название")),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Цена")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
            ElevatedButton(
              onPressed: () {
                final title = nameCtrl.text.trim();
                final value = double.tryParse(priceCtrl.text) ?? 0;
                if (title.isNotEmpty) {
                  setState(() {
                    if (isAddition) {
                      additions.add({title: value});
                    } else {
                      reductions.add({title: value});
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Добавить"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Картинка + кнопка редактирования
          Stack(
            children: [
              Image(image: widget.image, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editDish,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название + цена
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text("от $price ₸", style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, style: theme.textTheme.bodyMedium),

                // Блок "Добавить вкуса"
                _buildGrid(theme, "Добавить вкуса", additions, selectedAdditions,
                        (title) => setState(() {
                      selectedAdditions.toggle(title);
                    }),
                    onAddPressed: () => _addModification(true)),

                // Блок "Убрать лишнее"
                _buildGrid(theme, "Убрать лишнее", reductions, selectedReductions,
                        (title) => setState(() {
                      selectedReductions.toggle(title);
                    }),
                    onAddPressed: () => _addModification(false)),
              ],
            ),
          ),

          // Количество и кнопка
          SizedBox(
            width: screenWidth,
            child: _QuantityRow(
              quantity: quantity,
              onQuantityChanged: (newQuantity) => setState(() => quantity = newQuantity),
              total: totalPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
      ThemeData theme,
      String header,
      List<Map<String, double>> arr,
      Set<String> selectedSet,
      void Function(String title) onTap, {
        required VoidCallback onAddPressed,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(header, style: theme.textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onAddPressed,
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arr.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final title = arr[index].keys.first;
              final price = arr[index].values.first;
              final isSelected = selectedSet.contains(title);

              return GestureDetector(
                onTap: () => onTap(title),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: theme.textTheme.bodyMedium),
                        Text("+$price ₸", style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ------------------ Quantity ------------------
class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.total,
  });

  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // qty
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) onQuantityChanged(quantity - 1);
                },
                icon: const Icon(Icons.remove),
              ),
              Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                onPressed: () => onQuantityChanged(quantity + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              // TODO: добавить в корзину
            },
            child: Text("Добавить • ${total.toStringAsFixed(0)}₸"),
          ),
        ],
      ),
    );
  }
}

// ------------------ extension ------------------
extension _Toggle<T> on Set<T> {
  void toggle(T value) {
    contains(value) ? remove(value) : add(value);
  }
}
