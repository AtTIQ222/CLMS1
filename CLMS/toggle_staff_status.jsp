<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int staffId = Integer.parseInt(request.getParameter("id"));
    Connection conn = (Connection) application.getAttribute("dbConnection");
    String message = "";
    if (conn != null) {
        try {
            // Get current status
            PreparedStatement pstmt = conn.prepareStatement("SELECT status FROM staff WHERE staff_id = ?");
            pstmt.setInt(1, staffId);
            ResultSet rs = pstmt.executeQuery();
            String currentStatus = "";
            if (rs.next()) {
                currentStatus = rs.getString("status");
            }
            rs.close();
            pstmt.close();

            // Toggle status
            String newStatus = "active".equals(currentStatus) ? "inactive" : "active";
            pstmt = conn.prepareStatement("UPDATE staff SET status = ? WHERE staff_id = ?");
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, staffId);
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Staff status updated to " + newStatus + "!";
            } else {
                message = "Failed to update status.";
            }
            pstmt.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
    response.sendRedirect("view_staff.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>



