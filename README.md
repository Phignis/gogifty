# Gogifty

## Introduction

Creation of a database and its associated GUI, to operate on it. The main purpose of this school project was to create from scratch a DataBase, with some excel report sheet giving away order data, bill...

## How to run the application

Firstly, you need to have an SQL server to manage the database. 
In our case, we used [Wampserver](https://www.wampserver.com/). The project was implemented using Spring Boot. Once the project is cloned, open it using a code editor such as IntelliJ or Eclipse IDE for Java developers. Serveur is listening on localhost port 8081. To launch it, you need to create a configuration with the command "spring-boot:run."

Example with IntelliJ:

![image](https://github.com/Phignis/gogifty/assets/119361788/bb33c559-5b71-499b-a7a2-f974aa1ff3fe)

Before being able to manipulate the application, you also need to start your MySQL server (it is set up on port 3306). Then, import the script located in src/main/resources/static/database/Script.sql.

Example with Wampserver:

<img width="332" alt="image" src="https://github.com/Phignis/gogifty/assets/119361788/f81c1a4f-1d44-41b3-bed0-130e0e9cf350">

## How to use the application

Once all the above steps have been completed, you can access the application using the URL http://localhost:8081/ and perform operations such as updating information for a customer or salesman.
