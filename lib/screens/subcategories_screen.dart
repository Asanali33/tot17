import 'package:flutter/material.dart';
import '../services/task_service.dart';

class SubcategoriesScreen extends StatefulWidget {
  final TaskService taskService;
  final int taskIndex;

  const SubcategoriesScreen({
    super.key,
    required this.taskService,
    required this.taskIndex,
  });

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
    selectedSubcategory =
        widget.taskService.tasks[widget.taskIndex].subcategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Выбрать категорию',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.taskService.categories.keys.map((
                      category,
                    ) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                              selectedSubcategory = null;
                            });
                          },
                          selectedColor: colorScheme.primaryContainer,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      (widget.taskService.categories[selectedCategory] ?? [])
                          .map((subcategory) {
                            final isSelected =
                                selectedSubcategory == subcategory;
                            return FilterChip(
                              label: Text(subcategory),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedSubcategory = selected
                                      ? subcategory
                                      : null;
                                });
                              },
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              selectedColor: colorScheme.primaryContainer,
                              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            );
                          })
                          .toList(),
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
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text(
                  'Сохранить',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
