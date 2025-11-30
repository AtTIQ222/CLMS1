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
    <title>Lab Usage History - CLMS</title>
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
                        <svg class="w-8 h-8 text-green-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        Lab Usage History
                    </h1>
                    <p class="mt-2 text-gray-600">View your computer lab session history</p>
                </div>

                <!-- Usage Statistics -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <%
                    int totalSessions = 0, activeSessions = 0;
                    double totalHours = 0.0;
                    if (conn != null) {
                        try {
                            // Total sessions
                            PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM student_lab_usage WHERE student_id = ?");
                            pstmt.setInt(1, studentId);
                            ResultSet rs = pstmt.executeQuery();
                            if (rs.next()) totalSessions = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // Active sessions
                            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM student_lab_usage WHERE student_id = ? AND logout_time IS NULL");
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) activeSessions = rs.getInt(1);
                            rs.close(); pstmt.close();

                            // Total hours (simplified calculation)
                            pstmt = conn.prepareStatement("SELECT SUM(TIMESTAMPDIFF(MINUTE, login_time, COALESCE(logout_time, NOW())) / 60.0) as total_hours FROM student_lab_usage WHERE student_id = ? AND logout_time IS NOT NULL");
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) totalHours = rs.getDouble(1);
                            rs.close(); pstmt.close();

                        } catch (Exception e) {
                            // Handle error
                        }
                    }
                    %>
                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Total Sessions</p>
                                <p class="text-2xl font-bold text-gray-900"><%= totalSessions %></p>
                            </div>
                            <div class="p-3 bg-blue-100 rounded-xl">
                                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Active Sessions</p>
                                <p class="text-2xl font-bold text-green-600"><%= activeSessions %></p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-xl">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Total Hours</p>
                                <p class="text-2xl font-bold text-purple-600"><%= String.format("%.1f", totalHours) %></p>
                            </div>
                            <div class="p-3 bg-purple-100 rounded-xl">
                                <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Avg. Session</p>
                                <p class="text-2xl font-bold text-indigo-600"><%= totalSessions > 0 ? String.format("%.1f", totalHours / totalSessions) : "0.0" %>h</p>
                            </div>
                            <div class="p-3 bg-indigo-100 rounded-xl">
                                <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Usage History Table -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                    <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">Session History</h3>
                        <p class="text-sm text-gray-600">Detailed view of your lab sessions</p>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Computer</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Login Time</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Logout Time</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duration</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Purpose</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement(
                                            "SELECT slu.*, c.computer_number, c.lab_name " +
                                            "FROM student_lab_usage slu " +
                                            "JOIN computer c ON slu.computer_id = c.computer_id " +
                                            "WHERE slu.student_id = ? " +
                                            "ORDER BY slu.login_time DESC"
                                        );
                                        pstmt.setInt(1, studentId);
                                        ResultSet rs = pstmt.executeQuery();
                                        boolean hasUsage = false;
                                        while (rs.next()) {
                                            hasUsage = true;
                                            Timestamp loginTime = rs.getTimestamp("login_time");
                                            Timestamp logoutTime = rs.getTimestamp("logout_time");
                                            String duration = "Active";
                                            String statusClass = "bg-green-100 text-green-800";
                                            String statusText = "Active";

                                            if (logoutTime != null) {
                                                long diffInMillies = logoutTime.getTime() - loginTime.getTime();
                                                long diffInHours = diffInMillies / (60 * 60 * 1000);
                                                long diffInMinutes = (diffInMillies / (60 * 1000)) % 60;
                                                duration = diffInHours + "h " + diffInMinutes + "m";
                                                statusClass = "bg-gray-100 text-gray-800";
                                                statusText = "Completed";
                                            }
                                %>
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm font-medium text-gray-900"><%= rs.getString("lab_name") %></div>
                                        <div class="text-sm text-gray-500">Computer <%= rs.getString("computer_number") %></div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(loginTime) %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <%= logoutTime != null ? new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(logoutTime) : "Still Active" %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <%= duration %>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <%= rs.getString("purpose") != null ? rs.getString("purpose") : "Not specified" %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close(); pstmt.close();
                                        if (!hasUsage) {
                                %>
                                <tr>
                                    <td colspan="6" class="px-6 py-12 text-center">
                                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                        <h3 class="mt-2 text-sm font-medium text-gray-900">No lab usage history</h3>
                                        <p class="mt-1 text-sm text-gray-500">You haven't used any lab computers yet.</p>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='6' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Usage Guidelines -->
                <div class="bg-green-50 rounded-2xl p-6 mt-8 border border-green-200">
                    <h3 class="text-lg font-semibold text-green-900 mb-4 flex items-center">
                        <svg class="w-6 h-6 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        Lab Usage Guidelines
                    </h3>
                    <div class="text-green-800 space-y-2 text-sm">
                        <p>• Always log out properly when finishing your session</p>
                        <p>• Report any computer issues immediately using the maintenance system</p>
                        <p>• Respect lab rules and keep the environment clean</p>
                        <p>• Use computers only for academic purposes</p>
                        <p>• Contact lab staff if you need assistance</p>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>