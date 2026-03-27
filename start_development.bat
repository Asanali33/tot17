@echo off
echo ========================================
echo TaskFlow - Complete Development Setup
echo ========================================
echo.

REM Run verification
echo Step 1: Verifying Android SDK/NDK setup...
call verify_android_setup.bat
if %errorlevel% neq 0 (
    echo Setup verification failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Launching Small Phone Cold Boost emulator...
call launch_emulator.bat

echo.
echo Step 3: Starting Flutter development server...
echo Run the following command in a new terminal:
echo flutter run --device-id emulator-5554
echo.
echo Or use VS Code with "TaskFlow - Small Phone Cold Boost" debug configuration.
echo.

pause