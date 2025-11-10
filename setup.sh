#!/bin/bash

echo "====================================="
echo " Truck Loading Optimizer Setup"
echo "====================================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        print_error "Python is not installed or not in PATH"
        echo "Please install Python 3.8+ from https://python.org"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed or not in PATH"
    echo "Please install Node.js 16+ from https://nodejs.org"
    exit 1
fi

print_success "Python and Node.js found!"
echo

# Check if directories exist
if [ ! -d "backend" ]; then
    print_error "Backend directory not found"
    echo "Make sure you're running this from the project root directory"
    exit 1
fi

if [ ! -d "frontend" ]; then
    print_error "Frontend directory not found"
    echo "Make sure you're running this from the project root directory"
    exit 1
fi

# Setup Backend
print_info "STEP 1/3: Setting up Python Backend..."
echo
cd backend

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    print_error "requirements.txt not found in backend directory"
    cd ..
    exit 1
fi

# Check if virtual environment exists
if [ -d "venv" ]; then
    print_info "Virtual environment already exists"
else
    print_info "Creating Python virtual environment..."
    $PYTHON_CMD -m venv venv
    if [ $? -ne 0 ]; then
        print_error "Failed to create virtual environment"
        cd ..
        exit 1
    fi
fi

# Activate virtual environment and install requirements
print_info "Activating virtual environment and installing dependencies..."
source venv/bin/activate

pip install -r requirements.txt
if [ $? -ne 0 ]; then
    print_error "Failed to install Python dependencies"
    cd ..
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_info "Creating backend .env file..."
    cat > .env << EOF
DATABASE_URL=sqlite:///./truck_optimizer.db
SECRET_KEY=local-dev-secret-key-change-for-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
CORS_ORIGINS=["http://localhost:3000"]
EOF
fi

cd ..

# Setup Frontend
echo
print_info "STEP 2/3: Setting up React Frontend..."
echo
cd frontend

# Check if package.json exists
if [ ! -f "package.json" ]; then
    print_error "package.json not found in frontend directory"
    cd ..
    exit 1
fi

print_info "Installing Node.js dependencies..."
npm install
if [ $? -ne 0 ]; then
    print_error "Failed to install Node.js dependencies"
    cd ..
    exit 1
fi

# Create frontend .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_info "Creating frontend .env file..."
    cat > .env << EOF
REACT_APP_API_URL=http://localhost:8000
REACT_APP_ENV=development
GENERATE_SOURCEMAP=false
EOF
fi

cd ..

# Install root dependencies (optional)
echo
print_info "STEP 3/3: Installing root dependencies..."
echo
npm install concurrently 2>/dev/null || print_warning "Failed to install concurrently (optional dependency)"

echo
print_success "====================================="
print_success " Setup Complete!"
print_success "====================================="
echo
echo "Your existing backend and frontend files are ready to use."
echo
echo "Next steps:"
echo "1. Run: ./run.sh"
echo "2. Open browser to: http://localhost:3000"
echo
echo "Backend will be available at: http://localhost:8000"
echo "API docs will be available at: http://localhost:8000/docs"
echo