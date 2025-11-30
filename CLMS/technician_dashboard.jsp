<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if technician is logged in
    if (session.getAttribute("user_type") == null || !"technician".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = (Connection) application.getAttribute("dbConnection");
    int technicianId = (Integer) session.getAttribute("user_id");
    String technicianName = (String) session.getAttribute("name");

    // Get technician stats
    int pendingTasks = 0, inProgressTasks = 0, completedToday = 0;
    if (conn != null) {
        try {
            // Pending tasks
            PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'pending'");
            pstmt.setInt(1, technicianId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) pendingTasks = rs.getInt(1);
            rs.close(); pstmt.close();

            // In progress tasks
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'in-progress'");
            pstmt.setInt(1, technicianId);
            rs = pstmt.executeQuery();
            if (rs.next()) inProgressTasks = rs.getInt(1);
            rs.close(); pstmt.close();

            // Completed today
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'completed' AND DATE(actual_completion) = CURDATE()");
            pstmt.setInt(1, technicianId);
            rs = pstmt.executeQuery();
            if (rs.next()) completedToday = rs.getInt(1);
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
    <title>Technician Dashboard - CLMS</title>
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
                    <h1 class="text-2xl font-bold text-gray-900">Technician Dashboard</h1>
                    <p class="mt-1 text-gray-600">Manage maintenance requests and repairs</p>
                </div>

                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Pending Tasks</p>
                                <p class="text-3xl font-bold text-gray-900"><%= pendingTasks %></p>
                            </div>
                            <div class="p-3 bg-yellow-100 rounded-xl">
                                <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">In Progress</p>
                                <p class="text-3xl font-bold text-gray-900"><%= inProgressTasks %></p>
                            </div>
                            <div class="p-3 bg-blue-100 rounded-xl">
                                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Completed Today</p>
                                <p class="text-3xl font-bold text-gray-900"><%= completedToday %></p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-xl">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <a href="technician_maintenance_panel.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-blue-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">Assigned Maintenance Tasks</div>
                                <div class="text-sm text-gray-600">Manage repair tasks</div>
                            </div>
                        </div>
                    </a>

                    <a href="technician_reports.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-green-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">Update Status</div>
                                <div class="text-sm text-gray-600">View work reports</div>
                            </div>
                        </a>
                    </a>

                    <a href="technician_profile.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                        <div class="flex items-center">
                            <div class="p-2 bg-purple-100 rounded-md mr-3">
                                <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="font-medium text-gray-900">View Completed Tasks</div>
                                <div class="text-sm text-gray-600">Update information</div>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Recent Tasks -->
                <div class="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
                    <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                        <svg class="w-7 h-7 text-indigo-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                        </svg>
                        Recent Tasks
                    </h3>
                    <div class="space-y-4">
                        <%
                        if (conn != null) {
                            try {
                                PreparedStatement pstmt = conn.prepareStatement(
                                    "SELECT m.*, c.computer_number, c.lab_name, s.name AS student_name FROM maintenance m " +
                                    "JOIN computer c ON m.computer_id = c.computer_id " +
                                    "LEFT JOIN students s ON m.student_id = s.student_id " +
                                    "WHERE m.assigned_technician = ? ORDER BY m.request_date DESC LIMIT 5"
                                );
                                pstmt.setInt(1, technicianId);
                                ResultSet rs = pstmt.executeQuery();
                                boolean hasTasks = false;
                                while (rs.next()) {
                                    hasTasks = true;
                                    String statusClass = "";
                                    String statusText = rs.getString("status");
                                    if ("pending".equals(statusText)) statusClass = "bg-yellow-100 text-yellow-800";
                                    else if ("in-progress".equals(statusText)) statusClass = "bg-blue-100 text-blue-800";
                                    else if ("completed".equals(statusText)) statusClass = "bg-green-100 text-green-800";
                        %>
                        <div class="flex items-center p-4 bg-gray-50 rounded-xl">
                            <div class="p-2 bg-blue-100 rounded-lg mr-4">
                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                            </div>
                            <div class="flex-1">
                                <h4 class="font-semibold text-gray-900"><%= rs.getString("issue_type") %> Issue</h4>
                                <p class="text-sm text-gray-600">Computer <%= rs.getString("computer_number") %> in <%= rs.getString("lab_name") %></p>
                                <p class="text-xs text-gray-500">Requested: <%= rs.getDate("request_date") %></p>
                                <% if (rs.getString("student_name") != null) { %>
                                <p class="text-xs text-gray-500">Reported by: <%= rs.getString("student_name") %></p>
                                <% } %>
                            </div>
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </div>
                        <%
                                }
                                rs.close(); pstmt.close();
                                if (!hasTasks) {
                        %>
                        <div class="text-center py-8">
                            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                            </svg>
                            <p class="text-gray-500">No maintenance tasks assigned</p>
                        </div>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<p class='text-red-500'>Error loading tasks: " + e.getMessage() + "</p>");
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