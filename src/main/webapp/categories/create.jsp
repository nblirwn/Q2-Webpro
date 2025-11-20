<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="New Category">
    
    <div class="row justify-content-center align-items-center" style="min-height: 70vh;">
        <div class="col-md-6 col-lg-5">
            
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <h3 class="fw-bold text-white">New Category</h3>
                    <p class="text-muted small">Create a tag to group your notes</p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/categories/store">
                    
                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" id="categoryName" name="name" placeholder="Category Name" required>
                        <label for="categoryName">Category Name</label>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button class="btn btn-primary py-2 fw-bold">
                            <i class="bi bi-save me-2"></i>Save Category
                        </button>
                        <a class="btn btn-outline-light py-2 border-0" href="${pageContext.request.contextPath}/categories">
                            Cancel
                        </a>
                    </div>

                </form>
            </div>

        </div>
    </div>

</t:layout>