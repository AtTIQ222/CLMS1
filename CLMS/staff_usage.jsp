<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if staff is logged in
    if (session.getAttribute("user_type") == null || !"staff".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    String messageType = "";
    int staffId = (Integer) session.getAttribute("user_id");
    boolean isLoggedIn = false;
    int currentUsageId = 0;
    String currentPurpose = "";

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            // Check if currently logged in (has usage without logout)
            PreparedStatement pstmt = conn.prepareStatement("SELECT usage_id, purpose FROM lab_usage WHERE staff_id = ? AND logout_time IS NULL ORDER BY login_time DESC LIMIT 1");
            pstmt.setInt(1, staffId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                isLoggedIn = true;
                currentUsageId = rs.getInt("usage_id");
                currentPurpose = rs.getString("purpose");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error checking status: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            String purpose = request.getParameter("purpose");
            // Get assigned computer
            int computerId = 0;
            try {
                PreparedStatement pstmt = conn.prepareStatement("SELECT computer_id FROM computer WHERE assigned_to = ?");
                pstmt.setInt(1, staffId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    computerId = rs.getInt("computer_id");
                }
                rs.close();
                pstmt.close();

                if (computerId > 0) {
                    pstmt = conn.prepareStatement("INSERT INTO lab_usage (staff_id, computer_id, purpose) VALUES (?, ?, ?)");
                    pstmt.setInt(1, staffId);
                    pstmt.setInt(2, computerId);
                    pstmt.setString(3, purpose);
                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        message = "Logged in successfully!";
                        messageType = "success";
                        isLoggedIn = true;
                    } else {
                        message = "Failed to log in.";
                        messageType = "danger";
                    }
                    pstmt.close();
                } else {
                    message = "No assigned computer found.";
                    messageType = "danger";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "danger";
            }
        } else if ("logout".equals(action)) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE lab_usage SET logout_time = NOW() WHERE usage_id = ?");
                pstmt.setInt(1, currentUsageId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Logged out successfully!";
                    messageType = "success";
                    isLoggedIn = false;
                } else {
                    message = "Failed to log out.";
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
    <title>Lab Usage - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-clock"></i> Lab Usage</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <% if (isLoggedIn) { %>
                            <div class="alert alert-success">
                                <h5>You are currently logged in</h5>
                                <p><strong>Purpose:</strong> <%= currentPurpose %></p>
                            </div>
                            <form method="post" action="staff_usage.jsp">
                                <input type="hidden" name="action" value="logout">
                                <button type="submit" class="btn btn-danger"><i class="fas fa-sign-out-alt"></i> Logout</button>
                            </form>
                        <% } else { %>
                            <form method="post" action="staff_usage.jsp">
                                <input type="hidden" name="action" value="login">
                                <div class="mb-3">
                                    <label for="purpose" class="form-label">Purpose of Usage</label>
                                    <textarea class="form-control" id="purpose" name="purpose" rows="3" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-success"><i class="fas fa-sign-in-alt"></i> Login</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



