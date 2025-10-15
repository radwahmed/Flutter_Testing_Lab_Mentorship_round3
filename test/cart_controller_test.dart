import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/cart_controller.dart';

void main() {
  group('CartController Tests', () {
    late CartController cart;

    setUp(() {
      cart = CartController();
    });

    test('Adding new item increases totalItems and subtotal', () {
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      expect(cart.totalItems, 1);
      expect(cart.subtotal, 1000.0);
      expect(cart.totalDiscount, 100.0);
      expect(cart.totalAmount, 900.0);
    });

    test('Adding duplicate item updates quantity', () {
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      expect(cart.totalItems, 2);
      expect(cart.subtotal, 2000.0);
      expect(cart.totalDiscount, 200.0);
      expect(cart.totalAmount, 1800.0);
    });

    test('Remove item works correctly', () {
      cart.addItem('1', 'iPhone', 1000.0);
      cart.addItem('2', 'Galaxy', 900.0);
      cart.removeItem('1');
      expect(cart.totalItems, 1);
      expect(cart.subtotal, 900.0);
    });

    test('Update quantity works and removes item if quantity <= 0', () {
      cart.addItem('1', 'iPhone', 1000.0);
      cart.updateQuantity('1', 3);
      expect(cart.totalItems, 3);
      expect(cart.subtotal, 3000.0);

      cart.updateQuantity('1', 0);
      expect(cart.totalItems, 0);
      expect(cart.subtotal, 0.0);
    });

    test('Clear cart removes all items', () {
      cart.addItem('1', 'iPhone', 1000.0);
      cart.addItem('2', 'Galaxy', 900.0);
      cart.clearCart();
      expect(cart.totalItems, 0);
      expect(cart.subtotal, 0.0);
    });

    test('Handles 100% discount correctly', () {
      cart.addItem('1', 'Free Item', 500.0, discount: 1.0);
      expect(cart.totalDiscount, 500.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Handles empty cart correctly', () {
      expect(cart.totalItems, 0);
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Handles large quantities', () {
      cart.addItem('1', 'Bulk Item', 10.0);
      cart.updateQuantity('1', 1000);
      expect(cart.totalItems, 1000);
      expect(cart.subtotal, 10000.0);
    });
  });
}
