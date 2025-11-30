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
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String cnic = request.getParameter("cnic");
        String designation = request.getParameter("designation");
        int labId = Integer.parseInt(request.getParameter("lab_id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String status = request.getParameter("status");

        Connection conn = (Connection) application.getAttribute("dbConnection");
        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO staff (name, email, phone, cnic, designation, lab_id, username, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, cnic);
                pstmt.setString(5, designation);
                pstmt.setInt(6, labId);
                pstmt.setString(7, username);
                pstmt.setString(8, password);
                pstmt.setString(9, status);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Staff added successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to add staff.";
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
    <title>Add Staff - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-user-plus"></i> Add New Staff</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="add_staff.jsp">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone" pattern="^03[0-9]{9}$" title="Enter a valid Pakistani mobile number (e.g., 03001234567)">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="cnic" class="form-label">CNIC</label>
                                    <input type="text" class="form-control" id="cnic" name="cnic" pattern="^[0-9]{5}-[0-9]{7}-[0-9]{1}$" title="Enter CNIC in format 12345-1234567-1" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="designation" class="form-label">Designation</label>
                                    <input type="text" class="form-control" id="designation" name="designation" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lab_id" class="form-label">Lab</label>
                                    <select class="form-control" id="lab_id" name="lab_id" required>
                                        <option value="">Select Lab</option>
                                        <%
                                            Connection conn = (Connection) application.getAttribute("dbConnection");
                                            if (conn != null) {
                                                try {
                                                    PreparedStatement pstmt = conn.prepareStatement("SELECT lab_id, lab_name FROM labs ORDER BY lab_name");
                                                    ResultSet rs = pstmt.executeQuery();
                                                    while (rs.next()) {
                                        %>
                                        <option value="<%= rs.getInt("lab_id") %>"><%= rs.getString("lab_name") %></option>
                                        <%
                                                    }
                                                    rs.close();
                                                    pstmt.close();
                                                } catch (Exception e) {
                                                    out.println("<option disabled>Error loading labs</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add Staff</button>
                            <a href="view_staff.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
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



