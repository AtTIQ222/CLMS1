<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    String messageType = "";
    int staffId = Integer.parseInt(request.getParameter("id"));
    String name = "", email = "", phone = "", designation = "", username = "", status = "";

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM staff WHERE staff_id = ?");
            pstmt.setInt(1, staffId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                phone = rs.getString("phone");
                designation = rs.getString("designation");
                username = rs.getString("username");
                status = rs.getString("status");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error loading staff: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        name = request.getParameter("name");
        email = request.getParameter("email");
        phone = request.getParameter("phone");
        designation = request.getParameter("designation");
        username = request.getParameter("username");
        String password = request.getParameter("password");
        status = request.getParameter("status");

        if (conn != null) {
            try {
                String query = "UPDATE staff SET name=?, email=?, phone=?, designation=?, username=?, status=? WHERE staff_id=?";
                if (!password.isEmpty()) {
                    query = "UPDATE staff SET name=?, email=?, phone=?, designation=?, username=?, password=?, status=? WHERE staff_id=?";
                }
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, designation);
                pstmt.setString(5, username);
                if (!password.isEmpty()) {
                    pstmt.setString(6, password);
                    pstmt.setString(7, status);
                    pstmt.setInt(8, staffId);
                } else {
                    pstmt.setString(6, status);
                    pstmt.setInt(7, staffId);
                }
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Staff updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update staff.";
                    messageType = "danger";
                }
                pstmt.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "danger";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-user-edit"></i> Edit Staff</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="edit_staff.jsp?id=<%= staffId %>">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="<%= name %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="<%= phone %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="designation" class="form-label">Designation</label>
                                    <input type="text" class="form-control" id="designation" name="designation" value="<%= designation %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= username %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password (leave blank to keep current)</label>
                                    <input type="password" class="form-control" id="password" name="password">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="active" <%= "active".equals(status) ? "selected" : "" %>>Active</option>
                                        <option value="inactive" <%= "inactive".equals(status) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Staff</button>
                            <a href="view_staff.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



