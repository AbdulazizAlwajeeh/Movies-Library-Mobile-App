import 'package:flutter/material.dart';
import 'package:flutter_proj_1/components/my_text_field.dart';
import 'package:flutter_proj_1/models/item.dart' as model;
import 'package:flutter_proj_1/providers/item_provider.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({this.newItem = true, required this.item});

  final bool newItem;
  final model.Item item;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late final TextEditingController titleController;
  late final TextEditingController imageController;
  late final TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    imageController = TextEditingController(text: widget.item.image);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          widget.newItem ? 'Create' : 'Edit',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  controller: titleController,
                  label: 'Title',
                  hint:
                      'Movie '
                      'Title',
                ),
                MyTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Image URL is required';
                    }
                    return null;
                  },
                  controller: imageController,
                  label: 'Image URL',
                  hint:
                      'Movie '
                      'Cover',
                ),
                MyTextField(
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 100) {
                      return 'Description is required (At least 100 chars)';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  label: 'Description',
                  hint:
                      'Mov'
                      'ie '
                      'Synopsis',
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newOrUpdatedItem = model.Item(
                        id: widget.item.id,
                        title: titleController.text.trim(),
                        image: imageController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                      final provider = context.read<ItemProvider>();
                      if (widget.newItem) {
                        await provider.addItem(newOrUpdatedItem);
                      } else {
                        await provider.updateItem(newOrUpdatedItem);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: Text(
                    widget.newItem ? 'Add' : 'Update',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
