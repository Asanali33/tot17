@echo off
color 0A
REM Консоль для запуска и проверки всех сервисов
title TaskFlow Backend Service Manager

:menu
cls
echo.
echo ========================================
echo     TASKFLOW BACKEND SERVICE MANAGER
echo ========================================
echo.
echo 1. Run Node.js Backend Server (Запустить бэкенд)
echo 2. Check if MongoDB is running (Проверить MongoDB)
echo 3. Install Node dependencies (Установить зависимости npm)
echo 4. Open API documentation (Открыть документацию)
echo 5. Kill server on port 3000 (Остановить сервер на порту 3000)
echo 6. Exit (Выход)
echo.
set /p choice="Enter your choice / Выберите опцию (1-6): "

if "%choice%"=="1" goto start_backend
if "%choice%"=="2" goto check_mongodb
if "%choice%"=="3" goto install_npm
if "%choice%"=="4" goto open_docs
if "%choice%"=="5" goto kill_port
if "%choice%"=="6" goto exit_menu
echo Invalid choice / Неверный выбор
timeout /t 2
goto menu

:start_backend
cls
echo.
echo ⏳ Starting Node.js Backend Server...
echo Запуск сервера Node.js бэкенда...
echo.
cd backend
if not exist "node_modules" (
    echo.
    echo 📦 Installing npm dependencies first...
    echo Установка зависимостей npm...
    call npm install
    echo.
)
echo.
echo 🚀 Server starting on http://localhost:3000
echo 📝 Make sure MongoDB is running!
echo.
echo.
node server.js
pause
goto menu

:check_mongodb
cls
echo.
echo 🔍 Checking MongoDB connection...
echo.
REM Проверяем есть ли mongosh или mongodb-cli
where mongosh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ mongosh found, trying to connect...
    echo.
    timeout /t 1
    mongosh --eval "db.adminCommand('ping')"
) else (
    where mongo >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ mongo found, trying to connect...
        echo.
        timeout /t 1
        mongo --eval "db.adminCommand('ping')"
    ) else (
        echo ❌ Neither mongosh nor mongo found
        echo ❌ MongoDB tools not installed
        echo.
        echo Try:
        echo - Install MongoDB Community Server from https://www.mongodb.com/try/download/community
        echo - Or access MongoDB Atlas at https://www.mongodb.com/cloud/atlas
    )
)
echo.
pause
goto menu

:install_npm
cls
echo.
echo 📦 Installing Node.js dependencies...
echo Установка зависимостей Node.js...
echo.
cd backend
call npm install
echo.
echo ✅ Installation complete!
echo ✅ Установка завершена!
echo.
pause
goto menu

:open_docs
cls
echo.
echo 📖 Opening backend documentation...
echo.
start START_BACKEND_GUIDE.md
goto menu

:kill_port
cls
echo.
echo 🔪 Killing process on port 3000...
echo.
for /f "tokens=5" %%a in ('netstat -ano ^| find ":3000"') do (
    echo Found process: %%a
    taskkill /PID %%a /F
    echo Killed!
)
echo.
echo ✅ Port 3000 should be free now
echo.
pause
goto menu

:exit_menu
exit
