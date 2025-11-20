<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="${archived ? 'Archived Notes' : 'My Notes'}">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-white mb-0">
                <i class="bi ${archived ? 'bi-archive-fill' : 'bi-grid-fill'} me-2 text-info"></i>
                ${archived ? 'Archived Notes' : 'My Notes'}
            </h2>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-light btn-sm d-flex align-items-center" 
               href="${pageContext.request.contextPath}/notes?archived=${archived ? '0' : '1'}">
                <i class="bi ${archived ? 'bi-arrow-left' : 'bi-archive'} me-2"></i>
                ${archived ? 'Back to Active' : 'View Archived'}
            </a>
            <a class="btn btn-primary btn-sm d-flex align-items-center shadow-lg" href="${pageContext.request.contextPath}/notes/create">
                <i class="bi bi-plus-lg me-2"></i>New Note
            </a>
        </div>
    </div>
    
    <div class="glass-card p-3 mb-4">
        <form class="row g-2 align-items-center" method="get" action="${pageContext.request.contextPath}/notes">
            <input type="hidden" name="archived" value="${archived ? '1' : '0'}">
            
            <div class="col-md-5">
                <div class="input-group">
                    <span class="input-group-text" 
                          style="background-color: rgba(0, 0, 0, 0.3); border: 1px solid rgba(255, 255, 255, 0.1); border-right: none; color: #adb5bd;">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" class="form-control" name="q" value="${param.q}" placeholder="Search..." 
                           style="border-left: none; padding-left: 0;">
                </div>
            </div>
            
            <div class="col-md-3">
                <select name="cat" class="form-select">
                    <option value="">All Categories</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" ${param.cat == c.id ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="col-md-2">
                <div class="input-group">
                    <span class="input-group-text" 
                          style="background-color: rgba(0, 0, 0, 0.3); border: 1px solid rgba(255, 255, 255, 0.1); border-right: none; color: #adb5bd;">
                        <i class="bi bi-hash"></i>
                    </span>
                    <input type="text" class="form-control" name="tag" value="${param.tag}" placeholder="Tag" 
                           style="border-left: none; padding-left: 0;">
                </div>
            </div>
            
            <div class="col-md-2">
                <button class="btn btn-primary w-100 fw-bold">Filter</button>
            </div>
        </form>
    </div>
    
    <c:if test="${empty notes}">
        <div class="text-center py-5 glass-card">
            <i class="bi bi-journal-x text-secondary display-1 mb-3"></i>
            <h3 class="text-white">No notes found here.</h3>
            <p class="text-muted">Try adjusting your filters or create a new one.</p>
        </div>
    </c:if>
    
    <div class="row g-4">
        <c:forEach var="n" items="${notes}">
            <div class="col-md-6 col-lg-4">
                <div class="card glass-card h-100 border-0 ${n.pinned ? 'border-warning border-opacity-50 shadow' : ''}" 
                     style="${n.pinned ? 'border: 1px solid rgba(255, 193, 7, 0.3);' : ''}">
                    
                    <div class="card-body d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title fw-bold text-white text-truncate w-75 mb-0">
                                ${empty n.title ? '<em class="text-muted">(untitled)</em>' : n.title}
                            </h5>
                            <c:if test="${n.pinned}">
                                <i class="bi bi-pin-angle-fill text-warning fs-5" title="Pinned"></i>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <span class="badge badge-category rounded-pill text-light fw-normal border border-secondary border-opacity-25">
                                <i class="bi bi-folder2-open me-1"></i>${empty n.category ? 'Uncategorized' : n.category.name}
                            </span>
                        </div>

                        <div class="card-text text-muted small mb-3 flex-grow-1" style="overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical;">
                            <c:set var="content" value="${fn:replace(n.content, '<', '&lt;')}"/>
                            <c:set var="content" value="${fn:replace(content, '>', '&gt;')}"/>
                            ${fn:substring(content, 0, 150)}...
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top border-secondary border-opacity-25">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/notes/show?id=${n.id}" class="btn btn-sm btn-outline-info border-0" title="Read">
                                    <i class="bi bi-eye-fill"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/notes/edit?id=${n.id}" class="btn btn-sm btn-outline-warning border-0" title="Edit">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                            </div>

                            <div class="d-flex gap-1">
                                <form method="post" action="${pageContext.request.contextPath}/notes/pin" class="d-inline">
                                    <input type="hidden" name="id" value="${n.id}">
                                    <button class="btn btn-sm btn-link text-secondary p-0 px-2" title="${n.pinned ? 'Unpin' : 'Pin'}">
                                        <i class="bi ${n.pinned ? 'bi-pin-angle-fill text-warning' : 'bi-pin-angle'}"></i>
                                    </button>
                                </form>

                                <c:choose>
                                    <c:when test="${!archived}">
                                        <form method="post" action="${pageContext.request.contextPath}/notes/archive" class="d-inline">
                                            <input type="hidden" name="id" value="${n.id}">
                                            <button class="btn btn-sm btn-link text-secondary p-0 px-2" title="Archive">
                                                <i class="bi bi-archive"></i>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/notes/restore" class="d-inline">
                                            <input type="hidden" name="id" value="${n.id}">
                                            <button class="btn btn-sm btn-link text-success p-0 px-2" title="Restore">
                                                <i class="bi bi-arrow-counterclockwise"></i>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</t:layout>