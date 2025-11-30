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
    String labName = "", computerNumber = "", brand = "", model = "", processor = "", ram = "", storage = "", status = "";

    Connection conn = (Connection) application.getAttribute("dbConnection");
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM computer WHERE computer_id = ?");
            pstmt.setInt(1, computerId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                labName = rs.getString("lab_name");
                computerNumber = rs.getString("computer_number");
                brand = rs.getString("brand");
                model = rs.getString("model");
                processor = rs.getString("processor");
                ram = rs.getString("ram");
                storage = rs.getString("storage");
                status = rs.getString("status");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            message = "Error loading computer: " + e.getMessage();
            messageType = "danger";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        labName = request.getParameter("lab_name");
        computerNumber = request.getParameter("computer_number");
        brand = request.getParameter("brand");
        model = request.getParameter("model");
        processor = request.getParameter("processor");
        ram = request.getParameter("ram");
        storage = request.getParameter("storage");
        status = request.getParameter("status");

        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE computer SET lab_name=?, computer_number=?, brand=?, model=?, processor=?, ram=?, storage=?, status=? WHERE computer_id=?");
                pstmt.setString(1, labName);
                pstmt.setString(2, computerNumber);
                pstmt.setString(3, brand);
                pstmt.setString(4, model);
                pstmt.setString(5, processor);
                pstmt.setString(6, ram);
                pstmt.setString(7, storage);
                pstmt.setString(8, status);
                pstmt.setInt(9, computerId);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Computer updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update computer.";
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
    <title>Edit Computer - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-edit"></i> Edit Computer</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="edit_computer.jsp?id=<%= computerId %>">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="lab_name" class="form-label">Lab Name</label>
                                    <input type="text" class="form-control" id="lab_name" name="lab_name" value="<%= labName %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="computer_number" class="form-label">Computer Number</label>
                                    <input type="text" class="form-control" id="computer_number" name="computer_number" value="<%= computerNumber %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="brand" class="form-label">Brand</label>
                                    <input type="text" class="form-control" id="brand" name="brand" value="<%= brand %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="model" class="form-label">Model</label>
                                    <input type="text" class="form-control" id="model" name="model" value="<%= model %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="processor" class="form-label">Processor</label>
                                    <input type="text" class="form-control" id="processor" name="processor" value="<%= processor %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="ram" class="form-label">RAM</label>
                                    <input type="text" class="form-control" id="ram" name="ram" value="<%= ram %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="storage" class="form-label">Storage</label>
                                    <input type="text" class="form-control" id="storage" name="storage" value="<%= storage %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="working" <%= "working".equals(status) ? "selected" : "" %>>Working</option>
                                        <option value="damaged" <%= "damaged".equals(status) ? "selected" : "" %>>Damaged</option>
                                        <option value="repair" <%= "repair".equals(status) ? "selected" : "" %>>Repair</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Computer</button>
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



