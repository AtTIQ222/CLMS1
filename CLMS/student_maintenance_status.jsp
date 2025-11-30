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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Maintenance Requests - CLMS</title>
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
                        <svg class="w-8 h-8 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                        </svg>
                        My Maintenance Requests
                    </h1>
                    <p class="mt-2 text-gray-600">Track the status of your maintenance requests</p>
                </div>

                <!-- Status Overview Cards -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <%
                    int pendingCount = 0, inProgressCount = 0, completedCount = 0, totalCount = 0;
                    if (conn != null) {
                        try {
                            // Count by status
                            PreparedStatement pstmt = conn.prepareStatement("SELECT status, COUNT(*) as count FROM maintenance WHERE student_id = ? GROUP BY status");
                            pstmt.setInt(1, studentId);
                            ResultSet rs = pstmt.executeQuery();
                            while (rs.next()) {
                                String status = rs.getString("status");
                                int count = rs.getInt("count");
                                totalCount += count;
                                if ("pending".equals(status)) pendingCount = count;
                                else if ("in-progress".equals(status)) inProgressCount = count;
                                else if ("completed".equals(status)) completedCount = count;
                            }
                            rs.close(); pstmt.close();
                        } catch (Exception e) {
                            // Handle error
                        }
                    }
                    %>
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Total Requests</p>
                                <p class="text-2xl font-bold text-gray-900"><%= totalCount %></p>
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
                                <p class="text-sm font-medium text-gray-600">Pending</p>
                                <p class="text-2xl font-bold text-yellow-600"><%= pendingCount %></p>
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
                                <p class="text-2xl font-bold text-blue-600"><%= inProgressCount %></p>
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
                                <p class="text-sm font-medium text-gray-600">Completed</p>
                                <p class="text-2xl font-bold text-green-600"><%= completedCount %></p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-xl">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Requests Table -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                    <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">All Requests</h3>
                        <p class="text-sm text-gray-600">Detailed view of your maintenance requests</p>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Issue</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Computer</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Priority</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Submitted</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Technician</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Solution</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement(
                                            "SELECT m.*, c.computer_number, c.lab_name, t.name AS technician_name " +
                                            "FROM maintenance m " +
                                            "JOIN computer c ON m.computer_id = c.computer_id " +
                                            "LEFT JOIN technician t ON m.assigned_technician = t.technician_id " +
                                            "WHERE m.student_id = ? " +
                                            "ORDER BY m.request_date DESC"
                                        );
                                        pstmt.setInt(1, studentId);
                                        ResultSet rs = pstmt.executeQuery();
                                        boolean hasRequests = false;
                                        while (rs.next()) {
                                            hasRequests = true;
                                            String status = rs.getString("status");
                                            String statusClass = "";
                                            String statusText = "";
                                            if ("pending".equals(status)) {
                                                statusClass = "bg-yellow-100 text-yellow-800";
                                                statusText = "Pending Review";
                                            } else if ("reviewed".equals(status)) {
                                                statusClass = "bg-blue-100 text-blue-800";
                                                statusText = "Under Review";
                                            } else if ("in-progress".equals(status)) {
                                                statusClass = "bg-blue-100 text-blue-800";
                                                statusText = "In Progress";
                                            } else if ("completed".equals(status)) {
                                                statusClass = "bg-green-100 text-green-800";
                                                statusText = "Completed";
                                            } else {
                                                statusClass = "bg-gray-100 text-gray-800";
                                                statusText = status;
                                            }

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
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <%= rs.getDate("request_date") %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <%= rs.getString("technician_name") != null ? rs.getString("technician_name") : "Not Assigned" %>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <%= rs.getString("solution_notes") != null ? rs.getString("solution_notes") : "Not completed yet" %>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close(); pstmt.close();
                                        if (!hasRequests) {
                                %>
                                <tr>
                                    <td colspan="7" class="px-6 py-12 text-center">
                                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                        </svg>
                                        <h3 class="mt-2 text-sm font-medium text-gray-900">No maintenance requests</h3>
                                        <p class="mt-1 text-sm text-gray-500">You haven't submitted any maintenance requests yet.</p>
                                        <div class="mt-6">
                                            <a href="student_maintenance_request.jsp" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
                                                <svg class="-ml-1 mr-2 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                                </svg>
                                                Submit First Request
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='7' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Help Section -->
                <div class="bg-blue-50 rounded-2xl p-6 mt-8 border border-blue-200">
                    <h3 class="text-lg font-semibold text-blue-900 mb-4 flex items-center">
                        <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        Need Help?
                    </h3>
                    <div class="text-blue-800 space-y-2 text-sm">
                        <p>• <strong>Pending Review:</strong> Your request is being reviewed by lab staff</p>
                        <p>• <strong>In Progress:</strong> A technician is working on your issue</p>
                        <p>• <strong>Completed:</strong> Issue has been resolved - check solution notes</p>
                        <p>• Contact your lab instructor if you need urgent assistance</p>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>