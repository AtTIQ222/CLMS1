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
        String itemName = request.getParameter("item_name");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String conditionStatus = request.getParameter("condition_status");

        Connection conn = (Connection) application.getAttribute("dbConnection");
        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO accessory (item_name, quantity, condition_status) VALUES (?, ?, ?)");
                pstmt.setString(1, itemName);
                pstmt.setInt(2, quantity);
                pstmt.setString(3, conditionStatus);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Accessory added successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to add accessory.";
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
    <title>Add Accessory - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-plus"></i> Add New Accessory</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="add_accessory.jsp">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="item_name" class="form-label">Item Name</label>
                                    <input type="text" class="form-control" id="item_name" name="item_name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="quantity" class="form-label">Quantity</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" required min="0">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="condition_status" class="form-label">Condition Status</label>
                                    <input type="text" class="form-control" id="condition_status" name="condition_status" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add Accessory</button>
                            <a href="view_accessory.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
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



