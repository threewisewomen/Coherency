# Coherency Containerized Project Setup

## Architecture Decision: Separated Backend Strategy

### Why Separate Backend is Optimal for Startups

**✅ Recommended Architecture:**
```
┌─────────────────────────────────────────────────────┐
│                 FRONTEND CLIENTS                    │
├─────────────────┬─────────────────┬─────────────────┤
│   Flutter App   │   React Web     │   Admin Panel   │
│   (Mobile)      │   (Dashboard)   │   (Management)  │
└─────────────────┴─────────────────┴─────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────┐
│              UNIFIED API BACKEND                    │
│            (C# .NET Core / Node.js)                │
│  • RESTful APIs    • GraphQL      • WebSocket      │
│  • Authentication • Authorization • Rate Limiting   │
└─────────────────────────────────────────────────────┘
```

**Benefits of Separated Backend:**
1. **Platform Agnostic**: Same APIs serve mobile, web, desktop, IoT devices
2. **Team Scalability**: Frontend and backend teams can work independently
3. **Technology Flexibility**: Best language/framework for each layer
4. **Investor Appeal**: Demonstrates enterprise-grade architecture
5. **Future-Proof**: Easy to add new client applications
6. **Microservices Ready**: Can split into microservices as you scale

### Technology Stack Recommendation

**Backend Options (Choose One):**

**Option A: C# .NET Core (Recommended for Medical/Enterprise)**
- ✅ Strong typing and compile-time error checking
- ✅ Excellent performance and memory management
- ✅ Rich ecosystem for healthcare integrations
- ✅ Microsoft Azure native support
- ✅ Robust security features for HIPAA compliance
- ✅ Enterprise-grade logging and monitoring

**Option B: Node.js/TypeScript (Recommended for Rapid Development)**
- ✅ Faster development cycles
- ✅ Rich NPM ecosystem
- ✅ JSON-native (perfect for mobile APIs)
- ✅ Real-time features with Socket.IO
- ✅ Excellent for startups needing quick iteration

## Containerized Project Structure

```
coherency-platform/
├── docker-compose.yml              # Multi-service orchestration
├── .env.example                    # Environment variables template
├── .gitignore                      # Git ignore rules
├── README.md                       # Project documentation
├── scripts/                        # Deployment and utility scripts
│   ├── setup.sh                   # Initial setup script
│   ├── deploy.sh                  # Deployment script
│   └── backup.sh                  # Database backup script
│
├── frontend/                       # Flutter Mobile Application
│   ├── Dockerfile                 # Flutter development container
│   ├── docker-compose.override.yml # Local development overrides
│   ├── lib/                       # Flutter application code
│   ├── android/                   # Android configurations
│   ├── ios/                       # iOS configurations
│   ├── test/                      # Test files
│   └── pubspec.yaml              # Flutter dependencies
│
├── backend/                        # API Backend Service
│   ├── Dockerfile                 # Backend container
│   ├── docker-compose.override.yml # Local development overrides
│   ├── src/                       # Source code
│   │   ├── controllers/           # API controllers
│   │   ├── services/              # Business logic
│   │   ├── models/                # Data models
│   │   ├── middleware/            # Custom middleware
│   │   ├── utils/                 # Utilities
│   │   └── config/                # Configuration
│   ├── tests/                     # Backend tests
│   └── package.json              # Dependencies (Node.js) or .csproj (C#)
│
├── database/                       # Database configurations
│   ├── migrations/                # Database migrations
│   ├── seeds/                     # Initial data
│   ├── init.sql                   # Database initialization
│   └── Dockerfile                 # Custom database container
│
├── ai-services/                    # AI/ML Microservices
│   ├── wound-detection/           # LiDAR wound detection service
│   │   ├── Dockerfile            # Python/TensorFlow container
│   │   ├── models/               # ML models
│   │   ├── src/                  # Python source code
│   │   └── requirements.txt      # Python dependencies
│   └── analytics/                # Data analytics service
│       ├── Dockerfile            # Analytics container
│       └── src/                  # Analytics source code
│
├── infrastructure/                 # Infrastructure as Code
│   ├── terraform/                # Terraform configurations
│   ├── kubernetes/               # K8s manifests
│   ├── helm/                     # Helm charts
│   └── monitoring/               # Monitoring configurations
│
├── nginx/                         # Reverse proxy and load balancer
│   ├── Dockerfile                # Nginx container
│   ├── nginx.conf                # Nginx configuration
│   └── ssl/                      # SSL certificates
│
└── docs/                          # Documentation
    ├── api/                      # API documentation
    ├── architecture/             # Architecture diagrams
    ├── deployment/               # Deployment guides
    └── development/              # Development guidelines
```

## Docker Configuration Files

### Root docker-compose.yml
```yaml
version: '3.8'

services:
  # Frontend Development Container
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
      - "8080:8080"  # Flutter web
    volumes:
      - ./frontend:/app
      - flutter_cache:/root/.flutter
    environment:
      - FLUTTER_ENV=development
      - API_BASE_URL=http://backend:5000
    depends_on:
      - backend

  # Backend API Service
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    volumes:
      - ./backend:/app
      - backend_cache:/app/cache
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://coherency:password@postgres:5432/coherency
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=your-jwt-secret-key
    depends_on:
      - postgres
      - redis

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=coherency
      - POSTGRES_USER=coherency
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # AI/ML Wound Detection Service
  ai-wound-detection:
    build:
      context: ./ai-services/wound-detection
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - ./ai-services/wound-detection:/app
      - ai_models:/app/models
    environment:
      - PYTHON_ENV=development
      - MODEL_PATH=/app/models
    depends_on:
      - backend

  # MongoDB for document storage
  mongodb:
    image: mongo:6
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=coherency
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - mongodb_data:/data/db

  # Nginx Reverse Proxy
  nginx:
    build:
      context: ./nginx
      dockerfile: Dockerfile
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend

  # Monitoring and Analytics
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

volumes:
  postgres_data:
  redis_data:
  mongodb_data:
  flutter_cache:
  backend_cache:
  ai_models:
  prometheus_data:
  grafana_data:

networks:
  default:
    driver: bridge
```

### Frontend Dockerfile (Flutter)
```dockerfile
FROM cirrusci/flutter:stable

# Install additional tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN mkdir -p $ANDROID_HOME
RUN curl -o android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
RUN unzip android-sdk.zip -d $ANDROID_HOME
RUN rm android-sdk.zip

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy project files
COPY . .

# Enable web support
RUN flutter config --enable-web

# Expose ports
EXPOSE 3000 8080

# Development command
CMD ["flutter", "run", "--hot", "--web-port=8080", "--web-hostname=0.0.0.0"]
```

### Backend Dockerfile (Node.js)
```dockerfile
FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    postgresql-client

# Install PM2 for production
RUN npm install -g pm2

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Change ownership
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Start application
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
```

### AI Service Dockerfile (Python)
```dockerfile
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libopencv-dev \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Create non-root user
RUN useradd -m -u 1001 python
RUN chown -R python:python /app
USER python

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Start application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Development Workflow

### Initial Setup
```bash
# Clone repository
git clone https://github.com/yourusername/coherency-platform.git
cd coherency-platform

# Copy environment variables
cp .env.example .env

# Build and start all services
docker-compose up --build

# Run database migrations
docker-compose exec backend npm run migrate

# Seed initial data
docker-compose exec backend npm run seed
```

### Development Commands
```bash
# Start development environment
docker-compose up

# Start specific service
docker-compose up frontend backend postgres

# View logs
docker-compose logs -f backend

# Execute commands in container
docker-compose exec backend npm run test
docker-compose exec frontend flutter test

# Reset database
docker-compose down -v
docker-compose up postgres
```

## Production Deployment

### CI/CD Pipeline (GitHub Actions)
```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build and push Docker images
        run: |
          docker build -t coherency/frontend ./frontend
          docker build -t coherency/backend ./backend
          docker build -t coherency/ai-service ./ai-services/wound-detection
          
      - name: Deploy to AWS ECS
        run: |
          # AWS deployment commands
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coherency-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: coherency-backend
  template:
    metadata:
      labels:
        app: coherency-backend
    spec:
      containers:
      - name: backend
        image: coherency/backend:latest
        ports:
        - containerPort: 5000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: coherency-secrets
              key: database-url
```

## Monitoring and Observability

### Health Checks
- Application health endpoints
- Database connectivity checks
- AI service availability
- External API dependencies

### Logging Strategy
- Structured logging with JSON format
- Centralized log aggregation
- Log rotation and retention policies
- Error tracking and alerting

### Metrics and Monitoring
- Application performance metrics
- Infrastructure monitoring
- User behavior analytics
- Medical data access auditing

## Security Considerations

### Container Security
- Non-root user execution
- Minimal base images
- Security scanning
- Secrets management

### Network Security
- Private networks for internal communication
- TLS/SSL for all external communication
- API gateway for authentication
- Rate limiting and DDoS protection

### Data Security
- Encryption at rest and in transit
- HIPAA compliance measures
- Data anonymization
- Secure backup strategies

This containerized setup provides a production-ready, scalable architecture that can grow with your startup while maintaining development efficiency and security standards.