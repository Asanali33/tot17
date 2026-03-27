import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../l10n/app_localizations.dart';

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

  String getLocalizedCategory(String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'work':
        return localizations.work;
      case 'personal':
        return localizations.personal;
      case 'shopping':
        return localizations.shopping;
      case 'general':
        return localizations.general;
      default:
        return key;
    }
  }

  String getLocalizedSubcategory(String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'projects':
        return localizations.projects;
      case 'meetings':
        return localizations.meetings;
      case 'reports':
        return localizations.reports;
      case 'sport':
        return localizations.sport;
      case 'reading':
        return localizations.reading;
      case 'hobby':
        return localizations.hobby;
      case 'food':
        return localizations.food;
      case 'clothes':
        return localizations.clothes;
      case 'home':
        return localizations.home;
      case 'standard':
        return localizations.standard;
      case 'other':
        return localizations.other;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.selectCategory,
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
                      categoryKey,
                    ) {
                      final isSelected = selectedCategory == categoryKey;
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(getLocalizedCategory(categoryKey)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = categoryKey;
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
                          .map((subcategoryKey) {
                            final isSelected =
                                selectedSubcategory == subcategoryKey;
                            return FilterChip(
                              label: Text(getLocalizedSubcategory(subcategoryKey)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedSubcategory = selected
                                      ? subcategoryKey
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
                    widget.taskService.tasks[widget.taskIndex].deadline,
                  );
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text(
                  localizations.save,
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
