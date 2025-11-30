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
    String computerDetails = "";

    if (conn != null) {
        try {
            int staffId = (Integer) session.getAttribute("user_id");
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM computer WHERE assigned_to = ?");
            pstmt.setInt(1, staffId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                hasAssignedComputer = true;
                computerDetails = "Lab: " + rs.getString("lab_name") + ", Computer: " + rs.getString("computer_number") +
                                  ", Brand: " + rs.getString("brand") + ", Status: " + rs.getString("status");
            }
            rs.close(); pstmt.close();
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
    <title>Staff Dashboard - CLMS</title>
    <!-- Modern Theme -->
    <link rel="stylesheet" href="modern-theme.css">
</head>
<body class="bg-gray-50">
    <!-- Layout Container -->
    <div class="layout-container">
        <%@ include file="header.jsp" %>
        <%@ include file="navigation.jsp" %>

        <!-- Main Content -->
        <div class="main-area">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Welcome Header -->
            <div class="bg-gradient-to-r from-cyan-500 via-blue-500 to-indigo-600 rounded-3xl p-8 mb-8 text-white relative overflow-hidden">
                <div class="absolute inset-0 bg-black/10"></div>
                <div class="relative">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-4xl font-bold mb-2">Welcome back, <%= session.getAttribute("name") %>!</h1>
                            <p class="text-xl text-cyan-100">Ready to manage your lab sessions efficiently</p>
                        </div>
                        <div class="hidden md:block">
                            <div class="p-4 bg-white/10 rounded-2xl backdrop-blur-sm">
                                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="mt-6 flex flex-wrap gap-4">
                        <div class="bg-white/10 backdrop-blur-sm rounded-xl px-4 py-2">
                            <span class="text-sm font-medium">Role: Staff Member</span>
                        </div>
                        <div class="bg-white/10 backdrop-blur-sm rounded-xl px-4 py-2">
                            <span class="text-sm font-medium">Status: Active</span>
                        </div>
                        <% if (hasAssignedComputer) { %>
                        <div class="bg-emerald-500/20 backdrop-blur-sm rounded-xl px-4 py-2">
                            <span class="text-sm font-medium">Computer: Assigned</span>
                        </div>
                        <% } else { %>
                        <div class="bg-amber-500/20 backdrop-blur-sm rounded-xl px-4 py-2">
                            <span class="text-sm font-medium">Computer: Pending</span>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Compact Stats Row -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <!-- Computer Status -->
                <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Computer Status</p>
                            <p class="text-2xl font-bold text-gray-900"><%= hasAssignedComputer ? "Assigned" : "Pending" %></p>
                        </div>
                        <div class="p-3 <%= hasAssignedComputer ? "bg-green-100" : "bg-amber-100" %> rounded-xl">
                            <svg class="w-6 h-6 <%= hasAssignedComputer ? "text-green-600" : "text-amber-600" %>" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<%= hasAssignedComputer ? "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" : "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" %>"></path>
                            </svg>
                        </div>
                    </div>
                    <% if (hasAssignedComputer) { %>
                    <p class="text-xs text-gray-500 mt-2"><%= computerDetails %></p>
                    <% } %>
                </div>

                <!-- Today's Usage -->
                <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Today's Usage</p>
                            <p class="text-2xl font-bold text-gray-900">2.5h</p>
                        </div>
                        <div class="p-3 bg-blue-100 rounded-xl">
                            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2 mt-3">
                        <div class="bg-gradient-to-r from-blue-500 to-blue-600 h-2 rounded-full" style="width: 62%"></div>
                    </div>
                </div>

                <!-- Active Sessions -->
                <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">Active Sessions</p>
                            <p class="text-2xl font-bold text-gray-900">1</p>
                        </div>
                        <div class="p-3 bg-purple-100 rounded-xl">
                            <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                            </svg>
                        </div>
                    </div>
                    <p class="text-xs text-gray-500 mt-2">Currently logged in</p>
                </div>
            </div>

            <!-- Activity Timeline & Quick Actions -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Activity Timeline -->
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
                        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                            <svg class="w-7 h-7 text-indigo-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            Activity Timeline
                        </h3>
                        <div class="relative">
                            <!-- Timeline line -->
                            <div class="absolute left-6 top-0 bottom-0 w-0.5 bg-gradient-to-b from-indigo-500 to-purple-500"></div>

                            <!-- Timeline items -->
                            <div class="space-y-8">
                                <div class="relative flex items-start">
                                    <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-indigo-500 to-indigo-600 rounded-full flex items-center justify-center shadow-lg">
                                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                                        </svg>
                                    </div>
                                    <div class="ml-6 bg-gray-50 rounded-2xl p-6 flex-1 shadow-sm">
                                        <h4 class="text-lg font-semibold text-gray-900">Welcome to CLMS</h4>
                                        <p class="text-gray-600 mt-1">You successfully logged into the system</p>
                                        <div class="flex items-center mt-3 text-sm text-gray-500">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                            Just now
                                        </div>
                                    </div>
                                </div>

                                <% if (hasAssignedComputer) { %>
                                <div class="relative flex items-start">
                                    <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-green-500 to-green-600 rounded-full flex items-center justify-center shadow-lg">
                                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                    </div>
                                    <div class="ml-6 bg-green-50 rounded-2xl p-6 flex-1 shadow-sm border border-green-200">
                                        <h4 class="text-lg font-semibold text-gray-900">Computer Assigned</h4>
                                        <p class="text-gray-600 mt-1">You have been assigned a workstation</p>
                                        <p class="text-sm text-green-700 mt-2 font-medium"><%= computerDetails %></p>
                                        <div class="flex items-center mt-3 text-sm text-gray-500">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                            </svg>
                                            Today
                                        </div>
                                    </div>
                                </div>
                                <% } %>

                                <div class="relative flex items-start">
                                    <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center shadow-lg">
                                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1.586a1 1 0 01.707.293l.707.707A1 1 0 0012.414 11H15m-3-3h1.586a1 1 0 01.707.293l.707.707A1 1 0 0015.414 9H18m-3-3h1.586a1 1 0 01.707.293l.707.707A1 1 0 0017.414 7H20M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                    </div>
                                    <div class="ml-6 bg-blue-50 rounded-2xl p-6 flex-1 shadow-sm border border-blue-200">
                                        <h4 class="text-lg font-semibold text-gray-900">Lab Session Started</h4>
                                        <p class="text-gray-600 mt-1">You began using the computer lab system</p>
                                        <div class="flex items-center mt-3 text-sm text-gray-500">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                            2 hours ago
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="space-y-4">
                    <h3 class="text-xl font-bold text-gray-900 mb-4">Quick Actions</h3>

                    <a href="staff_usage.jsp" class="group block bg-gradient-to-r from-green-500 to-green-600 rounded-2xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                        <div class="flex items-center">
                            <div class="p-3 bg-white/20 rounded-xl mr-4 group-hover:scale-110 transition-transform duration-300">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1.586a1 1 0 01.707.293l.707.707A1 1 0 0012.414 11H15m-3-3h1.586a1 1 0 01.707.293l.707.707A1 1 0 0015.414 9H18m-3-3h1.586a1 1 0 01.707.293l.707.707A1 1 0 0017.414 7H20M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <h4 class="font-semibold">Log Usage</h4>
                                <p class="text-green-100 text-sm">Track your sessions</p>
                            </div>
                        </div>
                    </a>

                    <a href="add_maintenance.jsp" class="group block bg-gradient-to-r from-amber-500 to-orange-500 rounded-2xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                        <div class="flex items-center">
                            <div class="p-3 bg-white/20 rounded-xl mr-4 group-hover:scale-110 transition-transform duration-300">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                            </div>
                            <div>
                                <h4 class="font-semibold">Report Issue</h4>
                                <p class="text-amber-100 text-sm">Request maintenance</p>
                            </div>
                        </div>
                    </a>

                    <a href="maintenance_status.jsp" class="group block bg-gradient-to-r from-blue-500 to-indigo-500 rounded-2xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                        <div class="flex items-center">
                            <div class="p-3 bg-white/20 rounded-xl mr-4 group-hover:scale-110 transition-transform duration-300">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                </svg>
                            </div>
                            <div>
                                <h4 class="font-semibold">Check Status</h4>
                                <p class="text-blue-100 text-sm">View requests</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>



