import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primary = const Color.fromARGB(255, 58, 110, 114);
    final buttonColor = const Color.fromARGB(255, 19, 139, 179);
    final cardColor = const Color(0xFFFFD580);
    final backgroundColor = const Color(0xFFFFF2CC);
    final darkText = const Color(0xFF1F1B2E);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          final items = state.items;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 226, 91, 91),
                          labelText: "Enter new task",
                          labelStyle: TextStyle(color: darkText),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primary.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            context.read<ItemCubit>().addItem(controller.text);
                            controller.clear();
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primary.withOpacity(0.8),
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            "No items yet...",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (_) {
                              context.read<ItemCubit>().deleteItem(item.id);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(color: primary, width: 5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: item.isDone,
                                    activeColor: primary,
                                    onChanged: (_) {
                                      context.read<ItemCubit>().toggleItem(
                                        item.id,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: darkText,
                                        decoration: item.isDone
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      context.read<ItemCubit>().deleteItem(
                                        item.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
