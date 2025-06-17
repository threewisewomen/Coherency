# =================================================================
# Stage 1: The "Workshop" - Build the .NET application
# We use the full SDK image which has all the tools for compiling.
# =================================================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# --- Docker Caching Optimization ---
# Copy only the project and solution files first.
# As long as these files don't change, Docker will use a cached layer
# for the 'dotnet restore' step, massively speeding up subsequent builds.
COPY *.sln .
COPY */*.csproj ./
# This loop handles the project structure where .csproj is inside a folder.
RUN for file in $(ls *.csproj); do mkdir -p ${file%.*}/ && mv $file ${file%.*}/; done

# Restore all NuGet packages for all projects in the solution.
RUN dotnet restore "Coherency.sln"

# Now, copy all the rest of the source code.
COPY . .

# Publish the application. This compiles the code into a release-ready
# format and places the output in the '/app/publish' directory.
RUN dotnet publish "Coherency.sln" -c Release -o /app/publish --no-restore


# =================================================================
# Stage 2: The "Final Vessel" - Create the lightweight runtime image
# We use the lean ASP.NET runtime image, which is much smaller and more secure.
# =================================================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy the compiled output from the 'build' stage into this final image.
COPY --from=build /app/publish .

# --- Security Best Practice ---
# Create a dedicated, non-root user for running the application.
# This follows the Principle of Least Privilege.
RUN useradd -m appuser
USER appuser

# Expose the ports that the Kestrel web server will listen on.
# These match the ports we configure in docker-compose.yml.
EXPOSE 8080
EXPOSE 8081

# This is the command that will be executed when the container starts.
# It tells the .NET runtime to execute our main API's compiled DLL.
ENTRYPOINT ["dotnet", "Coherency.Api.dll"]