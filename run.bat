@echo off
echo =====================================
echo  Truck Loading Optimizer Runner
echo =====================================
echo.

:: Check if backend and frontend directories exist
if not exist "backend" (
    echo [ERROR] Backend directory not found
    echo Make sure you're running this from the project root directory
    pause
    exit /b 1
)

if not exist "frontend" (
    echo [ERROR] Frontend directory not found
    echo Make sure you're running this from the project root directory
    pause
    exit /b 1
)

:: Check if setup has been run
if not exist "backend\venv" (
    echo [ERROR] Backend virtual environment not found
    echo Please run setup.bat first
    pause
    exit /b 1
)

if not exist "frontend\node_modules" (
    echo [ERROR] Frontend node_modules not found
    echo Please run setup.bat first
    pause
    exit /b 1
)

::      Check if main.py exists
if not exist "backend\main.py" (
    echo [ERROR] backend\main.py not found
    echo Make sure your backend files are in the backend directory
    pause
    exit /b 1
)

:: Check if frontend package.json exists
if not exist "frontend\package.json" (
    echo [ERROR] frontend\package.json not found
    echo Make sure your frontend files are in the frontend directory
    pause
    exit /b 1
)

echo [INFO] Starting Truck Loading Optimizer...
echo.
echo Backend will be available at: http://localhost:8000
echo Frontend will be available at: http://localhost:3000
echo API Documentation at: http://localhost:8000/docs
echo.
echo Press Ctrl+C to stop both servers
echo.

:: Start Backend Server
echo [INFO] Starting Python FastAPI Backend...
cd backend
start "Backend Server" cmd /k "venv\Scripts\activate.bat && echo [BACKEND] Starting server on port 8000... && python main.py"

:: Wait a moment for backend to start
timeout /t 3 /nobreak >nul

cd ..

:: Start Frontend Server
echo [INFO] Starting React Frontend...
cd frontend
start "Frontend Server" cmd /k "echo [FRONTEND] Starting React development server on port 3000... && npm start"

cd ..

echo.
echo [SUCCESS] Both servers are starting!
echo.
echo =====================================
echo  Server Status
echo =====================================
echo Backend Server: Starting...
echo Frontend Server: Starting...
echo.
echo Wait a few moments for both servers to fully start.
echo The React app should open automatically in your browser.
echo.
echo Your existing backend and frontend code is now running!
echo.
echo To stop the servers:
echo 1. Close both command windows, or
echo 2. Press Ctrl+C in each window
echo.

:: Keep this window open to show status
echo Press any key to close this status window (servers will continue running)...
pause >nul