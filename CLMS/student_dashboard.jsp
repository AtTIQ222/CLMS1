<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if student is logged in
    if (session.getAttribute("user_type") == null || !"student".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = (Connection) application.getAttribute("dbConnection");
    int studentId = (Integer) session.getAttribute("user_id");
    String studentName = (String) session.getAttribute("name");

    // Get student lab info
    String labName = "";
    int labId = 0;
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT l.lab_name, s.lab_id FROM students s JOIN labs l ON s.lab_id = l.lab_id WHERE s.student_id = ?");
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                labName = rs.getString("lab_name");
                labId = rs.getInt("lab_id");
            }
            rs.close(); pstmt.close();
        } catch (Exception e) {
            // Handle error
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - CLMS</title>
    <link rel="stylesheet" href="modern-theme.css">
</head>
<body class="bg-gray-50">
    <div class="layout-container">
        <%@ include file="header.jsp" %>
        <%@ include file="navigation.jsp" %>

        <div class="main-area">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 class="text-2xl font-bold text-gray-900" style="color: #000000;">Welcome, <%= studentName %>!</h1>
                    <p class="mt-1 text-gray-600">Access your lab resources and track maintenance</p>
                </div>

                <!-- Quick Actions -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <a href="student_maintenance_request.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-red-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">Report Issue</div>
                                <div class="text-sm text-gray-600">Submit maintenance request</div>
                            </div>
                        </div>
                    </a>

                    <a href="student_maintenance_status.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-blue-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">My Requests</div>
                                <div class="text-sm text-gray-600">Track maintenance status</div>
                            </div>
                        </div>
                    </a>

                    <a href="student_lab_usage.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-green-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">Lab Usage</div>
                                <div class="text-sm text-gray-600">View session history</div>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Recent Activity -->
                <div class="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
                    <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                        <svg class="w-7 h-7 text-indigo-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        Recent Activity
                    </h3>
                    <div class="space-y-4">
                        <%
                        if (conn != null) {
                            try {
                                PreparedStatement pstmt = conn.prepareStatement(
                                    "SELECT slu.*, c.computer_number, c.lab_name FROM student_lab_usage slu " +
                                    "JOIN computer c ON slu.computer_id = c.computer_id " +
                                    "WHERE slu.student_id = ? ORDER BY slu.login_time DESC LIMIT 5"
                                );
                                pstmt.setInt(1, studentId);
                                ResultSet rs = pstmt.executeQuery();
                                boolean hasActivity = false;
                                while (rs.next()) {
                                    hasActivity = true;
                        %>
                        <div class="flex items-center p-4 bg-gray-50 rounded-xl">
                            <div class="p-2 bg-blue-100 rounded-lg mr-4">
                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                </svg>
                            </div>
                            <div class="flex-1">
                                <h4 class="font-semibold text-gray-900">Lab Session</h4>
                                <p class="text-sm text-gray-600">Computer <%= rs.getString("computer_number") %> in <%= rs.getString("lab_name") %></p>
                                <p class="text-xs text-gray-500"><%= rs.getTimestamp("login_time") %> - <%= rs.getTimestamp("logout_time") != null ? rs.getTimestamp("logout_time") : "Active" %></p>
                            </div>
                        </div>
                        <%
                                }
                                rs.close(); pstmt.close();
                                if (!hasActivity) {
                        %>
                        <div class="text-center py-8">
                            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <p class="text-gray-500">No recent lab activity</p>
                        </div>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<p class='text-red-500'>Error loading activity: " + e.getMessage() + "</p>");
                            }
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>