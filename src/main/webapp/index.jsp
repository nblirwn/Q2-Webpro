<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/notes");
    } else {
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }
%>