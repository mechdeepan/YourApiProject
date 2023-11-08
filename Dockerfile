# Use the official ASP.NET runtime image for .NET 6 as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official SDK image for .NET 6 as the build image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["YourApiProject/YourApiProject.csproj", "YourApiProject/"]
RUN dotnet restore "YourApiProject/YourApiProject.csproj"
COPY . .
WORKDIR "/src/YourApiProject"
RUN dotnet build "YourApiProject.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "YourApiProject.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourApiProject.dll"]
