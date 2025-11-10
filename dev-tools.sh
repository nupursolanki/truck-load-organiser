#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_menu() {
    echo "====================================="
    echo " Truck Loading Optimizer Dev Tools"
    echo "====================================="
    echo
    echo "Choose an option:"
    echo
    echo "1. Setup Project (First time)"
    echo "2. Start Development Servers"
    echo "3. Start Backend Only"
    echo "4. Start Frontend Only" 
    echo "5. Install Dependencies"
    echo "6. Clean Project"
    echo "7. Reset Database"
    echo "8. View Logs"
    echo "9. Check Project Status"
    echo "0. Exit"
    echo
}

setup_project() {
    echo
    print_info "Running full project setup..."
    ./setup.sh
}

start_all() {
    echo
    print_info "Starting both servers..."
    ./run.sh
}

start_backend() {
    echo
    print_info "Starting backend server only..."
    cd backend
    source venv/bin/activate
    python server.py
    cd ..
}

start_frontend() {
    echo
    print_info "Starting frontend server only..."
    cd frontend
    npm start
    cd ..
}

install_deps() {
    echo
    print_info "Installing/updating dependencies..."
    cd backend
    source venv/bin/activate
    pip install -r requirements.txt
    cd ../frontend
    npm install
    cd ..
    print_success "Dependencies updated!"
}

clean_project() {
    echo
    print_warning "This will remove:"
    echo "- node_modules"
    echo "- build files"
    echo "- Python cache"
    echo "- log files"
    echo "- database file"
    echo
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf frontend/node_modules
        rm -rf frontend/build
        rm -rf backend/__pycache__
        rm -rf backend/.pytest_cache
        rm -rf logs
        rm -f backend/truck_optimizer.db
        print_success "Project cleaned!"
    else
        print_info "Clean cancelled."
    fi
}

reset_database() {
    echo
    print_warning "This will delete all data!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "backend/truck_optimizer.db" ]; then
            rm backend/truck_optimizer.db
            print_success "Database reset!"
        else
            print_info "No database file found."
        fi
    else
        print_info "Database reset cancelled."
    fi
}

view_logs() {
    echo
    print_info "Available logs:"
    if [ -d "logs" ] && [ "$(ls -A logs)" ]; then
        ls -la logs/
        echo
        read -p "Enter log filename to view (or press Enter to skip): " logfile
        if [ ! -z "$logfile" ] && [ -f "logs/$logfile" ]; then
            less "logs/$logfile"
        elif [ ! -z "$logfile" ]; then
            print_error "Log file not found."
        fi
    else
        print_info "No logs directory or log files found."
    fi
}

check_status() {
    echo
    print_info "Project Status:"
    echo

    # Check backend setup
    if [ -d "backend/venv" ]; then
        echo -e "✓ Backend virtual environment: ${GREEN}EXISTS${NC}"
    else
        echo -e "✗ Backend virtual environment: ${RED}MISSING${NC}"
    fi

    # Check frontend setup
    if [ -d "frontend/node_modules" ]; then
        echo -e "✓ Frontend dependencies: ${GREEN}INSTALLED${NC}"
    else
        echo -e "✗ Frontend dependencies: ${RED}MISSING${NC}"
    fi

    # Check environment files
    if [ -f "backend/.env" ]; then
        echo -e "✓ Backend .env: ${GREEN}EXISTS${NC}"
    else
        echo -e "✗ Backend .env: ${RED}MISSING${NC}"
    fi

    if [ -f "frontend/.env" ]; then
        echo -e "✓ Frontend .env: ${GREEN}EXISTS${NC}"
    else
        echo -e "✗ Frontend .env: ${RED}MISSING${NC}"
    fi

    echo
    echo "Port Status:"
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
        echo -e "✓ Backend port 8000: ${YELLOW}IN USE${NC}"
    else
        echo -e "✗ Backend port 8000: ${GREEN}FREE${NC}"
    fi

    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null ; then
        echo -e "✓ Frontend port 3000: ${YELLOW}IN USE${NC}"
    else
        echo -e "✗ Frontend port 3000: ${GREEN}FREE${NC}"
    fi

    # Check database
    if [ -f "backend/truck_optimizer.db" ]; then
        echo -e "✓ Database: ${GREEN}EXISTS${NC}"
    else
        echo -e "✗ Database: ${YELLOW}NOT CREATED YET${NC}"
    fi
}

# Make script executable
chmod +x setup.sh run.sh 2>/dev/null || true

# Main loop
while true; do
    show_menu
    read -p "Enter your choice (0-9): " choice
    
    case $choice in
        1) setup_project ;;
        2) start_all ;;
        3) start_backend ;;
        4) start_frontend ;;
        5) install_deps ;;
        6) clean_project ;;
        7) reset_database ;;
        8) view_logs ;;
        9) check_status ;;
        0) 
            echo
            print_info "Goodbye!"
            exit 0
            ;;
        *) 
            print_error "Invalid option. Please choose 0-9."
            ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
done