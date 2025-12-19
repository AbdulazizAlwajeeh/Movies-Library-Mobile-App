import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemService {
  static const String baseUrl =
      'https://mymvcapp-a8dmapgrakfhf2f6'
      '.canadacentral-01.azurewebsites.net/api/Movies';

  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Item> fetchItem(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Item not found');
    } else {
      throw Exception('Failed to load item');
    }
  }

  Future<Item?> createItem(Item item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<Item?> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 204) {
      return item;
    }
    return null;
  }

  Future<Item?> deleteItem(int? id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 204) {
      return null;
    }
    return null;
  }
}
