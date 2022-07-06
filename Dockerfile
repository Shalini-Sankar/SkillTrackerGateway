#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SkillTrackerGateway.API/SkillTrackerGateway.API.csproj", "SkillTrackerGateway.API/"]
RUN dotnet restore "SkillTrackerGateway.API/SkillTrackerGateway.API.csproj"
COPY . .
WORKDIR "/src/SkillTrackerGateway.API"
RUN dotnet build "SkillTrackerGateway.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SkillTrackerGateway.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SkillTrackerGateway.API.dll"]