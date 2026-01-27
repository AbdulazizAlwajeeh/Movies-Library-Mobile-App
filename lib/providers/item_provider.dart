import 'package:flutter/material.dart';
import 'package:flutter_proj_1/providers/login_provider.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemProvider extends ChangeNotifier {
  ItemProvider({
    required ItemService service,
    required LoginProvider loginProvider,
  }) : _service = service,
       _loginProvider = loginProvider;

  final ItemService _service;
  final LoginProvider _loginProvider;

  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<Map<String, dynamic>> _runWithLoading(
    Future<dynamic> Function() action,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await action();
    } catch (e) {
      return {'success': false, 'message': e.toString()};
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

  Future<Map<String, dynamic>> addItem(Item item) async {
    return await _runWithLoading(() async {
      final result = await _service.createItem(item, _loginProvider.token);
      if (result['success']) {
        _items.add(result['item']);
      }
      return result;
    });
  }

  Future<Map<String, dynamic>> updateItem(Item item) async {
    return await _runWithLoading(() async {
      final result = await _service.updateItem(item, _loginProvider.token);
      if (result['success']) {
        int index = _items.indexWhere((element) => element.id == item.id);
        _items[index] = result['item'];
      }
      return result;
    });
  }

  Future<Map<String, dynamic>> deleteItem(int id) async {
    return await _runWithLoading(() async {
      final result = await _service.deleteItem(id, _loginProvider.token);
      if (result['success']) {
        _items.removeWhere((item) => item.id == id);
      }
      return result;
    });
  }
}
