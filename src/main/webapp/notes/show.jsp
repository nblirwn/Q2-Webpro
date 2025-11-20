<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="${note.title}">
    
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="glass-card p-4 p-md-5">
                
                <div class="mb-4 border-bottom border-secondary border-opacity-25 pb-4">
                    <div class="d-flex justify-content-between align-items-start">
                        <h1 class="fw-bold text-white mb-2 display-6">
                            ${empty note.title ? '<em class="text-muted">(Untitled)</em>' : note.title}
                        </h1>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/notes/edit?id=${note.id}" class="btn btn-outline-warning btn-sm">
                                <i class="bi bi-pencil-square"></i> Edit
                            </a>
                            <a href="${pageContext.request.contextPath}/notes" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-3 mt-2 text-muted small">
                        <span class="d-flex align-items-center">
                            <i class="bi bi-folder2-open me-1"></i>
                            ${empty note.category ? 'Uncategorized' : note.category.name}
                        </span>
                        
                        <c:if test="${not empty note.tags}">
                            <span class="border-start border-secondary border-opacity-50 mx-1" style="height: 15px;"></span>
                            <div class="d-flex gap-1">
                                <c:forEach var="t" items="${note.tags}">
                                    <span class="badge bg-secondary bg-opacity-25 text-light fw-normal border border-secondary border-opacity-25">
                                        <i class="bi bi-hash text-info"></i>${t.name}
                                    </span>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="markdown" id="content" style="font-size: 1.1rem; line-height: 1.7; color: #e0e0e0;"></div>
                
                <script>
                    document.getElementById('content').innerHTML = 
                        DOMPurify.sanitize(marked.parse("${escapedContent}"));
                </script>
                
            </div>
        </div>
    </div>

</t:layout>