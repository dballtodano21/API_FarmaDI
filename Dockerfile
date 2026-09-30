FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos csproj para restaurar dependencias
COPY ["FarmaDiApi/FarmaDiApi.csproj", "FarmaDiApi/"]
COPY ["FarmaDiBusiness/FarmaDiBusiness.csproj", "FarmaDiBusiness/"]
COPY ["FarmaDiCore/FarmaDiCore.csproj", "FarmaDiCore/"]
COPY ["FarmaDiDataAccess/FarmaDiDataAccess.csproj", "FarmaDiDataAccess/"]

# Restaurar dependencias
RUN dotnet restore "FarmaDiApi/FarmaDiApi.csproj"

# Copiar el resto del codigo
COPY . .
WORKDIR "/src/FarmaDiApi"
RUN dotnet publish "FarmaDiApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "FarmaDiApi.dll"]