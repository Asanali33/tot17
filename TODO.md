# TODO: Fix collaborator not saving after screen switch

## Problem
When adding a task and assigning a collaborator, the collaborator is not saved after switching screens (e.g., going to Stats tab and back to Home).

## Root Cause
- `addTask()` in `task_service.dart` was synchronous and called `saveTask()` without `await`
- The task didn't have a server ID when the edit dialog opened
- `updateTaskOnServer()` returned immediately if `task.id == null`
- Switching tabs recreated HomeScreen and called `loadTasks()`, overwriting local unsaved changes

## Steps to Fix

1. [x] **task_service.dart** — Make `addTask` async and await `saveTask`
2. [x] **task_service.dart** — Make `updateTask` return `Future<void>` instead of `void`
3. [x] **home_screen.dart** — Make add flow async, await addTask before opening editor
4. [x] **home_screen.dart** — Await updateTask in edit dialog save button
5. [x] **edit_task_screen.dart** — Make _saveTask async and call updateTaskOnServer

## Testing
- Add a task, assign collaborator, switch to Stats, return to Home → collaborator should persist

