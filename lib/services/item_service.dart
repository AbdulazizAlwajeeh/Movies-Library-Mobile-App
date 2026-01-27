import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemService {
  static const String baseUrl = 'http://16.171.43.166/api/Movies';

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

  Future<Map<String, dynamic>> createItem(Item item, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201) {
      item = Item.fromJson(jsonDecode(response.body));
      return {
        'success': true,
        'message': 'Item Created Successfully.',
        'item': item,
      };
    } else if (response.statusCode == 401) {
      return {'success': false, 'message': 'Error: Missing/Expired Token.'};
    } else {
      throw Exception('Network/Server Error.');
    }
  }

  Future<Map<String, dynamic>> updateItem(Item item, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${item.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200) {
      item = Item.fromJson(jsonDecode(response.body));
      return {
        'success': true,
        'message': 'Item Updated Successfully.',
        'item': item,
      };
    } else if (response.statusCode == 401) {
      return {'success': false, 'message': 'Error: Missing/Expired Token.'};
    } else {
      throw Exception('Network/Server Error.');
    }
  }

  Future<Map<String, dynamic>> deleteItem(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return {'success': true, 'message': 'Item Deleted Successfully.'};
    } else if (response.statusCode == 401) {
      return {'success': false, 'message': 'Error: Missing/Expired Token.'};
    } else {
      throw Exception('Network/Server Error.');
    }
  }
}
