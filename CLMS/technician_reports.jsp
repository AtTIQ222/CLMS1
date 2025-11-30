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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Reports - CLMS</title>
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
                    <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                        <svg class="w-8 h-8 text-purple-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                        Work Reports
                    </h1>
                    <p class="mt-2 text-gray-600">View your maintenance work statistics and reports</p>
                </div>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <%
                    int totalTasks = 0, completedTasks = 0, pendingTasks = 0, inProgressTasks = 0;
                    double avgResolutionTime = 0.0;
                    if (conn != null) {
                        try {
                            // Total tasks assigned
                            PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ?");
                            pstmt.setInt(1, technicianId);
                            ResultSet rs = pstmt.executeQuery();
                            if (rs.next()) totalTasks = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // Completed tasks
                            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'completed'");
                            pstmt.setInt(1, technicianId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) completedTasks = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // Pending tasks
                            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'pending'");
                            pstmt.setInt(1, technicianId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) pendingTasks = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // In progress tasks
                            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE assigned_technician = ? AND status = 'in-progress'");
                            pstmt.setInt(1, technicianId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) inProgressTasks = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // Average resolution time (in hours)
                            pstmt = conn.prepareStatement(
                                "SELECT AVG(TIMESTAMPDIFF(HOUR, request_date, actual_completion)) as avg_hours " +
                                "FROM maintenance WHERE assigned_technician = ? AND status = 'completed' AND actual_completion IS NOT NULL"
                            );
                            pstmt.setInt(1, technicianId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) avgResolutionTime = rs.getDouble(1);
                            rs.close(); pstmt.close();

                        } catch (Exception e) {
                            // Handle error
                        }
                    }
                    %>
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Total Tasks</p>
                                <p class="text-2xl font-bold text-gray-900"><%= totalTasks %></p>
                            </div>
                            <div class="p-3 bg-gray-100 rounded-xl">
                                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Completed</p>
                                <p class="text-2xl font-bold text-green-600"><%= completedTasks %></p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-xl">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">In Progress</p>
                                <p class="text-2xl font-bold text-blue-600"><%= inProgressTasks %></p>
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
                                <p class="text-sm font-medium text-gray-600">Avg. Resolution</p>
                                <p class="text-2xl font-bold text-purple-600"><%= !Double.isNaN(avgResolutionTime) ? String.format("%.1f", avgResolutionTime) : "0.0" %>h</p>
                            </div>
                            <div class="p-3 bg-purple-100 rounded-xl">
                                <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Issue Type Breakdown -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <!-- Issue Types -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Issues by Type</h3>
                        <div class="space-y-3">
                            <%
                            if (conn != null) {
                                try {
                                    PreparedStatement pstmt = conn.prepareStatement(
                                        "SELECT issue_type, COUNT(*) as count FROM maintenance " +
                                        "WHERE assigned_technician = ? GROUP BY issue_type ORDER BY count DESC"
                                    );
                                    pstmt.setInt(1, technicianId);
                                    ResultSet rs = pstmt.executeQuery();
                                    boolean hasData = false;
                                    while (rs.next()) {
                                        hasData = true;
                                        String issueType = rs.getString("issue_type");
                                        int count = rs.getInt("count");
                                        double percentage = totalTasks > 0 ? (count * 100.0 / totalTasks) : 0;
                            %>
                            <div class="flex items-center justify-between">
                                <span class="text-sm font-medium text-gray-700"><%= issueType %></span>
                                <div class="flex items-center space-x-2">
                                    <div class="w-24 bg-gray-200 rounded-full h-2">
                                        <div class="bg-blue-600 h-2 rounded-full" style="width: <%= percentage %>%"></div>
                                    </div>
                                    <span class="text-sm text-gray-600 w-8 text-right"><%= count %></span>
                                </div>
                            </div>
                            <%
                                    }
                                    rs.close(); pstmt.close();
                                    if (!hasData) {
                            %>
                            <p class="text-gray-500 text-center py-4">No issues resolved yet</p>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<p class='text-red-500'>Error loading issue types: " + e.getMessage() + "</p>");
                                }
                            }
                            %>
                        </div>
                    </div>

                    <!-- Priority Breakdown -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Issues by Priority</h3>
                        <div class="space-y-3">
                            <%
                            if (conn != null) {
                                try {
                                    PreparedStatement pstmt = conn.prepareStatement(
                                        "SELECT priority, COUNT(*) as count FROM maintenance " +
                                        "WHERE assigned_technician = ? GROUP BY priority ORDER BY " +
                                        "CASE priority WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 WHEN 'Low' THEN 4 END"
                                    );
                                    pstmt.setInt(1, technicianId);
                                    ResultSet rs = pstmt.executeQuery();
                                    boolean hasData = false;
                                    while (rs.next()) {
                                        hasData = true;
                                        String priority = rs.getString("priority");
                                        int count = rs.getInt("count");
                                        double percentage = totalTasks > 0 ? (count * 100.0 / totalTasks) : 0;
                                        String colorClass = "";
                                        if ("Critical".equals(priority)) colorClass = "bg-red-600";
                                        else if ("High".equals(priority)) colorClass = "bg-orange-600";
                                        else if ("Medium".equals(priority)) colorClass = "bg-yellow-600";
                                        else colorClass = "bg-green-600";
                            %>
                            <div class="flex items-center justify-between">
                                <span class="text-sm font-medium text-gray-700"><%= priority %></span>
                                <div class="flex items-center space-x-2">
                                    <div class="w-24 bg-gray-200 rounded-full h-2">
                                        <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentage %>%"></div>
                                    </div>
                                    <span class="text-sm text-gray-600 w-8 text-right"><%= count %></span>
                                </div>
                            </div>
                            <%
                                    }
                                    rs.close(); pstmt.close();
                                    if (!hasData) {
                            %>
                            <p class="text-gray-500 text-center py-4">No priority data available</p>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<p class='text-red-500'>Error loading priorities: " + e.getMessage() + "</p>");
                                }
                            }
                            %>
                        </div>
                    </div>
                </div>

                <!-- Recent Completed Tasks -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                    <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">Recent Completed Tasks</h3>
                        <p class="text-sm text-gray-600">Your latest resolved maintenance issues</p>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Issue</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Computer</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Priority</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Completed</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Resolution Time</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement(
                                            "SELECT m.*, c.computer_number, c.lab_name, " +
                                            "TIMESTAMPDIFF(HOUR, m.request_date, m.actual_completion) as resolution_hours " +
                                            "FROM maintenance m " +
                                            "JOIN computer c ON m.computer_id = c.computer_id " +
                                            "WHERE m.assigned_technician = ? AND m.status = 'completed' " +
                                            "ORDER BY m.actual_completion DESC LIMIT 10"
                                        );
                                        pstmt.setInt(1, technicianId);
                                        ResultSet rs = pstmt.executeQuery();
                                        boolean hasTasks = false;
                                        while (rs.next()) {
                                            hasTasks = true;
                                            String priorityClass = "";
                                            String priority = rs.getString("priority");
                                            if ("Critical".equals(priority)) priorityClass = "bg-red-100 text-red-800";
                                            else if ("High".equals(priority)) priorityClass = "bg-orange-100 text-orange-800";
                                            else if ("Medium".equals(priority)) priorityClass = "bg-yellow-100 text-yellow-800";
                                            else priorityClass = "bg-green-100 text-green-800";
                                %>
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4">
                                        <div class="text-sm font-medium text-gray-900"><%= rs.getString("issue_type") %></div>
                                        <div class="text-sm text-gray-500 truncate max-w-xs"><%= rs.getString("issue_description") %></div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900"><%= rs.getString("lab_name") %></div>
                                        <div class="text-sm text-gray-500">PC <%= rs.getString("computer_number") %></div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= priorityClass %>">
                                            <%= priority %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <%= rs.getDate("actual_completion") %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <%= rs.getInt("resolution_hours") %> hours
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close(); pstmt.close();
                                        if (!hasTasks) {
                                %>
                                <tr>
                                    <td colspan="5" class="px-6 py-12 text-center">
                                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                        <h3 class="mt-2 text-sm font-medium text-gray-900">No completed tasks</h3>
                                        <p class="mt-1 text-sm text-gray-500">Complete some maintenance tasks to see your work history.</p>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='5' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>