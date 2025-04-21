# Этап 1: Сборка приложения с использованием Maven
FROM maven:3.9-eclipse-temurin-20 AS build
WORKDIR /app
# Копируем pom.xml и загружаем зависимости (кэшируется Docker'ом)
COPY pom.xml .
RUN mvn dependency:go-offline -B
# Копируем исходный код
COPY src ./src
# Собираем приложение (пропускаем тесты для ускорения сборки образа)
RUN mvn package -DskipTests

# Этап 2: Создание финального образа на основе JRE
FROM eclipse-temurin:20-jre-jammy
WORKDIR /app
# Копируем собранный JAR из этапа сборки
COPY --from=build /app/target/*.jar app.jar
# Открываем порт, который слушает приложение (из application.properties/yaml)
EXPOSE 8080
# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
