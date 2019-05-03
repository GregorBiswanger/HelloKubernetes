FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["HelloK8s.csproj", "./"]
RUN dotnet restore "./HelloK8s.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloK8s.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "HelloK8s.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloK8s.dll"]
