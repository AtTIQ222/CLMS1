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
    <title>View Lab Usage - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="navigation.jsp" %>
    <div class="container-fluid mt-4">
        <h2><i class="fas fa-clock"></i> Lab Usage History</h2>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Staff</th>
                        <th>Computer</th>
                        <th>Login Time</th>
                        <th>Logout Time</th>
                        <th>Purpose</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (conn != null) {
                            try {
                                PreparedStatement pstmt = conn.prepareStatement("SELECT u.*, s.name AS staff_name, c.lab_name, c.computer_number FROM lab_usage u JOIN staff s ON u.staff_id = s.staff_id JOIN computer c ON u.computer_id = c.computer_id ORDER BY u.login_time DESC");
                                ResultSet rs = pstmt.executeQuery();
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("usage_id") %></td>
                        <td><%= rs.getString("staff_name") %></td>
                        <td><%= rs.getString("lab_name") %> - <%= rs.getString("computer_number") %></td>
                        <td><%= rs.getTimestamp("login_time") %></td>
                        <td><%= rs.getTimestamp("logout_time") != null ? rs.getTimestamp("logout_time") : "Active" %></td>
                        <td><%= rs.getString("purpose") %></td>
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
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



