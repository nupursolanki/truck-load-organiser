@echo off
echo =====================================
echo  Truck Loading Optimizer Dev Tools
echo =====================================
echo.

:menu
echo Choose an option:
echo.
echo 1. Setup Project (First time)
echo 2. Start Development Servers
echo 3. Start Backend Only
echo 4. Start Frontend Only
echo 5. Install Dependencies
echo 6. Clean Project
echo 7. Reset Database
echo 8. View Logs
echo 9. Check Project Status
echo 0. Exit
echo.
set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto setup
if "%choice%"=="2" goto start_all
if "%choice%"=="3" goto start_backend
if "%choice%"=="4" goto start_frontend
if "%choice%"=="5" goto install_deps
if "%choice%"=="6" goto clean
if "%choice%"=="7" goto reset_db
if "%choice%"=="8" goto view_logs
if "%choice%"=="9" goto status
if "%choice%"=="0" goto exit
goto menu

:setup
echo.
echo [INFO] Running full project setup...
call setup.bat
goto menu

:start_all
echo.
echo [INFO] Starting both servers...
call run.bat
goto menu

:start_backend
echo.
echo [INFO] Starting backend server only...
cd backend
call venv\Scripts\activate.bat
python server.py
cd ..
goto menu

:start_frontend
echo.
echo [INFO] Starting frontend server only...
cd frontend
npm start
cd ..
goto menu

:install_deps
echo.
echo [INFO] Installing/updating dependencies...
cd backend
call venv\Scripts\activate.bat
pip install -r requirements.txt
cd ..\frontend
npm install
cd ..
goto menu

:clean
echo.
echo [INFO] Cleaning project...
if exist "frontend\node_modules" rmdir /s /q "frontend\node_modules"
if exist "frontend\build" rmdir /s /q "frontend\build"
if exist "backend\__pycache__" rmdir /s /q "backend\__pycache__"
if exist "logs" rmdir /s /q "logs"
if exist "backend\truck_optimizer.db" del "backend\truck_optimizer.db"
echo [SUCCESS] Project cleaned!
goto menu

:reset_db
echo.
echo [WARNING] This will delete all data!
set /p confirm="Are you sure? (y/N): "
if /i "%confirm%"=="y" (
    if exist "backend\truck_optimizer.db" (
        del "backend\truck_optimizer.db"
        echo [SUCCESS] Database reset!
    ) else (
        echo [INFO] No database file found.
    )
) else (
    echo [INFO] Database reset cancelled.
)
goto menu

:view_logs
echo.
echo [INFO] Available logs:
if exist "logs" (
    dir /b logs\*.log
    echo.
    set /p logfile="Enter log filename to view (or press Enter to skip): "
    if not "%logfile%"=="" (
        if exist "logs\%logfile%" (
            type "logs\%logfile%"
        ) else (
            echo [ERROR] Log file not found.
        )
    )
) else (
    echo [INFO] No logs directory found.
)
goto menu

:status
echo.
echo [INFO] Project Status:
echo.
if exist "backend\venv" (
    echo ✓ Backend virtual environment: EXISTS
) else (
    echo ✗ Backend virtual environment: MISSING
)

if exist "frontend\node_modules" (
    echo ✓ Frontend dependencies: INSTALLED
) else (
    echo ✗ Frontend dependencies: MISSING
)

if exist "backend\.env" (
    echo ✓ Backend .env: EXISTS
) else (
    echo ✗ Backend .env: MISSING
)

if exist "frontend\.env" (
    echo ✓ Frontend .env: EXISTS
) else (
    echo ✗ Frontend .env: MISSING
)

echo.
echo Port Status:
netstat -an | findstr ":8000" >nul && echo ✓ Backend port 8000: IN USE || echo ✗ Backend port 8000: FREE
netstat -an | findstr ":3000" >nul && echo ✓ Frontend port 3000: IN USE || echo ✗ Frontend port 3000: FREE

goto menu

:exit
echo.
echo [INFO] Goodbye!
exit

pause