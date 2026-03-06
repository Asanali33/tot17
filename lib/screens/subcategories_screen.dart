import 'package:flutter/material.dart';
import '../services/task_service.dart';

class SubcategoriesScreen extends StatefulWidget {
  final TaskService taskService;
  final int taskIndex;

  const SubcategoriesScreen({
    Key? key,
    required this.taskService,
    required this.taskIndex,
  }) : super(key: key);

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  late String selectedCategory;
  late String? selectedSubcategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.taskService.tasks[widget.taskIndex].category;
    selectedSubcategory = widget.taskService.tasks[widget.taskIndex].subcategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Выбрать категорию',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Категория:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.taskService.categories.keys.map((category) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                              selectedSubcategory = null;
                            });
                          },
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Подкатегория:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (widget.taskService.categories[selectedCategory] ?? [])
                      .map((subcategory) {
                    return FilterChip(
                      label: Text(subcategory),
                      selected: selectedSubcategory == subcategory,
                      onSelected: (selected) {
                        setState(() {
                          selectedSubcategory = selected ? subcategory : null;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.indigo[100],
                      labelStyle: TextStyle(
                        color: selectedSubcategory == subcategory
                            ? Colors.indigo[700]
                            : Colors.black,
                        fontWeight: selectedSubcategory == subcategory
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.taskService.updateTask(
                    widget.taskIndex,
                    widget.taskService.tasks[widget.taskIndex].title,
                    selectedCategory,
                    selectedSubcategory,
                  );
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.indigo,
                ),
                child: Text(
                  'Сохранить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
