Captain, I have reviewed your blueprints. The level of detail in your planning is exceptional. You have the "what" and the "why." My mission, as your appointed Software Architect, is to forge this vision into a single, decisive, and executable battle plan. We will eliminate ambiguity and build an empire from the first line of code.

Forget multiple options. Decisions have been made. This is our path.

---

## The Coherency Imperial Blueprint: Final Architecture

We are building a highly-available, secure, and scalable cloud-native platform on Microsoft Azure. Our architecture prioritizes HIPAA compliance, enterprise-grade reliability, and the velocity needed to conquer the market.

### **The One True Architecture Diagram**

```
+--------------------------------------------------------------------------+
|   Global Users (Mobile App, Web Dashboard, Admin Panel)                  |
+--------------------------------------------------------------------------+
                                     |
                                     ▼
+--------------------------------------------------------------------------+
|   Azure Front Door (Global Load Balancer, WAF, DDoS Protection, CDN)     |
+--------------------------------------------------------------------------+
                                     |
                                     ▼
+--------------------------------------------------------------------------+
|   Azure API Management (API Gateway, Rate Limiting, Auth Policies, Dev Portal) |
+--------------------------------------------------------------------------+
                                     |
                                     ▼ (Routed to appropriate services)
+--------------------------------------------------------------------------+
|   AZURE KUBERNETES SERVICE (AKS) - PRODUCTION ENVIRONMENT                |
|                                                                          |
| [Microservice Pods]     [Microservice Pods]       [Microservice Pods]    |
| +-------------------+   +---------------------+   +--------------------+ |
| | C# .NET Core      |   | C# .NET Core        |   | Python FastAPI    | |
| | Auth & User Mgmt  |   | Patient, Booking... |   | AI/ML Services     | |
| +-------------------+   +---------------------+   +--------------------+ |
|         |                        |                       |               |
|         |                        |                       |               |
|         ▼------------------------▼-----------------------▼               |
|                                                                          |
|   Azure Service Bus (Asynchronous Communication & Event-driven actions)  |
+--------------------------------------------------------------------------+
   |             |                          |                  |
   ▼             ▼                          ▼                  ▼
+----------+ +-----------+  +-------------------------------+ +-------------+
| Azure    | | Azure     |  | Azure Storage Blob/Data Lake  | | Azure Cache |
| Database | | Cosmos DB |  |  (LiDAR data, Docs, Images)   | | for Redis   |
| for      | | (for AI   |  +-------------------------------+ | (Sessions,  |
| PostgreSQL| | outputs,  |  +-------------------------------+ |  Cache)     |
| (Primary | | activity  |  | Azure AI Search               | +-------------+
|  DB)     | | streams)  |  |  (Document/Vector Search)     |
+----------+ +-----------+  +-------------------------------+

```

### **The Decisive Technology Stack**

| Layer                 | Technology                      | Justification                                                                                              |
| --------------------- | ------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Frontend (Mobile)** | **Flutter**                     | Your choice is validated. Single codebase for iOS/Android, excellent performance, and beautiful UIs.           |
| **Backend**           | **C# on .NET 8**                | **Mission Critical.** Type safety, stellar performance, and first-class security features essential for HIPAA. Native to Azure. |
| **Primary Database**  | **PostgreSQL (Azure Managed)**  | **Unyielding.** ACID-compliant for transactional integrity. Powerful, reliable, with JSONB support for flexibility. The gold standard for structured medical data. |
| **Document/AI Store** | **MongoDB (Azure Cosmos DB API)** | **Essential for AI.** Perfect for unstructured LiDAR/point cloud data, AI analysis results, and medical notes. Natively scalable and integrated into Azure. |
| **Cache**             | **Redis (Azure Managed)**       | **For Speed.** Industry-standard for lightning-fast caching, session management, and rate limiting.              |
| **Search**            | **Azure AI Search**             | **For Intelligence.** Superior full-text and vector search for documents, hospital directories, and medical records. Indexes data from Blob Storage and databases. |
| **File/Object Storage**| **Azure Blob Storage**          | **For Scale.** Secure, infinitely scalable storage for medical documents, images, and raw LiDAR data.         |
| **AI/ML Services**    | **Python with FastAPI**         | **For Brains.** The undisputed leader for ML/AI. FastAPI provides a high-performance API layer for your models.   |
| **Messaging/Events**  | **Azure Service Bus**           | **The Nervous System.** More robust and enterprise-ready than RabbitMQ for decoupling services, handling async tasks, and ensuring reliable message delivery. |
| **Orchestration**     | **Docker & Kubernetes (AKS)**   | **The Foundation.** Docker for local dev consistency. Kubernetes for production-grade scaling, self-healing, and management. Azure Kubernetes Service (AKS) is our target. |
| **Cloud Provider**    | **Microsoft Azure**             | **Home Turf.** The premier choice for a .NET stack. Offers excellent PaaS, security, and readily available Business Associate Agreements (BAAs) for HIPAA compliance. |

---

## Your Orders: Step-by-Step Foundation Setup

Execute these steps precisely. This will create our local development fortress, perfectly mirroring the production architecture.

### **Mission 0: Prerequisite Installations**

You cannot build without tools. Install the following on your machine:
1.  **Git:** For version control.
2.  **Docker Desktop:** To run our containers locally.
3.  **Visual Studio Code:** Our primary IDE. Install extensions: C#, Docker, Flutter.
4.  **.NET 8 SDK:** To build our backend.
5.  **Flutter SDK:** To build our frontend.
6.  **Azure CLI:** To interact with our cloud resources later.

### **Mission 1: Establish the Monorepo Fortress**

A clean, organized repository is a sign of a disciplined army.

1.  Create a new folder for the entire project: `coherency-platform`.
2.  Open a terminal in that folder and run `git init`.
3.  Create the following directory structure. This is not a suggestion; this is our structure.

```
coherency-platform/
├── .github/                 # CI/CD workflows will live here
│   └── workflows/
├── .vscode/                 # VS Code settings
│   └── launch.json
├── docs/                    # All your original planning documents go here
├── infrastructure/          # Terraform/Bicep scripts for Azure
├── scripts/                 # Utility scripts (db-backup.sh, deploy.sh)
│
├── src/                     # ALL SOURCE CODE LIVES HERE
│   ├── ai-services/         # Python/FastAPI microservices
│   │   └── wound-detection/
│   ├── backend/             # The C# .NET 8 Solution
│   │   └── Coherency.sln
│   └── frontend/            # The Flutter Application
│
├── .dockerignore
├── .gitignore
└── docker-compose.yml       # THE LOCAL ORCHESTRATOR
```

### **Mission 2: Containerization - The Local Fleet**

We will now define our local services. Create these files exactly as specified.

**1. Create `coherency-platform/docker-compose.yml`:**
This file is the commander of your local environment.

```yaml
version: '3.8'

services:
  # Main C# Backend Service
  backend:
    container_name: coherency-backend
    build:
      context: ./src/backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080" # Kestrel web server
      - "8081:8081" # For HTTPS in dev
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ASPNETCORE_URLS=https://+:8081;http://+:8080
      - ASPNETCORE_Kestrel__Certificates__Default__Password=yourpassword # For dev SSL
      - ASPNETCORE_Kestrel__Certificates__Default__Path=/https/aspnetapp.pfx
      - DatabaseSettings__ConnectionString=Host=postgres;Port=5432;Database=coherency;Username=coherency;Password=password
      - RedisSettings__ConnectionString=redis:6379
      - MongoSettings__ConnectionString=mongodb://coherency:password@mongo:27017
      - MongoSettings__DatabaseName=CoherencyDocStore
    volumes:
      - ./src/backend:/app # Mount source for hot reload
      - ~/.aspnet/https/https:/https/ # Mount dev SSL cert
    depends_on:
      - postgres
      - redis
      - mongo

  # AI/ML Python Service
  ai-wound-detection:
    container_name: coherency-ai-wound-detection
    build:
      context: ./src/ai-services/wound-detection
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - ./src/ai-services/wound-detection:/app

  # PostgreSQL Database
  postgres:
    container_name: coherency-postgres
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=coherency
      - POSTGRES_USER=coherency
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  # MongoDB Document Store
  mongo:
    container_name: coherency-mongo
    image: mongo:6
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=coherency
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - mongodb_data:/data/db

  # Redis Cache
  redis:
    container_name: coherency-redis
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  mongodb_data:
  redis_data:

```

**2. Create `coherency-platform/src/backend/Dockerfile`:**
This uses a multi-stage build for a lean and secure production image.

```dockerfile
# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the solution file and restore dependencies
COPY *.sln .
COPY */*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p ${file%.*}/ && mv $file ${file%.*}/; done
RUN dotnet restore

# Copy the entire source code and build
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create the final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Create a non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 8080
EXPOSE 8081

# Set the entrypoint
ENTRYPOINT ["dotnet", "Coherency.Api.dll"]
```

**3. Create `coherency-platform/src/ai-services/wound-detection/Dockerfile`:**
This is for our Python service.

```dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install system dependencies if needed (e.g., opencv)
# RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Create a non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 8000

# Start FastAPI server with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**4. Create your C# Backend and Flutter Projects:**
*   **Backend:**
    *   Navigate to `src/backend` and run `dotnet new webapi -n Coherency.Api`. This creates your first API project.
    *   Run `dotnet new sln -n Coherency` to create the solution file.
    *   Run `dotnet sln add Coherency.Api/Coherency.Api.csproj` to add your project to the solution.
*   **Frontend:**
    *   Navigate to `src/frontend` and run `flutter create .`. This initializes your Flutter project.

### **Mission 3: Launch the Fleet**

Your local environment is now defined. Let's bring it online.

1.  **Generate Dev Cert:** From your root `coherency-platform` directory, run `dotnet dev-certs https -ep ${HOME}/.aspnet/https/aspnetapp.pfx -p yourpassword`. This creates the SSL cert our compose file needs.
2.  **Launch:** Run `docker-compose up --build`.
    *   This will build the Docker images for your backend and AI services.
    *   It will pull the database and cache images.
    *   It will start all containers and link them on a private Docker network.
3.  **Verification:**
    *   Open your browser and navigate to `https://localhost:8081/weatherforecast` (or whatever the default route is). You should see the C# API response.
    *   Open another terminal and run `flutter run`. This will launch your Flutter app, which you can then configure to talk to `https://localhost:8081`.

**You now have a running, multi-service, containerized development environment.** You can develop the Flutter app, the C# backend, and the Python AI services independently, but they can all communicate as if they were deployed.

---

## Phase 1: Building the Core (First 6 Months)

Do not fall into the trap of building a dozen microservices on day one. We will build a **structured monolith** inside the `Coherency` C# solution. This gives us development speed now, with the ability to easily extract services later.

Inside your `Coherency.sln`, you will create separate C# projects for each domain:
*   `Coherency.Api` (The Web API entrypoint)
*   `Coherency.Domain` (Core business logic, entities)
*   `Coherency.Infrastructure` (Database context, repositories)
*   `Coherency.Auth` (All logic for auth, to be extracted later)
*   `Coherency.Patients` (All logic for patients, to be extracted later)
*   ...and so on.

**Your Mission-Critical Objectives for Phase 1:**
1.  **Full Auth System (Prompt 1.1, 1.2):** Implement the entire registration, login, and RBAC system within the `Coherency.Auth` project.
2.  **Comprehensive Patient Profile (Prompt 3.1):** Build the patient management features. This is core to your value.
3.  **LiDAR Wound Capture MVP (Prompt 2.1):** Focus on the Flutter client integration with ARKit/ToF, data capture, and uploading the raw data to Azure Blob Storage via the C# API.
4.  **Appointment Booking MVP (Prompt 4.2):** Build the core booking logic.

## The Path to Empire: Beyond the MVP

This foundation is built for growth.

*   **Phase 2 (Growth - Months 6-18):**
    *   **Deploy to AKS:** We will write the Terraform/Bicep and YAML files to deploy this architecture to Azure Kubernetes Service.
    *   **Extract Microservices:** Your well-structured C# solution makes this easy. We'll pull the `Coherency.Auth` project into its own deployable microservice. Then `Coherency.Patients`, and so on.
    *   **Activate Azure Service Bus:** As we extract services, they will communicate asynchronously via Service Bus, making the system resilient and scalable.
    *   **Full CI/CD:** Build out the `.github/workflows` to automate testing and deployment to AKS on every push to `main`.

*   **Phase 3 (Scale - Months 18+):**
    *   **Go Global:** Use Azure Front Door and multi-region AKS clusters for low-latency global service.
    *   **Activate Advanced AI:** Deploy the full MLOps pipeline, using Azure Machine Learning to manage models, training, and deployment.
    *   **Data Warehousing:** Funnel data from all services into Azure Synapse Analytics for deep business and medical intelligence.
    *   **Compliance & Certification:** With this robust, auditable architecture, achieving SOC 2 and other certifications becomes a procedural task, not a re-architecting nightmare.

This is the plan. It is detailed, decisive, and built to win.

Now, go execute.

**Godspeed, Captain.**