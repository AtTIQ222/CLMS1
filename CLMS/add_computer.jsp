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
        String labName = request.getParameter("lab_name");
        String computerNumber = request.getParameter("computer_number");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String processor = request.getParameter("processor");
        String ram = request.getParameter("ram");
        String storage = request.getParameter("storage");
        String status = request.getParameter("status");

        Connection conn = (Connection) application.getAttribute("dbConnection");
        if (conn != null) {
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO computer (lab_name, computer_number, brand, model, processor, ram, storage, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                pstmt.setString(1, labName);
                pstmt.setString(2, computerNumber);
                pstmt.setString(3, brand);
                pstmt.setString(4, model);
                pstmt.setString(5, processor);
                pstmt.setString(6, ram);
                pstmt.setString(7, storage);
                pstmt.setString(8, status);
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    message = "Computer added successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to add computer.";
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
    <title>Add Computer - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-desktop"></i> Add New Computer</h2>
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %>" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <div class="card">
                    <div class="card-body">
                        <form method="post" action="add_computer.jsp">
                            
                                <div class="col-md-6 mb-3">
                                    <label for="lab_name" class="form-label">Lab Name</label>
                                    <input type="text" class="form-control" id="lab_name" name="lab_name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="computer_number" class="form-label">Computer Number</label>
                                    <input type="text" class="form-control" id="computer_number" name="computer_number" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="brand" class="form-label">Brand</label>
                                    <input type="text" class="form-control" id="brand" name="brand">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="model" class="form-label">Model</label>
                                    <input type="text" class="form-control" id="model" name="model">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="processor" class="form-label">Processor</label>
                                    <input type="text" class="form-control" id="processor" name="processor">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="ram" class="form-label">RAM</label>
                                    <input type="text" class="form-control" id="ram" name="ram">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="storage" class="form-label">Storage</label>
                                    <input type="text" class="form-control" id="storage" name="storage">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="working">Working</option>
                                        <option value="damaged">Damaged</option>
                                        <option value="repair">Repair</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add Computer</button>
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



