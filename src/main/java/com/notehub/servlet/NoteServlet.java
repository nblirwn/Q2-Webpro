package com.notehub.servlet;

import com.notehub.dao.*;
import com.notehub.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/notes", "/notes/create", "/notes/store", "/notes/show", 
    "/notes/edit", "/notes/update", "/notes/delete", "/notes/pin", "/notes/archive", 
    "/notes/restore", "/notes/share", "/notes/unshare"})
public class NoteServlet extends HttpServlet {
    private NoteDAO noteDAO = new NoteDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        User user = (User) req.getSession().getAttribute("user");
        
        if (path.equals("/notes")) {
            showIndex(req, resp, user);
        } else if (path.equals("/notes/create")) {
            showCreate(req, resp, user);
        } else if (path.equals("/notes/show")) {
            showNote(req, resp, user);
        } else if (path.equals("/notes/edit")) {
            showEdit(req, resp, user);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String path = req.getServletPath();
        User user = (User) req.getSession().getAttribute("user");
        
        if (path.equals("/notes/store")) {
            storeNote(req, resp, user);
        } else if (path.equals("/notes/update")) {
            updateNote(req, resp, user);
        } else if (path.equals("/notes/delete")) {
            deleteNote(req, resp, user);
        } else if (path.equals("/notes/pin")) {
            togglePin(req, resp, user);
        } else if (path.equals("/notes/archive")) {
            archiveNote(req, resp, user);
        } else if (path.equals("/notes/restore")) {
            restoreNote(req, resp, user);
        } else if (path.equals("/notes/share")) {
            shareNote(req, resp, user);
        } else if (path.equals("/notes/unshare")) {
            unshareNote(req, resp, user);
        }
    }
    
    private void showIndex(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        String query = req.getParameter("q");
        String catParam = req.getParameter("cat");
        String tag = req.getParameter("tag");
        boolean archived = "1".equals(req.getParameter("archived"));
        
        Long categoryId = null;
        if (catParam != null && !catParam.isEmpty()) {
            try {
                categoryId = Long.parseLong(catParam);
            } catch (NumberFormatException e) {}
        }
        
        List<Note> notes = noteDAO.findByUserId(user.getId(), query, categoryId, tag, archived);
        List<Category> categories = categoryDAO.findByUserId(user.getId());
        
        req.setAttribute("notes", notes);
        req.setAttribute("categories", categories);
        req.setAttribute("q", query);
        req.setAttribute("cat", catParam);
        req.setAttribute("tag", tag);
        req.setAttribute("archived", archived);
        
        req.getRequestDispatcher("/notes/index.jsp").forward(req, resp);
    }
    
    private void showCreate(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findByUserId(user.getId());
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/notes/create.jsp").forward(req, resp);
    }
    
    private void storeNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String categoryParam = req.getParameter("category_id");
        String tags = req.getParameter("tags");
        
        Long categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryParam);
            } catch (NumberFormatException e) {}
        }
        
        Note note = noteDAO.create(user.getId(), categoryId, title, content);
        noteDAO.syncTags(note.getId(), user.getId(), tags);
        
        resp.sendRedirect(req.getContextPath() + "/notes");
    }
    
    private void showNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String content = note.getContent();
        String escapedContent = "";
        if (content != null) {
            escapedContent = content
                .replace("\\", "\\\\") 
                .replace("\"", "\\\"") 
                .replace("\n", "\\n") 
                .replace("\r", "");   
        }
        
        req.setAttribute("escapedContent", escapedContent);
        req.setAttribute("note", note);
        req.getRequestDispatcher("/notes/show.jsp").forward(req, resp);
    }
    
    private void showEdit(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String content = note.getContent();
        String escapedContent = "";

        if (content != null) {
            escapedContent = content
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
        }
        req.setAttribute("escapedContent", escapedContent);

        List<Category> categories = categoryDAO.findByUserId(user.getId());
        StringBuilder tagsStr = new StringBuilder();
        for (int i = 0; i < note.getTags().size(); i++) {
            if (i > 0) tagsStr.append(",");
            tagsStr.append(note.getTags().get(i).getName());
        }
        
        req.setAttribute("note", note);
        req.setAttribute("categories", categories);
        req.setAttribute("tags", tagsStr.toString());
        req.getRequestDispatcher("/notes/edit.jsp").forward(req, resp);
    }
    
    private void updateNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String categoryParam = req.getParameter("category_id");
        String tags = req.getParameter("tags");
        
        Long categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryParam);
            } catch (NumberFormatException e) {}
        }
        
        noteDAO.update(id, categoryId, title, content);
        noteDAO.syncTags(id, user.getId(), tags);
        
        resp.sendRedirect(req.getContextPath() + "/notes");
    }
    
    private void deleteNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        noteDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/notes");
    }
    
    private void togglePin(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        noteDAO.togglePin(id);
        resp.sendRedirect(req.getHeader("referer"));
    }
    
    private void archiveNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        noteDAO.archive(id);
        resp.sendRedirect(req.getHeader("referer"));
    }
    
    private void restoreNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        noteDAO.restore(id);
        req.getSession().setAttribute("status", "Restored");
        resp.sendRedirect(req.getHeader("referer"));
    }
    
    private void shareNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String token = noteDAO.generateShareToken(id);
        req.getSession().setAttribute("status", 
            "Share link dibuat: " + req.getContextPath() + "/public/" + token);
        resp.sendRedirect(req.getHeader("referer"));
    }
    
    private void unshareNote(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Note note = noteDAO.findById(id);
        
        if (note == null || !note.getUserId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        noteDAO.removeShareToken(id);
        resp.sendRedirect(req.getHeader("referer"));
    }
}