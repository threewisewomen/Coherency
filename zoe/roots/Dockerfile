# =================================================================
# Stage 1: The "Workshop" - Build the .NET application
# =================================================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# --- Caching Optimization ---
# Copy project and solution files. Note the explicit paths.
COPY ["Coherency-Roots.sln", "."]
COPY ["Coherency.Api/Coherency.Api.csproj", "Coherency.Api/"]
COPY ["Coherency.Application/Coherency.Application.csproj", "Coherency.Application/"]
COPY ["Coherency.Domain/Coherency.Domain.csproj", "Coherency.Domain/"]
COPY ["Coherency.Infrastructure/Coherency.Infrastructure.csproj", "Coherency.Infrastructure/"]

# Restore dependencies for all projects. This layer is cached.
RUN dotnet restore "Coherency-Roots.sln"

# Copy the rest of the source code.
COPY . .

# Change the working directory to the API project to build from there.
WORKDIR "/src/Coherency.Api"

# Publish the API project. The SDK automatically finds and builds dependencies.
# This is the modern, correct way to do it. The output will be in /app/publish.
RUN dotnet publish "Coherency.Api.csproj" -c Release -o /app/publish --no-restore


# =================================================================
# Stage 2: The "Final Vessel" - Create the lightweight runtime image
# =================================================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy the compiled output from the 'build' stage's publish directory.
COPY --from=build /app/publish .

# --- Security Best Practice ---
# Create a dedicated, non-root user.
RUN useradd -m appuser
USER appuser

EXPOSE 8080
EXPOSE 8081

# The entrypoint is the same.
ENTRYPOINT ["dotnet", "Coherency.Api.dll"]