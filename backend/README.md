# backend

SparkServer

## Getting Started

- [Setting up Spark Server](https://sparkjava.com/documentation#getting-started)
- [Connecting to SQL database](https://sparkjava.com/tutorials/sql2o-database)

## Developer Instruction

### File structure
- Data Access Object (DAO): model database entities
- Data Transfer Object (DTO): model HTTP request and response entities

### How to spin up the server
1. Sign in to your gcloud account. Make sure you have IAM access to the database
2. Add environment variable such as database password. Contact @John if you don't know the secret strings
3. run SparkServer

### Dependences:
Lombok:
Lombok is an annotation based library that simplify writing boilerplate code such as setter/getter.

