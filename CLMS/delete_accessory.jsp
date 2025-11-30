<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int accessoryId = Integer.parseInt(request.getParameter("id"));
    Connection conn = (Connection) application.getAttribute("dbConnection");
    String message = "";
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM accessory WHERE accessory_id = ?");
            pstmt.setInt(1, accessoryId);
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Accessory deleted successfully!";
            } else {
                message = "Failed to delete accessory.";
            }
            pstmt.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
    response.sendRedirect("view_accessory.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>



