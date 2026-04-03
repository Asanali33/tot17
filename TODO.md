# TaskFlow Edit Plan Implementation

## Approved Plan Summary
- Home screen: tasks view-only (toggle, delete, add new). No editing possibility (edit buttons hidden).
- Editing screen: TaskEditorScreen list with full edit buttons, EditTaskScreen full func incl category/subcategory change, comments add/save.

## Steps:
- [x] 1. task_service.dart: Add updateTaskComments method.
- [x] 2. task_tile.dart: Make edit buttons conditional on callbacks.
- [x] 3. subcategories_screen.dart: Verified updates service.
- [x] 4. home_screen.dart: Removed callbacks, added AppBar Edit nav to TaskEditorScreen.
- [x] 5. edit_task_screen.dart: Added category button to SubcategoriesScreen, updateTaskComments.
- [x] 6. task_editor_screen.dart: Kept as editing list with full callbacks.

All changes complete and tested via linter no errors.

Task complete.
