@echo off
REM Быстрый запуск бэкенда (Windows)
title TaskFlow Backend - Starting...
color 0A

cls
echo.
echo ╔════════════════════════════════════════╗
echo ║  TaskFlow Backend Server Starting...   ║
echo ║  Запуск бэкенда TaskFlow...            ║
echo ╚════════════════════════════════════════╝
echo.

echo ⏳ Проверка зависимостей...
cd backend
if not exist "node_modules" (
    echo 📦 Установка npm пакетов...
    call npm install
    echo ✅ Пакеты установлены
    echo.
)

echo 🚀 Запуск сервера...
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo API Server:  http://localhost:3000
echo MongoDB:    mongodb://localhost:27017
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo ⚠️  Убедитесь что MongoDB запущена!
echo    Windows: Services -> MongoDB Server
echo.
echo 💡 Для остановки: Ctrl+C
echo.

node server.js
