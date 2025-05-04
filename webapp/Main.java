/*
Project structure:
- Dockerfile
- log4shell-webapp/
  - Main.java
  - log4j2.xml
  - libs/ (contains downloaded dependencies)

To build & run without Docker:
$ sudo apt update && sudo apt install default-jdk wget -y
$ mkdir libs && cd libs

# Download Jetty dependencies
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.4.44.v20210927/jetty-server-9.4.44.v20210927.jar
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.44.v20210927/jetty-servlet-9.4.44.v20210927.jar
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.4.44.v20210927/jetty-http-9.4.44.v20210927.jar
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.4.44.v20210927/jetty-io-9.4.44.v20210927.jar
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.4.44.v20210927/jetty-util-9.4.44.v20210927.jar
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/9.4.44.v20210927/jetty-security-9.4.44.v20210927.jar

# Download Log4j dependencies
wget https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.jar
wget https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar

# Download Servlet API
wget https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

cd ..

# Compile and run
$ javac -cp "libs/*" Main.java
$ java -cp ".:libs/*" -Dlog4j.configurationFile=log4j2.xml Main
*/

// File: Main.java

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Main {
    public static void main(String[] args) throws Exception {
        Server server = new Server(8080);
        ServletContextHandler handler = new ServletContextHandler(ServletContextHandler.SESSIONS);
        handler.setContextPath("/");

        handler.addServlet(new ServletHolder(new IndexServlet()), "/");
        handler.addServlet(new ServletHolder(new SubmitServlet()), "/submit");

        server.setHandler(handler);
        server.start();
        server.join();
    }

    @WebServlet(name = "IndexServlet", urlPatterns = {"/"})
    public static class IndexServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            resp.setContentType("text/html");
                resp.getWriter().println("<html>");
                resp.getWriter().println("<head><title>Kwetsbare Webapp</title></head>");
                resp.getWriter().println("<body>");
                resp.getWriter().println("<h1>Log4Shell demo</h1>");
                resp.getWriter().println("<form method='GET'>");
                resp.getWriter().println("<label for='user'>Gebruikersnaam:</label>");
                resp.getWriter().println("<input type='text' name='user' />");
                resp.getWriter().println("<input type='submit' />");
                resp.getWriter().println("</form>");
                resp.getWriter().println("</body>");
                resp.getWriter().println("</html>");
        }
    }

    @WebServlet(name = "SubmitServlet", urlPatterns = {"/submit"})
    public static class SubmitServlet extends HttpServlet {
        private static final Logger logger = LogManager.getLogger(SubmitServlet.class);

        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            String username = req.getParameter("username");
            if (username == null || username.isEmpty() || username.contains("$")) {
                logger.error("Invalid username received: {}", username);
                resp.getWriter().println("<p>Invalid input. Logged for audit.</p>");
            } else {
                resp.getWriter().println("<p>Welcome, " + username + "</p>");
            }
        }
    }
}
