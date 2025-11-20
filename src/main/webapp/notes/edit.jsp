<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Edit Note">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="glass-card p-4 p-md-5">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold text-white mb-0">Edit Note</h3>
                    <a class="btn btn-outline-light btn-sm border-0" href="${pageContext.request.contextPath}/notes">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/notes/update">
                    <input type="hidden" name="id" value="${note.id}">
                    
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="title" name="title" value="${note.title}" placeholder="Note Title">
                                <label for="title">Title</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating">
                                <select name="category_id" id="category" class="form-select">
                                    <option value="">-- No Category --</option>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}" ${note.categoryId == c.id ? 'selected' : ''}>
                                            ${c.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <label for="category">Category</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" id="tags" name="tags" value="${tags}" placeholder="Tags">
                        <label for="tags"><i class="bi bi-tags me-1"></i>Tags (comma separated)</label>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-muted small text-uppercase fw-bold">Content</label>
                        <textarea class="form-control font-monospace" name="content" rows="12" 
                                  style="background: rgba(0,0,0,0.4); color: #00ffaa;"
                                  oninput="preview(this.value)">${note.content}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-muted small text-uppercase fw-bold">Live Preview</label>
                        <div id="md-preview" class="markdown p-3 rounded border border-secondary border-opacity-25" 
                             style="background: rgba(255,255,255,0.05); min-height: 100px;">
                        </div>
                    </div>

                    <button class="btn btn-gradient w-100 py-2 fw-bold mb-4">
                        <i class="bi bi-check-lg me-2"></i>Update Note
                    </button>
                </form>

                <div class="border-top border-secondary border-opacity-25 pt-4 mt-4">
                    <h6 class="text-muted text-uppercase small fw-bold mb-3">Actions</h6>
                    <div class="d-flex flex-wrap gap-2">
                        
                        <form method="post" action="${pageContext.request.contextPath}/notes/share" class="d-inline">
                            <input type="hidden" name="id" value="${note.id}">
                            <button class="btn btn-outline-success btn-sm">
                                <i class="bi bi-share-fill me-1"></i> Create Share Link
                            </button>
                        </form>
                        
                        <form method="post" action="${pageContext.request.contextPath}/notes/unshare" class="d-inline">
                            <input type="hidden" name="id" value="${note.id}">
                            <button class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-share me-1"></i> Disable Share
                            </button>
                        </form>

                        <form method="post" action="${pageContext.request.contextPath}/notes/delete" 
                              onsubmit="return confirm('Are you sure you want to delete this note? This action cannot be undone.')" 
                              class="ms-auto d-inline">
                            <input type="hidden" name="id" value="${note.id}">
                            <button class="btn btn-outline-danger btn-sm">
                                <i class="bi bi-trash-fill me-1"></i> Delete Note
                            </button>
                        </form>
                    </div>
                </div>
                
                <script>
                    function preview(text) {
                        document.getElementById('md-preview').innerHTML = DOMPurify.sanitize(marked.parse(text || ''));
                    }
                    preview("${escapedContent}"); 
                </script>
            </div>
        </div>
    </div>
</t:layout>