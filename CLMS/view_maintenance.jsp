<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = (Connection) application.getAttribute("dbConnection");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Maintenance - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="navigation.jsp" %>
    <div class="container-fluid mt-4">
        
                <h2><i class="fas fa-wrench"></i> Maintenance Requests</h2>
                <% String message = request.getParameter("message");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="alert alert-info" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Computer</th>
                                <th>Requested By</th>
                                <th>Issue Description</th>
                                <th>Request Date</th>
                                <th>Status</th>
                                <th>Resolved Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement("SELECT m.*, c.computer_number, c.lab_name, s.name AS staff_name FROM maintenance m JOIN computer c ON m.computer_id = c.computer_id JOIN staff s ON m.request_by = s.staff_id ORDER BY m.maintenance_id");
                                        ResultSet rs = pstmt.executeQuery();
                                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("maintenance_id") %></td>
                                <td><%= rs.getString("lab_name") %> - <%= rs.getString("computer_number") %></td>
                                <td><%= rs.getString("staff_name") %></td>
                                <td><%= rs.getString("issue_description") %></td>
                                <td><%= rs.getDate("request_date") %></td>
                                <td>
                                    <span class="badge <%= "pending".equals(rs.getString("status")) ? "bg-warning" : "bg-success" %>">
                                        <%= rs.getString("status") %>
                                    </span>
                                </td>
                                <td><%= rs.getDate("resolved_date") != null ? rs.getDate("resolved_date") : "N/A" %></td>
                                <td>
                                    <a href="update_maintenance.jsp?id=<%= rs.getInt("maintenance_id") %>" class="btn btn-sm btn-info"><i class="fas fa-edit"></i> Update</a>
                                </td>
                            </tr>
                            <%
                                        }
                                        rs.close();
                                        pstmt.close();
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



