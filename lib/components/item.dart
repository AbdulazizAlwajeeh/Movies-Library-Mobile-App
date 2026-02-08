import 'package:flutter/material.dart';
import 'package:flutter_proj_1/models/item.dart' as model;
import '../use_cases/item_actions.dart';

class Item extends StatelessWidget {
  const Item({
    required this.item,
    required this.actions,
    this.modifiable = true,
  });

  final model.Item item;
  final bool modifiable;
  final Map<ItemActionType, ItemAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              item.image,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.description,
            style: const TextStyle(color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    iconColor: Colors.white,
                  ),
                  onPressed: () {
                    final action = !modifiable
                        ? actions[ItemActionType.login]
                        : actions[ItemActionType.delete];
                    action?.call(context, item);
                  },
                  child: const Icon(Icons.delete_forever),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    final action = !modifiable
                        ? actions[ItemActionType.login]
                        : actions[ItemActionType.update];
                    action?.call(context, item);
                  },
                  child: const Icon(Icons.edit_note),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
