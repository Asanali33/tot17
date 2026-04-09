# 💻 Примеры кода: Использование функции Таймера

## Основные операции с таймером

### 1. Создание задачи с временем выполнения

```dart
// В коде добавления задачи
taskService.addTask(
  'Написать отчет',
  category: 'work',
  deadline: DateTime.now().add(Duration(days: 1)),
  estimatedDuration: Duration(hours: 2, minutes: 30), // Новое поле!
);
```

### 2. Запуск таймера

```dart
// Запустить таймер для задачи с индексом 0
taskService.startTimer(0);

// Таймер начнет отсчет
```

### 3. Получение оставшегося времени

```dart
// Получить Duration объект
Duration? remaining = taskService.getRemainingTime(0);

// Получить отформатированную строку (ЧЧ:ММ:СС)
String timeLeft = taskService.getFormattedRemainingTime(0);
print(timeLeft); // "00:45:30"
```

### 4. Остановка таймера

```dart
// Остановить таймер (можно возобновить)
taskService.stopTimer(0);
```

### 5. Сброс таймера

```dart
// Вернуть таймер к начальному времени
taskService.resetTimer(0);
```

### 6. Изменение времени выполнения

```dart
// Изменить время на 1 час 15 минут
taskService.setTaskDuration(
  0,
  Duration(hours: 1, minutes: 15),
);
```

### 7. Проверка истечения времени

```dart
// Проверить, истекло ли время
if (taskService.isTimeExpired(0)) {
  print('⏰ Время истекло!');
}
```

### 8. Получение прогресса

```dart
// Получить прогресс от 0.0 до 1.0
double progress = taskService.getTimerProgress(0);
print('Прогресс: ${(progress * 100).toStringAsFixed(1)}%');

// Использовать в индикаторе прогресса
CircularProgressIndicator(
  value: progress,
  strokeWidth: 8,
)
```

## Примеры UI компонентов

### Отображение таймера в деталях задачи

```dart
// В TaskDetailScreen
if (task.estimatedDuration != null) {
  Column(
    children: [
      // Круговой индикатор
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: taskService.getTimerProgress(taskIndex),
              strokeWidth: 8,
            ),
          ),
          // Текст времени
          Text(
            taskService.getFormattedRemainingTime(taskIndex),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      // Кнопки управления
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => taskService.startTimer(taskIndex),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Запустить'),
          ),
          ElevatedButton.icon(
            onPressed: () => taskService.stopTimer(taskIndex),
            icon: const Icon(Icons.pause),
            label: const Text('Остановить'),
          ),
          ElevatedButton.icon(
            onPressed: () => taskService.resetTimer(taskIndex),
            icon: const Icon(Icons.refresh),
            label: const Text('Сбросить'),
          ),
        ],
      ),
    ],
  );
}
```

### Отображение таймера на карточке задачи

```dart
// В TaskTile
if (task.estimatedDuration != null) {
  Row(
    children: [
      Icon(Icons.timer, size: 16, color: Colors.blue),
      SizedBox(width: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Время выполнения: ${_formatDuration(task.estimatedDuration!)}'),
          if (task.isTimerActive && task.timerStartedAt != null)
            Text('Таймер: ${_getRemainingTime(task)}'),
        ],
      ),
    ],
  );
}
```

## Работа с диалогом установки времени

### Создание диалога выбора времени

```dart
showDialog(
  context: context,
  builder: (context) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Установить время выполнения'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Поля ввода для часов, минут, секунд
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          hours = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Часы',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // ... аналогично для минут и секунд
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final duration = Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                );
                taskService.setTaskDuration(taskIndex, duration);
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  },
);
```

## Методы форматирования

### Форматировать Duration в строку

```dart
String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  return '${hours.toString().padLeft(2, '0')}:'
         '${minutes.toString().padLeft(2, '0')}:'
         '${seconds.toString().padLeft(2, '0')}';
}

// Использование
Duration time = Duration(hours: 1, minutes: 30, seconds: 45);
print(_formatDuration(time)); // "01:30:45"
```

### Форматировать с кратким отображением

```dart
String _formatDurationShort(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}ч ${minutes}м';
  }
  return '${minutes}м';
}

// Использование
print(_formatDurationShort(Duration(hours: 2, minutes: 30))); // "2ч 30м"
```

## Интеграция с состоянием приложения

### Автоматическое обновление UI

```dart
class TaskDetailScreen extends StatefulWidget {
  // ...
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _timerUpdateController;

  @override
  void initState() {
    super.initState();
    // Обновлять UI каждую секунду
    _timerUpdateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _timerUpdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _timerUpdateController,
      builder: (context, child) {
        // UI обновляется каждую секунду
        final remaining = taskService.getRemainingTime(taskIndex);
        return Column(
          children: [
            Text('Осталось: ${_formatDuration(remaining ?? Duration.zero)}'),
            // ...
          ],
        );
      },
    );
  }
}
```

## Проверка состояния

### Проверка активности таймера

```dart
if (task.isTimerActive) {
  print('Таймер работает!');
  print('Осталось: ${taskService.getFormattedRemainingTime(index)}');
} else {
  print('Таймер не активен');
}
```

### Проверка завершения времени

```dart
if (taskService.isTimeExpired(index)) {
  showNotification('⏰ Время истекло!');
}
```

## Практические примеры использования

### Пример 1: Таймер для задачи

```dart
// Пользователь создает задачу "Встреча с клиентом"
taskService.addTask(
  'Встреча с клиентом',
  estimatedDuration: Duration(hours: 1),
);

// Позже открывает задачу и запускает таймер
taskService.startTimer(0);

// Приложение показывает обратный отсчет
// После истечения часа: "⏰ Время истекло!"
```

### Пример 2: Переустановка времени

```dart
final taskIndex = 2;

// Начальное время: 30 минут
taskService.setTaskDuration(taskIndex, Duration(minutes: 30));
taskService.startTimer(taskIndex);

// Через 10 минут пользователь решил увеличить время
Duration remaining = taskService.getRemainingTime(taskIndex)!;
taskService.resetTimer(taskIndex);
taskService.setTaskDuration(
  taskIndex,
  remaining + Duration(minutes: 15), // +15 минут
);
```

### Пример 3: Статистика использования

```dart
// Получить все задачи с установленным временем
final tasksWithTimer = taskService.tasks
    .where((task) => task.estimatedDuration != null)
    .toList();

// Экспортировать данные
for (var task in tasksWithTimer) {
  final duration = taskService.getFormattedDuration(tasksWithTimer.indexOf(task));
  print('${task.title}: $duration');
}
```

---

## 🎯 Ключевые точки

✅ Таймер обновляется в реальном времени  
✅ Время сохраняется в модели Task  
✅ Можно изменять время даже во время работы таймера  
✅ Автоматическая остановка при истечении  
✅ Полная история всех изменений  

