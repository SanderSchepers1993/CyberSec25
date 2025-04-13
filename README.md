/*
Project structure:
- Dockerfile
- log4shell-webapp/
  - pom.xml (not needed, no Maven)
  - src/
    - Main.java
    - web/
      - index.html
      
To build & run:
$ docker build -t log4shell-webform .
$ docker run -p 8080:8080 log4shell-webform
*/
