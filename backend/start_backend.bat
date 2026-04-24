@echo off
echo ========================================
echo Starting TaskFlow Node.js Backend...
echo ========================================
echo.
echo Checking if npm modules are installed...
if not exist "node_modules" (
    echo Installing npm dependencies...
    call npm install
    echo.
)
echo.
echo Starting server on port 3000...
echo Open: http://localhost:3000
echo MongoDB should be running on mongodb://localhost:27017
echo.
node server.js
pause