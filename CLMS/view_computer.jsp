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
    <title>View Computers - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="navigation.jsp" %>
    <div class="container-fluid mt-4">
        <h2><i class="fas fa-desktop"></i> Computer Management</h2>
        <% String message = request.getParameter("message");
           if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-info" role="alert">
                <%= message %>
            </div>
        <% } %>
        <a href="add_computer.jsp" class="btn btn-primary mb-3"><i class="fas fa-plus"></i> Add New Computer</a>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Lab Name</th>
                        <th>Computer Number</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Processor</th>
                        <th>RAM</th>
                        <th>Storage</th>
                        <th>Status</th>
                        <th>Assigned To</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (conn != null) {
                            try {
                                PreparedStatement pstmt = conn.prepareStatement("SELECT c.*, s.name AS staff_name FROM computer c LEFT JOIN staff s ON c.assigned_to = s.staff_id ORDER BY c.computer_id");
                                ResultSet rs = pstmt.executeQuery();
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("computer_id") %></td>
                        <td><%= rs.getString("lab_name") %></td>
                        <td><%= rs.getString("computer_number") %></td>
                        <td><%= rs.getString("brand") %></td>
                        <td><%= rs.getString("model") %></td>
                        <td><%= rs.getString("processor") %></td>
                        <td><%= rs.getString("ram") %></td>
                        <td><%= rs.getString("storage") %></td>
                        <td>
                            <span class="badge <%= "working".equals(rs.getString("status")) ? "bg-success" : "damaged".equals(rs.getString("status")) ? "bg-danger" : "bg-warning" %>">
                                <%= rs.getString("status") %>
                            </span>
                        </td>
                        <td><%= rs.getString("staff_name") != null ? rs.getString("staff_name") : "Not Assigned" %></td>
                        <td>
                            <a href="edit_computer.jsp?id=<%= rs.getInt("computer_id") %>" class="btn btn-sm btn-warning"><i class="fas fa-edit"></i> Edit</a>
                            <a href="delete_computer.jsp?id=<%= rs.getInt("computer_id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this computer?')"><i class="fas fa-trash"></i> Delete</a>
                            <a href="assign_computer.jsp?id=<%= rs.getInt("computer_id") %>" class="btn btn-sm btn-info"><i class="fas fa-user-plus"></i> Assign</a>
                        </td>
                    </tr>
                    <%
                                }
                                rs.close();
                                pstmt.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='11' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
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



