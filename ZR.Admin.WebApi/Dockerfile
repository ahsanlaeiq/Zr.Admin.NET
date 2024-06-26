FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
# Create the /app folder
WORKDIR /app
# Create a mount directory to deploy the program on the local server
# VOLUME /app
# Set the exposed port for the Docker container
EXPOSE 8888
VOLUME /app/logs
# COPY bin/Release/net5.0/publish/ app/
COPY . app/

# Set the timezone inside the container, if not set, the default timezone is 8 hours behind Beijing time
RUN echo "Asia/Shanghai" > /etc/timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Copy the published files to the working directory
# COPY . app/
WORKDIR /app

# Equivalent to "dotnet ZR.Admin.WebApi.dll", if the startup port is not specified, the default port inside the Docker container is 80
ENTRYPOINT ["dotnet", "ZR.Admin.WebApi.dll", "--server.urls", "http://*:8888"]