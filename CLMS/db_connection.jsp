<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Database connection parameters
    String dbURL = "jdbc:mysql://localhost:3306/lab_db?useSSL=false&serverTimezone=UTC";
    String dbUser = "root"; // Change if needed
    String dbPassword = ""; // Change if needed

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        // Store connection in application scope for global access
        application.setAttribute("dbConnection", conn);
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Database connection failed: " + e.getMessage() + "</div>");
    }
%>



