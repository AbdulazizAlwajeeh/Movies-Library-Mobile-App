import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemProvider extends ChangeNotifier {
  final ItemService _service = ItemService();

  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> _runWithLoading(Future<void> Function() action) async {
    _isLoading = true;
    notifyListeners();

    try {
      await action();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchItems() async {
    await _runWithLoading(() async {
      _items = await _service.fetchItems();
    });
  }

  Future<void> addItem(Item item) async {
    await _runWithLoading(() async {
      await _service.createItem(item);
      _items = await _service.fetchItems();
    });
  }

  Future<void> updateItem(Item item) async {
    await _runWithLoading(() async {
      await _service.updateItem(item);
      _items = await _service.fetchItems();
    });
  }

  Future<void> deleteItem(int id) async {
    await _runWithLoading(() async {
      await _service.deleteItem(id);
      _items = await _service.fetchItems();
    });
  }
}
