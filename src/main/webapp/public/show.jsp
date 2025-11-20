<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="${empty note.title ? 'Shared Note' : note.title}">

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            
            <div class="glass-card p-4 p-md-5 mb-4">
                
                <div class="text-center mb-4 border-bottom border-secondary border-opacity-25 pb-4">
                    <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 rounded-pill px-3 mb-3">
                        <i class="bi bi-globe-americas me-1"></i> Public Note
                    </span>
                    
                    <h1 class="fw-bold text-white display-5 mb-3">
                        ${empty note.title ? '<em class="text-muted">(Untitled Note)</em>' : note.title}
                    </h1>

                    <div class="d-flex justify-content-center gap-2">
                        <span class="badge badge-category rounded-pill text-light fw-normal border border-secondary border-opacity-25 px-3 py-2">
                            <i class="bi bi-folder2-open me-2"></i>
                            ${empty note.category ? 'Uncategorized' : note.category.name}
                        </span>
                    </div>
                </div>

                <div class="markdown content-reader" id="content" style="font-size: 1.15rem; line-height: 1.8; color: #e0e0e0;">
                    </div>

            </div>

            <div class="text-center text-muted mt-5 mb-5">
                <p class="small text-uppercase fw-bold mb-3">Powered by NoteHub</p>
                <div class="glass-card p-3 d-inline-flex align-items-center gap-3" style="background: rgba(0,0,0,0.3);">
                    <span>Want to write your own notes?</span>
                    <div class="vr bg-secondary"></div>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-sm btn-primary fw-bold px-3 rounded-pill">
                        Get Started
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-sm btn-outline-light rounded-pill">
                        Login
                    </a>
                </div>
            </div>

        </div>
    </div>

    <script>
        const rawContent = ${note.content != null ? '"' += note.content.replace('"', '\\"').replace('\n', '\\n') += '"' : '""'};
        
        document.getElementById('content').innerHTML = DOMPurify.sanitize(marked.parse(rawContent));
    </script>

</t:layout>