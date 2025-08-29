import 'package:appetit_admin/widgets/containers/containers.dart';
import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final List<Map<String, String>> employees = [];

  String? selectedRole; // фильтр по роли

  void fakeRepoAddEmployee(Map<String, String> employee) {
    employees.add(employee);
  }

  void _showAddEmployeeDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final loginCtrl = TextEditingController();
    final roleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Добавить сотрудника"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "ФИО"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Номер телефона"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: loginCtrl,
                decoration: const InputDecoration(labelText: "Логин"),
              ),
              TextField(
                controller: roleCtrl,
                decoration: const InputDecoration(labelText: "Роль (courier / manager / admin)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty &&
                  phoneCtrl.text.isNotEmpty &&
                  loginCtrl.text.isNotEmpty &&
                  roleCtrl.text.isNotEmpty) {
                setState(() {
                  fakeRepoAddEmployee({
                    "name": nameCtrl.text,
                    "phone": phoneCtrl.text,
                    "login": loginCtrl.text,
                    "role": roleCtrl.text,
                  });
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text("Добавить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // фильтрация списка сотрудников
    final filteredEmployees = selectedRole == null
        ? employees
        : employees.where((e) => e["role"] == selectedRole).toList();

    return Column(
      children: [
        // Фильтр по роли + кнопка добавления
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              hint: const Text("Фильтр по роли"),
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: "courier", child: Text("Courier")),
                DropdownMenuItem(value: "manager", child: Text("Manager")),
                DropdownMenuItem(value: "admin", child: Text("Admin")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 32, color: Colors.blue),
              onPressed: _showAddEmployeeDialog,
            ),
          ],
        ),

        // Список сотрудников
        Expanded(
          child: filteredEmployees.isEmpty
              ? const Center(child: Text("Нет сотрудников"))
              : ListView.builder(
            itemCount: filteredEmployees.length,
            itemBuilder: (ctx, i) {
              final emp = filteredEmployees[i];
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: DefaultContainer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(emp["name"] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("Тел: ${emp["phone"]}"),
                            Text("Логин: ${emp["login"]}"),
                            Text("Роль: ${emp["role"]}"),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            employees.remove(emp);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

