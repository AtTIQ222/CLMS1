<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if staff is logged in
    if (session.getAttribute("user_type") == null || !"staff".equals(session.getAttribute("user_type"))) {
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
    <title>Maintenance Status - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-wrench"></i> My Maintenance Requests</h2>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Computer</th>
                                <th>Issue Description</th>
                                <th>Request Date</th>
                                <th>Status</th>
                                <th>Resolved Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (conn != null) {
                                    try {
                                        int staffId = (Integer) session.getAttribute("user_id");
                                        PreparedStatement pstmt = conn.prepareStatement("SELECT m.*, c.lab_name, c.computer_number FROM maintenance m JOIN computer c ON m.computer_id = c.computer_id WHERE m.request_by = ? ORDER BY m.request_date DESC");
                                        pstmt.setInt(1, staffId);
                                        ResultSet rs = pstmt.executeQuery();
                                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("maintenance_id") %></td>
                                <td><%= rs.getString("lab_name") %> - <%= rs.getString("computer_number") %></td>
                                <td><%= rs.getString("issue_description") %></td>
                                <td><%= rs.getDate("request_date") %></td>
                                <td>
                                    <span class="badge <%= "pending".equals(rs.getString("status")) ? "bg-warning" : "bg-success" %>">
                                        <%= rs.getString("status") %>
                                    </span>
                                </td>
                                <td><%= rs.getDate("resolved_date") != null ? rs.getDate("resolved_date") : "N/A" %></td>
                            </tr>
                            <%
                                        }
                                        rs.close();
                                        pstmt.close();
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



