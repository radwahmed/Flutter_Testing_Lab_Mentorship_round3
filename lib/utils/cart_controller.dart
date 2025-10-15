import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class CartController {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  void removeItem(String id) => _items.removeWhere((item) => item.id == id);

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  void clearCart() => _items.clear();

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  double get totalDiscount => _items.fold(
    0.0,
    (sum, item) => sum + item.price * item.quantity * item.discount,
  );

  double get totalAmount => subtotal - totalDiscount;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
