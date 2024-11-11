FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["Holamundo_CS/Holamundo_CS.csproj", "Holamundo_CS/"]
RUN dotnet restore "Holamundo_CS/Holamundo_CS.csproj"

COPY . .
WORKDIR "/src/Holamundo_CS"
RUN dotnet build "Holamundo_CS.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "Holamundo_CS.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Holamundo_CS.dll"]