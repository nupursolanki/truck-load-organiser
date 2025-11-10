@echo off
echo =====================================
echo  Truck Loading Optimizer Setup
echo =====================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
)

:: Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH
    echo Please install Node.js 16+ from https://nodejs.org
    pause
    exit /b 1
)

echo [INFO] Python and Node.js found!
echo.

:: Check if backend directory exists
if not exist "backend" (
    echo [ERROR] Backend directory not found
    echo Make sure you're running this from the project root directory
    pause
    exit /b 1
)

:: Check if frontend directory exists
if not exist "frontend" (
    echo [ERROR] Frontend directory not found
    echo Make sure you're running this from the project root directory
    pause
    exit /b 1
)

:: Setup Backend
echo [STEP 1/3] Setting up Python Backend...
echo.
cd backend

:: Check if requirements.txt exists
if not exist "requirements.txt" (
    echo [ERROR] requirements.txt not found in backend directory
    cd ..
    pause
    exit /b 1
)

:: Check if virtual environment exists
if exist "venv" (
    echo [INFO] Virtual environment already exists
) else (
    echo [INFO] Creating Python virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment
        cd ..
        pause
        exit /b 1
    )
)

:: Activate virtual environment and install requirements
echo [INFO] Activating virtual environment and installing dependencies...
call venv\Scripts\activate.bat
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Python dependencies
    cd ..
    pause
    exit /b 1
)

:: Create .env file if it doesn't exist
if not exist ".env" (
    echo [INFO] Creating backend .env file...
    echo DATABASE_URL=sqlite:///./truck_optimizer.db > .env
    echo SECRET_KEY=local-dev-secret-key-change-for-production >> .env
    echo ALGORITHM=HS256 >> .env
    echo ACCESS_TOKEN_EXPIRE_MINUTES=30 >> .env
    echo CORS_ORIGINS=["http://localhost:3000"] >> .env
)

cd ..

:: Setup Frontend
echo.
echo [STEP 2/3] Setting up React Frontend...
echo.
cd frontend

:: Check if package.json exists
if not exist "package.json" (
    echo [ERROR] package.json not found in frontend directory
    cd ..
    pause
    exit /b 1
)

echo [INFO] Installing Node.js dependencies...
npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Node.js dependencies
    cd ..
    pause
    exit /b 1
)

:: Create frontend .env file if it doesn't exist
if not exist ".env" (
    echo [INFO] Creating frontend .env file...
    echo REACT_APP_API_URL=http://localhost:8000 > .env
    echo REACT_APP_ENV=development >> .env
    echo GENERATE_SOURCEMAP=false >> .env
)

cd ..

:: Install root dependencies (optional)
echo.
echo [STEP 3/3] Installing root dependencies...
echo.
npm install concurrently
if %errorlevel% neq 0 (
    echo [WARNING] Failed to install concurrently (optional dependency)
)

echo.
echo =====================================
echo  Setup Complete!
echo =====================================
echo.
echo Your existing backend and frontend files are ready to use.
echo.
echo Next steps:
echo 1. Run: run.bat
echo 2. Open browser to: http://localhost:3000
echo.
echo Backend will be available at: http://localhost:8000
echo API docs will be available at: http://localhost:8000/docs
echo.
pause