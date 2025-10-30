#Dockerfile simples para deploy no render

#Usa imagem maven para complilar o projeto
FROM maven:3.9.9-eclipse-temurin-21 AS build

#Define o diretório de trabalho dentro do container
WORKDIR /app

#Copia os arquivos do projeto para o diretório de trabalho
COPY . .

#Compila o projeto e empacota(gera o JAR), ignorando os testes
RUN mvn clean package -DskipTests

#Usa a imagem do Eclipse Temurin JRE para rodar a aplicação (Apenas o Java Runtime)
FROM eclipse-temurin:21-jre

#Copia o JAR gerado na etapa de build para o diretório raiz do novo container
COPY --from=build /app/target/*.jar app.jar

# Informa ao Docker que a aplicação irá escutar na porta 8080
EXPOSE 8080

#Comando para rodar a aplicação Java
ENTRYPOINT [ "jar", "-jar", "app.jar" ]