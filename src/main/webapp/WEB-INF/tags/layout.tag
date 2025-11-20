<%@ tag description="Layout Template" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> 

<%@ attribute name="title" required="false" %>
<%@ attribute name="fullPage" required="false" type="java.lang.Boolean" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/logo.png">
    <title>${empty title ? 'NoteHub' : title}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dompurify@3/dist/purify.min.js"></script>
    
    <style>
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #121212; 
            color: #e0e0e0;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        .global-bg {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .glass-navbar {
            background: rgba(20, 20, 20, 0.8) !important;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            transition: background 0.3s ease;
        }

        .glass-card {
            background: rgba(35, 35, 45, 0.6);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }

        .glass-card:hover {
            border-color: rgba(0, 210, 255, 0.3);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
        }

        h1, h2, h3, h4, h5, h6, strong, .navbar-brand { color: #fff !important; letter-spacing: 0.5px; }
        .text-muted { color: #adb5bd !important; }
        p { color: #e0e0e0; }

        .form-control, .form-select {
            background-color: rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff !important; /* Paksa text putih */
        }
        .form-control:focus, .form-select:focus {
            background-color: rgba(0, 0, 0, 0.5);
            color: #fff !important;
            border-color: #00d2ff;
            box-shadow: 0 0 0 0.25rem rgba(0, 210, 255, 0.25);
        }
        .form-control::placeholder { color: #888; }
        
        .btn-primary {
            background: linear-gradient(45deg, #00d2ff, #3a7bd5);
            border: none;
            font-weight: 600;
            color: #ffffff !important; /* FIX UTAMA: Warna teks putih */
        }
        
        .btn-gradient {
            background: linear-gradient(90deg, #00d2ff 0%, #3a7bd5 100%);
            border: none;
            color: #ffffff !important; /* FIX UTAMA: Warna teks putih */
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover, .btn-gradient:hover {
            background: linear-gradient(45deg, #3a7bd5, #00d2ff); /* Tukar arah gradient */
            box-shadow: 0 0 15px rgba(0, 210, 255, 0.5);
            color: #ffffff !important;
            transform: translateY(-1px);
        }
        
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #121212; }
        ::-webkit-scrollbar-thumb { background: #444; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #00d2ff; }
        
        .markdown { background: transparent; color: #e0e0e0; }
        .markdown code { color: #ff79c6; background: rgba(255,255,255,0.1); padding: 2px 4px; border-radius: 4px; }
        .markdown pre { background: #1e1e1e; padding: 15px; border-radius: 8px; border: 1px solid #333; }
        .markdown blockquote { border-left: 4px solid #00d2ff; padding-left: 1rem; color: #aaa; }
    </style>
</head>
<body>
    
    <div class="global-bg"></div>

    <nav class="navbar navbar-expand-lg navbar-dark fixed-top glass-navbar">
        <div class="container">
            <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/notes">
                <img src="${pageContext.request.contextPath}/assets/logo.png" 
                    alt="Logo" 
                    height="35" 
                    class="d-inline-block align-text-top me-2">
                
                <span style="background: linear-gradient(to right, #fff, #aaa); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    NoteHub
                </span>
            </a>
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/notes">My Notes</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a></li>
                    </c:if>
                </ul>
                <div class="d-flex align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <button class="btn btn-link text-decoration-none text-white dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                                    <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 30px; height: 30px; font-size: 0.8rem;">
                                        ${fn:substring(sessionScope.user.name, 0, 1)}
                                    </div>
                                    ${sessionScope.user.name}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark shadow-lg border-secondary border-opacity-25" style="background: rgba(30,30,30,0.95);">
                                    <li>
                                        <form method="post" action="${pageContext.request.contextPath}/auth/logout">
                                            <button class="dropdown-item text-danger"><i class="bi bi-box-arrow-right me-2"></i>Logout</button>
                                        </form>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-outline-light btn-sm me-2 rounded-pill px-3" href="${pageContext.request.contextPath}/auth/login">Login</a>
                            <a class="btn btn-primary btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/auth/register">Sign Up</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <main class="${fullPage ? 'p-0' : 'container'}" style="${fullPage ? '' : 'padding-top: 100px; padding-bottom: 50px;'}">
        <c:if test="${not empty sessionScope.status}">
            <div class="alert alert-info alert-dismissible fade show glass-card border-0 text-info mb-4" role="alert">
                <i class="bi bi-bell-fill me-2"></i> ${sessionScope.status}
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="status" scope="session"/>
        </c:if>
        <jsp:doBody/>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>