package com.notehub.servlet;

import com.notehub.dao.UserDAO;
import com.notehub.model.User;
import com.notehub.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/auth/login", "/auth/register", "/auth/logout"})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        
        if (path.equals("/auth/login")) {
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
        } else if (path.equals("/auth/register")) {
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        
        if (path.equals("/auth/login")) {
            handleLogin(req, resp);
        } else if (path.equals("/auth/register")) {
            handleRegister(req, resp);
        } else if (path.equals("/auth/logout")) {
            handleLogout(req, resp);
        }
    }
    
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        User user = userDAO.findByEmail(email);
        
        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/notes");
        } else {
            req.setAttribute("error", "Email atau password salah");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
        }
    }
    
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String passwordConfirmation = req.getParameter("password_confirmation");
        
        if (!password.equals(passwordConfirmation)) {
            req.setAttribute("error", "Password tidak cocok");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }
        
        if (userDAO.findByEmail(email) != null) {
            req.setAttribute("error", "Email sudah terdaftar");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }
        
        User user = userDAO.create(name, email, password);
        HttpSession session = req.getSession();
        session.setAttribute("user", user);
        resp.sendRedirect(req.getContextPath() + "/notes");
    }
    
    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}