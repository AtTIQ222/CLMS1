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
    int accessoryId = Integer.parseInt(request.getParameter("id"));
    String itemName = "", conditionStatus = "";
    int quantity = 0;

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM accessory WHERE accessory_id = ?");
            pstmt.setInt(1, accessoryId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                itemName = rs.getString("item_name");
                quantity = rs.getInt("quantity");
                conditionStatus = rs.getString("condition_status");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error loading accessory: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        itemName = request.getParameter("item_name");
        quantity = Integer.parseInt(request.getParameter("quantity"));
        conditionStatus = request.getParameter("condition_status");

        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE accessory SET item_name=?, quantity=?, condition_status=? WHERE accessory_id=?");
                pstmt.setString(1, itemName);
                pstmt.setInt(2, quantity);
                pstmt.setString(3, conditionStatus);
                pstmt.setInt(4, accessoryId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Accessory updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update accessory.";
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
    <title>Edit Accessory - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-edit"></i> Edit Accessory</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="edit_accessory.jsp?id=<%= accessoryId %>">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="item_name" class="form-label">Item Name</label>
                                    <input type="text" class="form-control" id="item_name" name="item_name" value="<%= itemName %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="quantity" class="form-label">Quantity</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" value="<%= quantity %>" required min="0">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="condition_status" class="form-label">Condition Status</label>
                                    <input type="text" class="form-control" id="condition_status" name="condition_status" value="<%= conditionStatus %>" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Accessory</button>
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



