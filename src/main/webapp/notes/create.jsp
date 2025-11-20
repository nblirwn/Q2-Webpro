<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="New Note">
    
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="glass-card p-4 p-md-5">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold text-white mb-0">Write New Note</h3>
                    <a class="btn btn-outline-light btn-sm border-0" href="${pageContext.request.contextPath}/notes">
                        <i class="bi bi-x-lg"></i> Cancel
                    </a>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/notes/store">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="title" name="title" placeholder="Note Title">
                                <label for="title">Title</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating">
                                <select name="category_id" id="category" class="form-select">
                                    <option value="">-- No Category --</option>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                                <label for="category">Category</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" id="tags" name="tags" placeholder="Tags">
                        <label for="tags"><i class="bi bi-tags me-1"></i>Tags (comma separated)</label>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-muted small text-uppercase fw-bold">Content (Markdown Supported)</label>
                        <textarea class="form-control font-monospace" name="content" rows="10" 
                                  style="background: rgba(0,0,0,0.4); color: #00ffaa;"
                                  placeholder="Start typing here..."
                                  oninput="preview(this.value)"></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-muted small text-uppercase fw-bold">Live Preview</label>
                        <div id="md-preview" class="markdown p-3 rounded border border-secondary border-opacity-25" 
                             style="background: rgba(255,255,255,0.05); min-height: 100px;">
                             <em class="text-muted small">Preview will appear here...</em>
                        </div>
                    </div>

                    <button class="btn btn-gradient w-100 py-2 fw-bold">
                        <i class="bi bi-save me-2"></i>Save Note
                    </button>
                </form>
                
                <script>
                    function preview(text) {
                        const previewBox = document.getElementById('md-preview');
                        if (!text) {
                            previewBox.innerHTML = '<em class="text-muted small">Preview will appear here...</em>';
                        } else {
                            previewBox.innerHTML = DOMPurify.sanitize(marked.parse(text));
                        }
                    }
                </script>
            </div>
        </div>
    </div>
</t:layout>