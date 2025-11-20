package com.notehub.servlet;

import com.notehub.dao.CategoryDAO;
import com.notehub.model.Category;
import com.notehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/categories", "/categories/create", "/categories/store", 
    "/categories/edit", "/categories/update", "/categories/delete"})
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        User user = (User) req.getSession().getAttribute("user");
        
        if (path.equals("/categories")) {
            showIndex(req, resp, user);
        } else if (path.equals("/categories/create")) {
            req.getRequestDispatcher("/categories/create.jsp").forward(req, resp);
        } else if (path.equals("/categories/edit")) {
            showEdit(req, resp, user);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        User user = (User) req.getSession().getAttribute("user");
        
        if (path.equals("/categories/store")) {
            storeCategory(req, resp, user);
        } else if (path.equals("/categories/update")) {
            updateCategory(req, resp, user);
        } else if (path.equals("/categories/delete")) {
            deleteCategory(req, resp, user);
        }
    }
    
    private void showIndex(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findByUserId(user.getId());
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/categories/index.jsp").forward(req, resp);
    }
    
    private void storeCategory(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        String name = req.getParameter("name");
        categoryDAO.create(user.getId(), name);
        resp.sendRedirect(req.getContextPath() + "/categories");
    }
    
    private void showEdit(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Category category = categoryDAO.findById(id);
        
        if (category == null || !category.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        req.setAttribute("cat", category);
        req.getRequestDispatcher("/categories/edit.jsp").forward(req, resp);
    }
    
    private void updateCategory(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Category category = categoryDAO.findById(id);
        
        if (category == null || !category.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String name = req.getParameter("name");
        categoryDAO.update(id, name);
        resp.sendRedirect(req.getContextPath() + "/categories");
    }
    
    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Category category = categoryDAO.findById(id);
        
        if (category == null || !category.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        categoryDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/categories");
    }
}