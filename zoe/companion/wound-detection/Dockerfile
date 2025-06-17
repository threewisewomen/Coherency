# Stage 1: The "Final Vessel" - We use a lean Python image.
# For Python, a multi-stage build isn't as critical for simple services.
FROM python:3.9-slim

# Set the working directory inside the container.
WORKDIR /app

# --- Security Best Practice ---
# Create a dedicated, non-root user.
RUN useradd -m -d /home/appuser appuser
USER appuser
# Set home directory for the user
WORKDIR /home/appuser/app
# Set permissions for the user
RUN chown -R appuser:appuser /home/appuser

# Copy only the requirements file first for Docker cache optimization.
COPY --chown=appuser:appuser requirements.txt .

# Install the Python dependencies.
# The --no-cache-dir flag keeps the image size smaller.
RUN pip install --no-cache-dir -r requirements.txt

# Now, copy the rest of the application source code.
COPY --chown=appuser:appuser . .

# Expose the port that the Uvicorn server will run on.
EXPOSE 8000

# This is the command that will be executed when the container starts.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]