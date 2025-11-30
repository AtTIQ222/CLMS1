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
    int maintenanceId = Integer.parseInt(request.getParameter("id"));
    String issueDescription = "", status = "";
    Date requestDate = null, resolvedDate = null;

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM maintenance WHERE maintenance_id = ?");
            pstmt.setInt(1, maintenanceId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                issueDescription = rs.getString("issue_description");
                status = rs.getString("status");
                requestDate = rs.getDate("request_date");
                resolvedDate = rs.getDate("resolved_date");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error loading maintenance: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        status = request.getParameter("status");

        if (conn != null) {
            try {
                String query = "UPDATE maintenance SET status = ?";
                if ("completed".equals(status)) {
                    query += ", resolved_date = CURDATE()";
                } else {
                    query += ", resolved_date = NULL";
                }
                query += " WHERE maintenance_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, status);
                pstmt.setInt(2, maintenanceId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Maintenance updated successfully!";
                    messageType = "success";
                    // Reload
                    if ("completed".equals(status)) {
                        resolvedDate = new Date(System.currentTimeMillis());
                    } else {
                        resolvedDate = null;
                    }
                } else {
                    message = "Failed to update maintenance.";
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
    <title>Update Maintenance - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-edit"></i> Update Maintenance</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-header">
                        <h5>Maintenance Details</h5>
                        <p><strong>Issue:</strong> <%= issueDescription %></p>
                        <p><strong>Request Date:</strong> <%= requestDate %></p>
                    </div>
                    <div class="card-body">
                        <form method="post" action="update_maintenance.jsp?id=<%= maintenanceId %>">
                            <div class="mb-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-control" id="status" name="status" required>
                                    <option value="pending" <%= "pending".equals(status) ? "selected" : "" %>>Pending</option>
                                    <option value="completed" <%= "completed".equals(status) ? "selected" : "" %>>Completed</option>
                                </select>
                            </div>
                            <% if (resolvedDate != null) { %>
                                <p><strong>Resolved Date:</strong> <%= resolvedDate %></p>
                            <% } %>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update</button>
                            <a href="view_maintenance.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
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



