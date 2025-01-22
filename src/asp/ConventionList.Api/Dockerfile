FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY ConventionList.Api/bin/Release/net8.0/publish/ ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]