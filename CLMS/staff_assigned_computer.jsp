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
    ResultSet rs = null;
    boolean hasAssignedComputer = false;
    String labName = "", computerNumber = "", brand = "", model = "", processor = "", ram = "", storage = "", status = "";

    if (conn != null) {
        try {
            int staffId = (Integer) session.getAttribute("user_id");
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM computer WHERE assigned_to = ?");
            pstmt.setInt(1, staffId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                hasAssignedComputer = true;
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
            out.println("<div class='alert alert-danger'>Error fetching data: " + e.getMessage() + "</div>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Computer - CLMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container-fluid mt-4">
        
            <%@ include file="navigation.jsp" %>
            
                <h2><i class="fas fa-desktop"></i> Assigned Computer</h2>
                <% if (hasAssignedComputer) { %>
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5>Computer Details</h5>
                        </div>
                        <div class="card-body">
                            
                                <div class="col-md-6">
                                    <p><strong>Lab Name:</strong> <%= labName %></p>
                                    <p><strong>Computer Number:</strong> <%= computerNumber %></p>
                                    <p><strong>Brand:</strong> <%= brand %></p>
                                    <p><strong>Model:</strong> <%= model %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Processor:</strong> <%= processor %></p>
                                    <p><strong>RAM:</strong> <%= ram %></p>
                                    <p><strong>Storage:</strong> <%= storage %></p>
                                    <p><strong>Status:</strong> 
                                        <span class="badge <%= "working".equals(status) ? "bg-success" : "damaged".equals(status) ? "bg-danger" : "bg-warning" %>">
                                            <%= status %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="alert alert-warning">
                        <h5>No Assigned Computer</h5>
                        <p>You do not have an assigned computer. Contact admin for assignment.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



