import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

// 🔹 Экран заказов
// 🔹 Экран заказов
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late List<Order> orders;

  // фильтры
  PaymentMethod? selectedFilter;
  String searchQuery = "";
  bool onlyDelivery = false;
  DateTime? dateFrom;
  DateTime? dateTo;

  @override
  void initState() {
    super.initState();
    orders = [
      Order(
        "Иван Иванов",
        "Без лука",
        ["Пицца Маргарита", "Кола 0.5"],
        PaymentMethod.kaspi,
        4500,
        "ул. Абая 10",
        true,
        DateTime.now().subtract(const Duration(hours: 1)),
        id: "ORD001",
      ),
      Order(
        "Алия Садыкова",
        "Добавить соус",
        ["Шаурма", "Фанта 0.5"],
        PaymentMethod.cash,
        2500,
        "ул. Сатпаева 15",
        false,
        DateTime.now().subtract(const Duration(days: 1)),
        id: "ORD002",
      ),
      Order(
        "John Doe",
        "Быстрая доставка",
        ["Бургер", "Фри", "Sprite"],
        PaymentMethod.card,
        3800,
        "ул. Назарбаева 5",
        true,
        DateTime.now().subtract(const Duration(days: 2)),
        id: "ORD003",
      ),
    ];
  }

  String _paymentMethodToText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.kaspi:
        return "Kaspi QR";
      case PaymentMethod.cash:
        return "Наличные";
      case PaymentMethod.card:
        return "Карта";
    }
  }

  void _openFiltersDialog() {
    final searchCtrl = TextEditingController(text: searchQuery);
    PaymentMethod? tempMethod = selectedFilter;
    bool tempOnlyDelivery = onlyDelivery;
    DateTime? tempFrom = dateFrom;
    DateTime? tempTo = dateTo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Фильтры"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        labelText: "Поиск по имени или ID",
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<PaymentMethod?>(
                      value: tempMethod,
                      isExpanded: true,
                      hint: const Text("Фильтр по оплате"),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("Все"),
                        ),
                        ...PaymentMethod.values.map(
                              (m) => DropdownMenuItem(
                            value: m,
                            child: Text(_paymentMethodToText(m)),
                          ),
                        )
                      ],
                      onChanged: (value) {
                        setDialogState(() => tempMethod = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: tempOnlyDelivery,
                      title: const Text("Только доставка"),
                      onChanged: (v) =>
                          setDialogState(() => tempOnlyDelivery = v ?? false),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempFrom ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setDialogState(() => tempFrom = picked);
                              }
                            },
                            child: Text(tempFrom == null
                                ? "С даты"
                                : "С: ${DateFormat('dd.MM.yyyy').format(tempFrom!)}"),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempTo ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setDialogState(() => tempTo = picked);
                              }
                            },
                            child: Text(tempTo == null
                                ? "По дату"
                                : "По: ${DateFormat('dd.MM.yyyy').format(tempTo!)}"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Отмена"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchQuery = searchCtrl.text;
                      selectedFilter = tempMethod;
                      onlyDelivery = tempOnlyDelivery;
                      dateFrom = tempFrom;
                      dateTo = tempTo;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Применить"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Заказ №${order.id}",
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text("Имя: ${order.fullname}"),
              Text("Комментарий: ${order.comment}"),
              Text("Адрес: ${order.address}"),
              Text("Тип: ${order.isDelivery ? "Доставка" : "Самовывоз"}"),
              Text(
                  "Дата: ${DateFormat('dd.MM.yyyy HH:mm').format(order.timestamp)}"),
              const SizedBox(height: 8),
              const Text("Блюда:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.dishes.map((d) => Text("• $d")),
              const SizedBox(height: 8),
              Text("Оплата: ${_paymentMethodToText(order.paymentMethod)}"),
              Text("Сумма: ${order.sumPrice.toStringAsFixed(0)} ₸"),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text("Закрыть"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    // 🔹 применяем фильтрацию
    final filteredOrders = orders.where((o) {
      final matchesPayment =
          selectedFilter == null || o.paymentMethod == selectedFilter;
      final matchesSearch = searchQuery.isEmpty ||
          o.fullname.toLowerCase().contains(searchQuery.toLowerCase()) ||
          o.id.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesDelivery = !onlyDelivery || o.isDelivery;
      final matchesDate = (dateFrom == null || o.timestamp.isAfter(dateFrom!)) &&
          (dateTo == null ||
              o.timestamp.isBefore(dateTo!.add(const Duration(days: 1))));
      return matchesPayment && matchesSearch && matchesDelivery && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Заказы"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _openFiltersDialog,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // 🔹 ограничиваем ширину
          child: filteredOrders.isEmpty
              ? const Center(child: Text("Нет заказов"))
              : isWide
              ? GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 карточки в ряд
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3, // форма карточки (шире, чем выше)
            ),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return GestureDetector(
                onTap: () => _openOrderDetails(order),
                child: DefaultContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "№ ${order.id}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Имя: ${order.fullname}"),
                      Text("Сумма: ${order.sumPrice.toStringAsFixed(0)} ₸"),
                      Text(order.isDelivery
                          ? "Доставка • ${order.address}"
                          : "Самовывоз"),
                    ],
                  ),
                ),
              );
            },
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return GestureDetector(
                onTap: () => _openOrderDetails(order),
                child: DefaultContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "№ ${order.id}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Имя: ${order.fullname}"),
                      Text("Сумма: ${order.sumPrice.toStringAsFixed(0)} ₸"),
                      Text(order.isDelivery
                          ? "Доставка • ${order.address}"
                          : "Самовывоз"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}

class Order {
  Order(this.fullname, this.comment, this.dishes, this.paymentMethod, this.sumPrice, this.address, this.isDelivery, this.timestamp, {required this.id});
  final String id;
  final String fullname;
  final String comment;
  final List<String> dishes;
  final PaymentMethod paymentMethod;
  final double sumPrice;
  final String address;
  final bool isDelivery;
  final DateTime timestamp;
}

enum PaymentMethod {kaspi, cash, card}