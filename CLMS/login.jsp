<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if already logged in
    if (session.getAttribute("user_type") != null) {
        String userType = (String) session.getAttribute("user_type");
        if ("admin".equals(userType)) {
            response.sendRedirect("admin_dashboard.jsp");
        } else if ("staff".equals(userType)) {
            response.sendRedirect("staff_dashboard.jsp");
        } else if ("student".equals(userType)) {
            response.sendRedirect("student_dashboard.jsp");
        } else if ("technician".equals(userType)) {
            response.sendRedirect("technician_dashboard.jsp");
        }
        return;
    }

    String errorMessage = "";

    // Database connection
    String dbURL = "jdbc:mysql://localhost:3306/lab_db?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "";
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    } catch (Exception e) {
        errorMessage = "Database connection failed: " + e.getMessage();
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userType = request.getParameter("user_type");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (conn != null) {
            try {
                String query = "";
                if ("admin".equals(userType)) {
                    query = "SELECT admin_id, name FROM admin_user WHERE username = ? AND password = ?";
                } else if ("staff".equals(userType)) {
                    query = "SELECT staff_id, name FROM staff WHERE username = ? AND password = ? AND status = 'active'";
                } else if ("student".equals(userType)) {
                    query = "SELECT student_id, name FROM students WHERE username = ? AND password = ? AND status = 'active'";
                } else if ("technician".equals(userType)) {
                    query = "SELECT technician_id, name FROM technician WHERE username = ? AND password = ? AND status = 'active'";
                }

                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    session.setAttribute("user_type", userType);
                    session.setAttribute("user_id", rs.getInt(1));
                    session.setAttribute("username", username);
                    session.setAttribute("name", rs.getString(2));

                    if ("admin".equals(userType)) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else if ("staff".equals(userType)) {
                        response.sendRedirect("staff_dashboard.jsp");
                    } else if ("student".equals(userType)) {
                        response.sendRedirect("student_dashboard.jsp");
                    } else if ("technician".equals(userType)) {
                        response.sendRedirect("technician_dashboard.jsp");
                    }
                    return;
                } else {
                    errorMessage = "Invalid username or password.";
                }
                rs.close();
                pstmt.close();
            } catch (Exception e) {
                errorMessage = "Database error: " + e.getMessage();
            }
        } else {
            errorMessage = "Database connection not available.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Computer Lab Management System</title>
    <!-- Modern Theme -->
    <link rel="stylesheet" href="modern-theme.css">
    <style>
        body {
            background-color: #f3f4f6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }
        .login-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 400px;
            width: 100%;
            border: 1px solid #e5e7eb;
        }
        .login-header {
            background: #3b82f6;
            color: white;
            padding: 24px 20px;
            text-align: center;
        }
        .login-body {
            padding: 32px 24px;
        }
        .tab-button {
            background: none;
            border: none;
            padding: 8px 16px;
            margin: 0 4px;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.2s;
            color: #6b7280;
        }
        .tab-button.active {
            background: #e5e7eb;
            color: #111827;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus {
            border-color: #3b82f6;
            outline: none;
        }
        .form-group label {
            display: block;
            margin-bottom: 4px;
            font-size: 14px;
            font-weight: 500;
            color: #374151;
        }
        .btn-login {
            width: 100%;
            padding: 10px;
            background: #3b82f6;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-login:hover {
            background: #2563eb;
        }
        .university-badge {
            display: inline-block;
            background: #e5e7eb;
            color: #6b7280;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-top: 8px;
        }
        .alert {
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        .alert-danger {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
    </style>
</head>
<body>
    <div style="min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px;">
        <div class="login-container">
            <!-- Header -->
            <div class="login-header">
                <h1 style="font-size: 18px; font-weight: bold; margin-bottom: 4px;">Computer Lab Management</h1>
                <p style="font-size: 14px; color: #bfdbfe;">University of Sindh, Laar Campus</p>
                <div class="university-badge">CLMS</div>
            </div>

            <!-- Body -->
            <div class="login-body">
                <% if (!errorMessage.isEmpty()) { %>
                    <div class="alert alert-danger">
                        <%= errorMessage %>
                    </div>
                <% } %>

                <!-- Tab Navigation -->
                <div style="display: flex; justify-content: center; margin-bottom: 24px; flex-wrap: wrap;">
                    <button class="tab-button active" onclick="switchTab('admin')">Admin Login</button>
                    <button class="tab-button" onclick="switchTab('staff')">Staff Login</button>
                    <button class="tab-button" onclick="switchTab('student')">Student Login</button>
                    <button class="tab-button" onclick="switchTab('technician')">Technician Login</button>
                </div>

                <!-- Admin Tab -->
                <div id="admin-tab">
                    <form method="post" action="login.jsp">
                        <input type="hidden" name="user_type" value="admin">
                        <div class="form-group">
                            <label for="adminUsername">Username</label>
                            <input type="text" id="adminUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="adminPassword">Password</label>
                            <input type="password" id="adminPassword" name="password" required>
                        </div>
                        <button type="submit" class="btn-login">Login as Administrator</button>
                    </form>
                </div>

                <!-- Staff Tab -->
                <div id="staff-tab">
                    <form method="post" action="login.jsp">
                        <input type="hidden" name="user_type" value="staff">
                        <div class="form-group">
                            <label for="staffUsername">Username</label>
                            <input type="text" id="staffUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="staffPassword">Password</label>
                            <input type="password" id="staffPassword" name="password" required>
                        </div>
                        <button type="submit" class="btn-login">Login as Staff</button>
                    </form>
                </div>

                <!-- Student Tab -->
                <div id="student-tab">
                    <form method="post" action="login.jsp">
                        <input type="hidden" name="user_type" value="student">
                        <div class="form-group">
                            <label for="studentUsername">Username</label>
                            <input type="text" id="studentUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="studentPassword">Password</label>
                            <input type="password" id="studentPassword" name="password" required>
                        </div>
                        <button type="submit" class="btn-login">Login as Student</button>
                    </form>
                </div>

                <!-- Technician Tab -->
                <div id="technician-tab">
                    <form method="post" action="login.jsp">
                        <input type="hidden" name="user_type" value="technician">
                        <div class="form-group">
                            <label for="technicianUsername">Username</label>
                            <input type="text" id="technicianUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="technicianPassword">Password</label>
                            <input type="password" id="technicianPassword" name="password" required>
                        </div>
                        <button type="submit" class="btn-login">Login as Technician</button>
                    </form>
                </div>

                <!-- Demo Credentials -->
                <div style="margin-top: 24px; padding: 16px; background: #f9fafb; border-radius: 4px; border: 1px solid #e5e7eb;">
                    <h3 style="font-size: 14px; font-weight: 600; margin-bottom: 8px; text-align: center;">Demo Credentials</h3>
                    <div style="font-size: 12px; color: #6b7280;">
                        <div><strong>Admin:</strong> admin / admin123</div>
                        <div><strong>Staff:</strong> staff1 / staff123</div>
                        <div><strong>Student:</strong> student1 / student123</div>
                        <div><strong>Technician:</strong> tech1 / tech123</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tab) {
            // Hide all tabs
            document.getElementById('admin-tab').style.display = 'none';
            document.getElementById('staff-tab').style.display = 'none';
            document.getElementById('student-tab').style.display = 'none';
            document.getElementById('technician-tab').style.display = 'none';

            // Remove active class from all buttons
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));

            // Show selected tab and activate button
            document.getElementById(tab + '-tab').style.display = 'block';
            event.target.classList.add('active');
        }

        // Initialize - show admin tab by default
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('admin-tab').style.display = 'block';
            document.getElementById('staff-tab').style.display = 'none';
            document.getElementById('student-tab').style.display = 'none';
            document.getElementById('technician-tab').style.display = 'none';
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



