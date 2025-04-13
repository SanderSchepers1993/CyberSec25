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
            resp.getWriter().println("""
                <html><body>
                <h2>Enter Username</h2>
                <form method='POST' action='/submit'>
                    <input type='text' name='username' />
                    <input type='submit' />
                </form>
                </body></html>
            """);
        }
    }

    @WebServlet(name = "SubmitServlet", urlPatterns = {"/submit"})
    public static class SubmitServlet extends HttpServlet {
        private static final Logger logger = LogManager.getLogger(SubmitServlet.class);

        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            String username = req.getParameter("username");
            if (username == null || username.isEmpty() || username.contains("@")) {
                logger.error("Invalid username received: {}", username);
                resp.getWriter().println("<p>Invalid input. Logged for audit.</p>");
            } else {
                resp.getWriter().println("<p>Welcome, " + username + "</p>");
            }
        }
    }
} 
