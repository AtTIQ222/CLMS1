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
    <title>View Accessories - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="navigation.jsp" %>
    <div class="container-fluid mt-4">
        
                <h2><i class="fas fa-tools"></i> Accessory Management</h2>
                <% String message = request.getParameter("message");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="alert alert-info" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <a href="add_accessory.jsp" class="btn btn-primary mb-3"><i class="fas fa-plus"></i> Add New Accessory</a>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Item Name</th>
                                <th>Quantity</th>
                                <th>Condition Status</th>
                                <th>Added Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM accessory ORDER BY accessory_id");
                                        ResultSet rs = pstmt.executeQuery();
                                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("accessory_id") %></td>
                                <td><%= rs.getString("item_name") %></td>
                                <td><%= rs.getInt("quantity") %></td>
                                <td><%= rs.getString("condition_status") %></td>
                                <td><%= rs.getDate("added_date") %></td>
                                <td>
                                    <a href="edit_accessory.jsp?id=<%= rs.getInt("accessory_id") %>" class="btn btn-sm btn-warning"><i class="fas fa-edit"></i> Edit</a>
                                    <a href="delete_accessory.jsp?id=<%= rs.getInt("accessory_id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this accessory?')"><i class="fas fa-trash"></i> Delete</a>
                                </td>
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



