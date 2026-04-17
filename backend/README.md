# TaskFlow Backend

Backend для приложения TaskFlow, использующий Dart с Shelf и MongoDB.

## Установка

1. Установите MongoDB локально или используйте MongoDB Atlas.

2. Для локальной MongoDB:
   - Установите MongoDB
   - Запустите MongoDB: `mongod`

3. Для MongoDB Atlas:
   - Создайте кластер в MongoDB Atlas
   - Получите connection string
   - Обновите `MONGODB_URI` в коде или переменной окружения

## Запуск

1. Перейдите в папку backend:
   ```
   cd backend/taskflow_backend
   ```

2. Запустите сервер:
   ```
   dart run bin/taskflow_backend.dart
   ```

Сервер будет запущен на http://localhost:8080

## API Endpoints

- `GET /tasks` - Получить все задачи
- `POST /tasks` - Создать новую задачу
- `GET /tasks/:id` - Получить задачу по ID
- `PUT /tasks/:id` - Обновить задачу
- `DELETE /tasks/:id` - Удалить задачу

## Структура проекта

- `lib/models/task.dart` - Модель задачи
- `lib/services/database_service.dart` - Сервис для работы с MongoDB
- `lib/handlers/task_handlers.dart` - Обработчики API
- `bin/taskflow_backend.dart` - Точка входа