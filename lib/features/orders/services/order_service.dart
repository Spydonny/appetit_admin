import '../data/data.dart';

class OrderService {
  final OrderRepo repo;

  OrderService(this.repo);

  Future<List<Order>> fetchOrders({String? status, String? from, String? to}) {
    return repo.getOrders(status: status, from: from, to: to);
  }

  Future<Order> fetchOrder(int orderId) {
    return repo.getOrder(orderId);
  }

  Future<Order> changeStatus(int orderId, String status) {
    return repo.updateStatus(orderId, status);
  }

  Future<void> removeOrder(int orderId) {
    return repo.deleteOrder(orderId);
  }
}
