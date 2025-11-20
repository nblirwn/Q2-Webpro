<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Register" fullPage="true">

    <style>
        .login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 2rem 1rem;
        }

        .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            z-index: 0;
            animation: float 10s infinite ease-in-out;
        }

        .orb-1 { width: 300px; height: 300px; background: #7f00ff; top: 10%; left: 15%; }
        .orb-2 { width: 400px; height: 400px; background: #00d2ff; bottom: 10%; right: 10%; animation-delay: -5s; }

        @keyframes float {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(30px, -50px); }
        }

        .glass-card {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            z-index: 1;
            width: 100%;
            max-width: 450px;
        }

        .form-floating > .form-control {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff !important;
        }
        .form-floating > .form-control:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            border-color: #00d2ff;
            box-shadow: 0 0 10px rgba(0, 210, 255, 0.3);
        }
        .form-floating > label { color: #aaa !important; }
    </style>

    <div class="login-wrapper">
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>

        <div class="glass-card p-4 p-md-5">
            <div class="text-center mb-4">
                <h2 class="fw-bold text-white mb-1">Create Account</h2>
                <p class="text-muted small">Join NoteHub to start writing</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show py-2" role="alert">
                    <small><i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}</small>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/auth/register">
                
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="name" name="name" placeholder="Your Name" required>
                    <label for="name">Full Name</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                    <label for="email">Email Address</label>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password">Password</label>
                </div>

                <div class="form-floating mb-4">
                    <input type="password" class="form-control" id="confirmPassword" name="password_confirmation" placeholder="Confirm Password" required>
                    <label for="confirmPassword">Confirm Password</label>
                </div>

                <button class="btn btn-gradient w-100 py-2 rounded-3 mb-3 text-uppercase">Create Account</button>
                
                <div class="text-center">
                    <span class="text-muted small">Already have an account? </span>
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-info text-decoration-none small fw-bold">Login here</a>
                </div>
            </form>
        </div>
    </div>
</t:layout>