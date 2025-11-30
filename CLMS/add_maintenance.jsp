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
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int computerId = Integer.parseInt(request.getParameter("computer_id"));
        String issueDescription = request.getParameter("issue_description");
        int staffId = (Integer) session.getAttribute("user_id");

        Connection conn = (Connection) application.getAttribute("dbConnection");
        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO maintenance (computer_id, issue_description, request_by, status) VALUES (?, ?, ?, 'pending')");
                pstmt.setInt(1, computerId);
                pstmt.setString(2, issueDescription);
                pstmt.setInt(3, staffId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Maintenance request submitted successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to submit request.";
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
    <title>Request Maintenance - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-plus"></i> Request Maintenance</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="add_maintenance.jsp">
                            <div class="mb-3">
                                <label for="computer_id" class="form-label">Select Computer</label>
                                <select class="form-control" id="computer_id" name="computer_id" required>
                                    <option value="">Choose a computer</option>
                                    <%
                                        Connection conn = (Connection) application.getAttribute("dbConnection");
                                        if (conn != null) {
                                            try {
                                                int staffId = (Integer) session.getAttribute("user_id");
                                                PreparedStatement pstmt = conn.prepareStatement("SELECT computer_id, lab_name, computer_number FROM computer WHERE assigned_to = ?");
                                                pstmt.setInt(1, staffId);
                                                ResultSet rs = pstmt.executeQuery();
                                                while (rs.next()) {
                                    %>
                                    <option value="<%= rs.getInt("computer_id") %>"><%= rs.getString("lab_name") %> - <%= rs.getString("computer_number") %></option>
                                    <%
                                                }
                                                rs.close();
                                                pstmt.close();
                                            } catch (Exception e) {
                                                out.println("<option disabled>Error loading computers</option>");
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="issue_description" class="form-label">Issue Description</label>
                                <textarea class="form-control" id="issue_description" name="issue_description" rows="4" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit Request</button>
                            <a href="staff_dashboard.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
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



