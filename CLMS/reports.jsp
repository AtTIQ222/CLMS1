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
    <title>Reports - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="navigation.jsp" %>
    <div class="container-fluid mt-4">
        
                <h2><i class="fas fa-chart-bar"></i> Reports</h2>
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5>Usage by Staff</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Staff</th>
                                            <th>Total Sessions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (conn != null) {
                                                try {
                                                    PreparedStatement pstmt = conn.prepareStatement("SELECT s.name, COUNT(u.usage_id) AS sessions FROM staff s LEFT JOIN lab_usage u ON s.staff_id = u.staff_id GROUP BY s.staff_id, s.name ORDER BY sessions DESC");
                                                    ResultSet rs = pstmt.executeQuery();
                                                    while (rs.next()) {
                                        %>
                                        <tr>
                                            <td><%= rs.getString("name") %></td>
                                            <td><%= rs.getInt("sessions") %></td>
                                        </tr>
                                        <%
                                                    }
                                                    rs.close();
                                                    pstmt.close();
                                                } catch (Exception e) {
                                                    out.println("<tr><td colspan='2' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-warning text-white">
                                <h5>Maintenance Summary</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Status</th>
                                            <th>Count</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (conn != null) {
                                                try {
                                                    PreparedStatement pstmt = conn.prepareStatement("SELECT status, COUNT(*) AS count FROM maintenance GROUP BY status");
                                                    ResultSet rs = pstmt.executeQuery();
                                                    while (rs.next()) {
                                        %>
                                        <tr>
                                            <td><%= rs.getString("status") %></td>
                                            <td><%= rs.getInt("count") %></td>
                                        </tr>
                                        <%
                                                    }
                                                    rs.close();
                                                    pstmt.close();
                                                } catch (Exception e) {
                                                    out.println("<tr><td colspan='2' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



