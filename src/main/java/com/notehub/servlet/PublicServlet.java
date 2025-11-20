package com.notehub.servlet;

import com.notehub.dao.NoteDAO;
import com.notehub.model.Note;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/public/*"})
public class PublicServlet extends HttpServlet {
    private NoteDAO noteDAO = new NoteDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String token = pathInfo.substring(1);
        Note note = noteDAO.findByShareToken(token);
        
        if (note == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        req.setAttribute("note", note);
        req.getRequestDispatcher("/public/show.jsp").forward(req, resp);
    }
}