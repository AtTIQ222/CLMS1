<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int computerId = Integer.parseInt(request.getParameter("id"));
    Connection conn = (Connection) application.getAttribute("dbConnection");
    String message = "";
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM computer WHERE computer_id = ?");
            pstmt.setInt(1, computerId);
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Computer deleted successfully!";
            } else {
                message = "Failed to delete computer.";
            }
            pstmt.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
    response.sendRedirect("view_computer.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>



