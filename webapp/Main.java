// Bestand: Main.java

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
            resp.getWriter().println("<form method='POST' action='/submit'>");
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
            String username = req.getParameter("user");
            if (username == null || username.isEmpty()) {
                resp.getWriter().println("<p>Lege invoer ontvangen.</p>");
            } else {
                logger.error("Gebruikersinvoer ontvangen: {}", username);
                resp.getWriter().println("<p>Invoer ontvangen. Gelogd.</p>");
            }
        }

        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            doPost(req, resp);
        }
    }
}
