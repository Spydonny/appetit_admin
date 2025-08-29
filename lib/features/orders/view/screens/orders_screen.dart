import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/data.dart';
import '../../services/order_service.dart';
import '../../../../widgets/widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final orderService = GetIt.I<OrderService>();

  late Future<List<Order>> _futureOrders;

  // фильтры
  String? selectedStatus;
  String searchQuery = "";
  bool onlyDelivery = false;
  DateTime? dateFrom;
  DateTime? dateTo;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _futureOrders = orderService.fetchOrders(
        status: selectedStatus,
        from: dateFrom?.toIso8601String(),
        to: dateTo?.toIso8601String(),
      );
    });
  }

  void _openFiltersDialog() {
    final searchCtrl = TextEditingController(text: searchQuery);
    String? tempStatus = selectedStatus;
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
                        labelText: "Поиск по номеру",
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<String?>(
                      value: tempStatus,
                      isExpanded: true,
                      hint: const Text("Статус заказа"),
                      items: const [
                        DropdownMenuItem(value: null, child: Text("Все")),
                        DropdownMenuItem(value: "NEW", child: Text("Новые")),
                        DropdownMenuItem(value: "COOKING", child: Text("Готовится")),
                        DropdownMenuItem(value: "ON_WAY", child: Text("В пути")),
                        DropdownMenuItem(value: "DELIVERED", child: Text("Доставлен")),
                        DropdownMenuItem(value: "CANCELLED", child: Text("Отменённые")),
                      ],
                      onChanged: (value) {
                        setDialogState(() => tempStatus = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: tempOnlyDelivery,
                      title: const Text("Только доставка"),
                      onChanged: (v) => setDialogState(() => tempOnlyDelivery = v ?? false),
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
                      selectedStatus = tempStatus;
                      onlyDelivery = tempOnlyDelivery;
                      dateFrom = tempFrom;
                      dateTo = tempTo;
                    });
                    Navigator.pop(context);
                    _loadOrders();
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
    String tempStatus = order.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Заказ №${order.number}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text("Адрес: ${order.addressText ?? '—'}"),
                    Text("Тип: ${order.pickupOrDelivery}"),
                    const SizedBox(height: 8),

                    // 🔹 выбор статуса
                    Row(
                      children: [
                        const Text("Статус:"),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButton<String>(
                            value: tempStatus,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: "NEW", child: Text("Новые")),
                              DropdownMenuItem(value: "COOKING", child: Text("Готовится")),
                              DropdownMenuItem(value: "ON_WAY", child: Text("В пути")),
                              DropdownMenuItem(value: "DELIVERED", child: Text("Доставлен")),
                              DropdownMenuItem(value: "CANCELLED", child: Text("Отменённые")),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setSheetState(() => tempStatus = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text("Дата: ${DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt)}"),
                    const SizedBox(height: 8),
                    const Text("Блюда:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...order.items.map((d) => Text("• ${d.nameSnapshot} x${d.qty}")),
                    const SizedBox(height: 8),
                    Text("Оплата: ${order.paymentMethod}"),
                    Text("Сумма: ${order.total.toStringAsFixed(0)} ₸"),
                    const SizedBox(height: 16),

                    // 🔹 кнопки управления
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: const Text("Закрыть"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await orderService.changeStatus(order.id, tempStatus);
                                if (!mounted) return;
                                Navigator.pop(context);
                                _loadOrders(); // обновим список
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Ошибка: $e")),
                                );
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Сохранить"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () => _openOrderDetails(order),
      child: DefaultContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("№ ${order.number}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("Статус: ${order.status}"),
            Text("Сумма: ${order.total.toStringAsFixed(0)} ₸"),
            Text(order.pickupOrDelivery == "delivery"
                ? "Доставка • ${order.addressText ?? '-'}"
                : "Самовывоз"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

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
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          }

          var orders = snapshot.data ?? [];

          // 🔹 локальная фильтрация
          final filteredOrders = orders.where((o) {
            final matchesSearch = searchQuery.isEmpty ||
                o.number.toLowerCase().contains(searchQuery.toLowerCase());
            final matchesDelivery = !onlyDelivery || o.pickupOrDelivery == "delivery";
            return matchesSearch && matchesDelivery;
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text("Нет заказов"));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: isWide
                  ? GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3,
                ),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) =>
                    _buildOrderCard(filteredOrders[index]),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) =>
                    _buildOrderCard(filteredOrders[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

