#!/bin/bash

echo "====================================="
echo " Truck Loading Optimizer Runner"
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

# Check if backend and frontend directories exist
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

# Check if setup has been run
if [ ! -d "backend/venv" ]; then
    print_error "Backend virtual environment not found"
    echo "Please run ./setup.sh first"
    exit 1
fi

if [ ! -d "frontend/node_modules" ]; then
    print_error "Frontend node_modules not found"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Check if main.py exists
if [ ! -f "backend/main.py" ]; then
    print_error "backend/main.py not found"
    echo "Make sure your backend files are in the backend directory"
    exit 1
fi

# Check if frontend package.json exists
if [ ! -f "frontend/package.json" ]; then
    print_error "frontend/package.json not found"
    echo "Make sure your frontend files are in the frontend directory"
    exit 1
fi

print_info "Starting Truck Loading Optimizer..."
echo
echo "Backend will be available at: http://localhost:8000"
echo "Frontend will be available at: http://localhost:3000"  
echo "API Documentation at: http://localhost:8000/docs"
echo
echo "Press Ctrl+C to stop both servers"
echo

# Function to cleanup background processes
cleanup() {
    print_warning "Shutting down servers..."
    
    # Kill backend process
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        wait $BACKEND_PID 2>/dev/null
        print_info "Backend server stopped"
    fi
    
    # Kill frontend process  
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
        wait $FRONTEND_PID 2>/dev/null
        print_info "Frontend server stopped"
    fi
    
    # Kill any remaining node or python processes on our ports
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    
    print_success "All servers stopped"
    exit 0
}

# Set trap to cleanup on exit
trap cleanup SIGINT SIGTERM EXIT

# Start Backend Server
print_info "Starting Python FastAPI Backend..."
cd backend
source venv/bin/activate

# Start backend in background
echo "[BACKEND] Starting server on port 8000..."
python main.py &
BACKEND_PID=$!

# Check if backend started successfully
sleep 3
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    print_error "Backend server failed to start"
    exit 1
fi

cd ..

# Start Frontend Server
print_info "Starting React Frontend..."
cd frontend

# Start frontend in background
echo "[FRONTEND] Starting React development server on port 3000..."
npm start &
FRONTEND_PID=$!

# Check if frontend started successfully
sleep 3
if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    print_error "Frontend server failed to start"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

cd ..

echo
print_success "Both servers are running!"
echo
echo "====================================="
echo " Server Status"
echo "====================================="
echo "Backend Server: Running (PID: $BACKEND_PID)"
echo "Frontend Server: Running (PID: $FRONTEND_PID)"
echo
echo "The React app should open automatically in your browser."
echo "If not, manually open: http://localhost:3000"
echo
echo "Your existing backend and frontend code is now running!"
echo
echo "To stop the servers, press Ctrl+C"
echo

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
echo "Frontend will be available at: http://localhost:3000"  
echo "API Documentation at: http://localhost:8000/docs"
echo
echo "Press Ctrl+C to stop both servers"
echo

# Function to cleanup background processes
cleanup() {
    print_warning "Shutting down servers..."
    
    # Kill backend process
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        wait $BACKEND_PID 2>/dev/null
        print_info "Backend server stopped"
    fi
    
    # Kill frontend process  
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
        wait $FRONTEND_PID 2>/dev/null
        print_info "Frontend server stopped"
    fi
    
    # Kill any remaining node or python processes on our ports
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    
    print_success "All servers stopped"
    exit 0
}

# Set trap to cleanup on exit
trap cleanup SIGINT SIGTERM EXIT

# Start Backend Server
print_info "Starting Python FastAPI Backend..."
cd backend
source venv/bin/activate

# Start backend in background
echo "[BACKEND] Starting server on port 8000..."
python server.py &
BACKEND_PID=$!

# Check if backend started successfully
sleep 3
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    print_error "Backend server failed to start"
    exit 1
fi

cd ..

# Start Frontend Server
print_info "Starting React Frontend..."
cd frontend

# Start frontend in background
echo "[FRONTEND] Starting React development server on port 3000..."
npm start &
FRONTEND_PID=$!

# Check if frontend started successfully
sleep 3
if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    print_error "Frontend server failed to start"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

cd ..

echo
print_success "Both servers are running!"
echo
echo "====================================="
echo " Server Status"
echo "====================================="
echo "Backend Server: Running (PID: $BACKEND_PID)"
echo "Frontend Server: Running (PID: $FRONTEND_PID)"
echo
echo "The React app should open automatically in your browser."
echo "If not, manually open: http://localhost:3000"
echo
echo "To stop the servers, press Ctrl+C"
echo

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID