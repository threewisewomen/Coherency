# ============================
# Stage 1: Build .NET Backend
# ============================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and csproj files
COPY ["Coherency-Roots.sln", "."]
COPY ["Coherency.Api/Coherency.Api.csproj", "Coherency.Api/"]
COPY ["Coherency.Application/Coherency.Application.csproj", "Coherency.Application/"]
COPY ["Coherency.Domain/Coherency.Domain.csproj", "Coherency.Domain/"]
COPY ["Coherency.Infrastructure/Coherency.Infrastructure.csproj", "Coherency.Infrastructure/"]

# Restore project dependencies
WORKDIR /src/Coherency.Api
RUN dotnet restore "Coherency.Api.csproj"

# Copy the rest of the source
WORKDIR /src
COPY . .

# OPTIONAL: Comment this out until code exists
# RUN dotnet publish "Coherency.Api.csproj" -c Release -o /app/publish

# ======================================
# Stage 2: Runtime Image (Inactive ATM)
# ======================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published files if the app builds (commented out for now)
# COPY --from=build /app/publish .

# Create non-root user (future-proofing)
RUN useradd -m appuser
USER appuser

EXPOSE 8080
EXPOSE 8081

# Entrypoint will fail for now—comment until backend is ready
# ENTRYPOINT ["dotnet", "Coherency.Api.dll"]