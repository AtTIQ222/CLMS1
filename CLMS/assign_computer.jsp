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
    int computerId = Integer.parseInt(request.getParameter("id"));
    String computerDetails = "";
    int currentAssigned = 0;

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT c.*, s.name AS staff_name FROM computer c LEFT JOIN staff s ON c.assigned_to = s.staff_id WHERE c.computer_id = ?");
            pstmt.setInt(1, computerId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                computerDetails = "Lab: " + rs.getString("lab_name") + ", Computer: " + rs.getString("computer_number") + ", Brand: " + rs.getString("brand");
                currentAssigned = rs.getInt("assigned_to");
                if (rs.getString("staff_name") != null) {
                    computerDetails += ", Currently Assigned to: " + rs.getString("staff_name");
                } else {
                    computerDetails += ", Not Assigned";
                }
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error loading computer: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String assignedToStr = request.getParameter("assigned_to");
        Integer assignedTo = null;
        if (assignedToStr != null && !assignedToStr.isEmpty()) {
            assignedTo = Integer.parseInt(assignedToStr);
        }

        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE computer SET assigned_to = ? WHERE computer_id = ?");
                if (assignedTo != null) {
                    pstmt.setInt(1, assignedTo);
                } else {
                    pstmt.setNull(1, Types.INTEGER);
                }
                pstmt.setInt(2, computerId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Computer assignment updated successfully!";
                    messageType = "success";
                    // Reload details
                    pstmt = conn.prepareStatement("SELECT c.*, s.name AS staff_name FROM computer c LEFT JOIN staff s ON c.assigned_to = s.staff_id WHERE c.computer_id = ?");
                    pstmt.setInt(1, computerId);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        computerDetails = "Lab: " + rs.getString("lab_name") + ", Computer: " + rs.getString("computer_number") + ", Brand: " + rs.getString("brand");
                        if (rs.getString("staff_name") != null) {
                            computerDetails += ", Currently Assigned to: " + rs.getString("staff_name");
                        } else {
                            computerDetails += ", Not Assigned";
                        }
                    }
                    rs.close();
                } else {
                    message = "Failed to update assignment.";
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
    <title>Assign Computer - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-user-plus"></i> Assign Computer</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-header">
                        <h5>Computer Details</h5>
                        <p><%= computerDetails %></p>
                    </div>
                    <div class="card-body">
                        <form method="post" action="assign_computer.jsp?id=<%= computerId %>">
                            <div class="mb-3">
                                <label for="assigned_to" class="form-label">Assign to Staff</label>
                                <select class="form-control" id="assigned_to" name="assigned_to">
                                    <option value="">Unassign</option>
                                    <%
                                        if (conn != null) {
                                            try {
                                                PreparedStatement pstmt = conn.prepareStatement("SELECT staff_id, name FROM staff WHERE status = 'active' ORDER BY name");
                                                ResultSet rs = pstmt.executeQuery();
                                                while (rs.next()) {
                                    %>
                                    <option value="<%= rs.getInt("staff_id") %>" <%= (currentAssigned == rs.getInt("staff_id")) ? "selected" : "" %>><%= rs.getString("name") %></option>
                                    <%
                                                }
                                                rs.close();
                                                pstmt.close();
                                            } catch (Exception e) {
                                                out.println("<option disabled>Error loading staff</option>");
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Assignment</button>
                            <a href="view_computer.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
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



