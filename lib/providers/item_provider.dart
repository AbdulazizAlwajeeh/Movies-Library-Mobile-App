import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemProvider extends ChangeNotifier {
  ItemProvider({required ItemService service}) : _service = service;
  final ItemService _service;

  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<bool> _runWithLoading(Future<void> Function() action) async {
    _isLoading = true;
    notifyListeners();

    try {
      await action();
      return true;
    } catch (e) {
      return false;
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
      _items.add(item);
    });
  }

  Future<bool> updateItem(Item item) async {
    return await _runWithLoading(() async {
      await _service.updateItem(item);
      int index = _items.indexWhere((element) => element.id == item.id);
      _items[index] = item;
    });
  }

  Future<bool> deleteItem(int id) async {
    return await _runWithLoading(() async {
      await _service.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
    });
  }
}
