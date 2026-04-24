# 🚀 Запуск бэкенда TaskFlow

## Что нужно установить

### 1. **Node.js** (если не установлен)
- Скачайте с https://nodejs.org/ (LTS версию)
- Убедитесь, что `node` и `npm` доступны в консоли:
```bash
node --version
npm --version
```

### 2. **MongoDB** (локальная база данных)
- Скачайте MongoDB Community Server с https://www.mongodb.com/try/download/community
- Или используйте MongoDB Atlas (облачная версия) - обновите `MONGODB_URI` в `.env`

#### Если используете локальную MongoDB:
- Windows: скачайте инсталлятор и выберите "Install MongoDB as a Service"
- После установки MongoDB будет автоматически запускаться в фоне
- Проверить запуск: `mongosh` в консоли

---

## 📋 Требования в файле .env

В файле `backend/.env` должны быть:
```env
MONGODB_URI=mongodb://localhost:27017/taskflowdb
PORT=3000
JWT_SECRET=your_super_secret_jwt_key_change_in_production_2024
```

---

## ▶️ Запуск бэкенда

### Способ 1: Двойной клик (Windows)
```
Откройте: backend/start_backend.bat
```

### Способ 2: Через консоль
```bash
cd backend
npm install          # Первый раз или если добавились пакеты
node server.js
```

Сервер запустится на **http://localhost:3000**

---

## ✅ Проверка работы

Когда сервер запущен, вы должны увидеть:
```
Connected to MongoDB
Server running on port 3000
```

### Проверить в браузере:
```
http://localhost:3000/api/auth/register  (должно быть ошибка 405 - это нормально)
```

---

## 🔧 Если возникают ошибки

### Ошибка: "Failed to fetch"
- ❌ Бэкенд не запущен → запустите `start_backend.bat`
- ❌ MongoDB не запущена → запустите MongoDB Community Server
- ❌ Неправильный URL → проверьте `MONGODB_URI` в `.env`

### Ошибка: "Cannot find module"
```bash
cd backend
npm install
```

### Ошибка: "Port 3000 is already in use"
```bash
# Windows: найти процесс на порту 3000 и закрыть его
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

---

## 📱 Подключение с эмулятора

### Android эмулятор:
- Автоматически использует `10.0.2.2:3000` ✅ (исправлено в коде)

### iOS эмулятор:
- Используется `localhost:3000` ✅

### Физическое устройство:
- Замените `localhost` на IP вашей машины:
  ```
  http://<ВАШ_IP>:3000/api
  ```
  Найти IP: `ipconfig` в консоли (IPv4 Address)

---

## 📊 Структура бэкенда

```
backend/
├── server.js           # Основной файл сервера
├── start_backend.bat   # Батник для запуска (Windows)
├── .env                # Переменные окружения
├── routes/
│   ├── auth.js         # Эндпоинты регистрации/входа
│   └── tasks.js        # Эндпоинты работы с задачами
├── models/
│   ├── User.js         # Модель пользователя
│   └── Task.js         # Модель задачи
└── node_modules/       # Зависимости (создается после npm install)
```

---

## 🔐 Безопасность

⚠️ **Важно для production:**
- Измените `JWT_SECRET` на безопасный ключ
- Используйте MongoDB Atlas вместо локальной БД
- Добавьте переменные окружения на сервер
- Используйте HTTPS вместо HTTP

