<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Categories">
    
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-0 text-white">
                        <i class="bi bi-tags-fill me-2 text-info"></i>Categories
                    </h2>
                    <p class="text-muted small mb-0">Organize your notes efficiently</p>
                </div>
                <a class="btn btn-primary shadow-lg" href="${pageContext.request.contextPath}/categories/create">
                    <i class="bi bi-plus-lg me-1"></i> New Category
                </a>
            </div>
            
            <div class="glass-card p-0 overflow-hidden">
                
                <c:if test="${empty categories}">
                    <div class="text-center p-5">
                        <i class="bi bi-folder-x text-secondary display-4 mb-3"></i>
                        <p class="text-muted">No categories found.</p>
                    </div>
                </c:if>
                
                <ul class="list-group list-group-flush bg-transparent">
                    <c:forEach var="c" items="${categories}">
                        <li class="list-group-item bg-transparent border-secondary border-opacity-25 text-white d-flex justify-content-between align-items-center py-3 px-4">
                            
                            <span class="fw-medium">
                                <i class="bi bi-hash text-secondary me-2"></i>${c.name}
                            </span>
                            
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/categories/edit?id=${c.id}" 
                                   class="btn btn-sm btn-outline-warning border-0" 
                                   title="Edit">
                                    <i class="bi bi-pencil-square"></i>
                                </a>

                                <form method="post" action="${pageContext.request.contextPath}/categories/delete" 
                                      class="d-inline" onsubmit="return confirm('Are you sure you want to delete this category?')">
                                    <input type="hidden" name="id" value="${c.id}">
                                    <button class="btn btn-sm btn-outline-danger border-0" title="Delete">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>

                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>

</t:layout>