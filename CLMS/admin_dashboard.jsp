<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Database connection
    String dbURL = "jdbc:mysql://localhost:3306/lab_db?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "";
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    } catch (Exception e) {
        out.println("<div class='alert alert-danger p-4 rounded-lg'>Database connection failed: " + e.getMessage() + "</div>");
    }
    int totalStaff = 0, totalComputers = 0, totalAccessories = 0, availableComputers = 0, pendingMaintenance = 0, activeUsers = 0;

    if (conn != null) {
        try {
            // Total Staff
            PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM staff");
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) totalStaff = rs.getInt(1);
            rs.close(); pstmt.close();

            // Total Computers
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM computer");
            rs = pstmt.executeQuery();
            if (rs.next()) totalComputers = rs.getInt(1);
            rs.close(); pstmt.close();

            // Total Accessories
            pstmt = conn.prepareStatement("SELECT SUM(quantity) FROM accessory");
            rs = pstmt.executeQuery();
            if (rs.next()) totalAccessories = rs.getInt(1);
            rs.close(); pstmt.close();

            // Available Computers
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM computer WHERE assigned_to IS NULL AND status = 'working'");
            rs = pstmt.executeQuery();
            if (rs.next()) availableComputers = rs.getInt(1);
            rs.close(); pstmt.close();

            // Pending Maintenance
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM maintenance WHERE status = 'pending'");
            rs = pstmt.executeQuery();
            if (rs.next()) pendingMaintenance = rs.getInt(1);
            rs.close(); pstmt.close();

            // Active Users (staff currently logged in, assuming no logout means active)
            pstmt = conn.prepareStatement("SELECT COUNT(DISTINCT staff_id) FROM lab_usage WHERE logout_time IS NULL");
            rs = pstmt.executeQuery();
            if (rs.next()) activeUsers = rs.getInt(1);
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
    <title>Admin Dashboard - CLMS</title>
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
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 class="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
                    <p class="mt-1 text-gray-600">Manage your computer lab system</p>
                </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= totalStaff %></div>
                            <div class="text-sm text-gray-600">Total Staff</div>
                        </div>
                        <div class="p-2 bg-blue-100 rounded-md">
                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= totalComputers %></div>
                            <div class="text-sm text-gray-600">Total Computers</div>
                        </div>
                        <div class="p-2 bg-green-100 rounded-md">
                            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= totalAccessories %></div>
                            <div class="text-sm text-gray-600">Total Accessories</div>
                        </div>
                        <div class="p-2 bg-purple-100 rounded-md">
                            <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= availableComputers %></div>
                            <div class="text-sm text-gray-600">Available Computers</div>
                        </div>
                        <div class="p-2 bg-emerald-100 rounded-md">
                            <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= pendingMaintenance %></div>
                            <div class="text-sm text-gray-600">Pending Maintenance</div>
                        </div>
                        <div class="p-2 bg-amber-100 rounded-md">
                            <svg class="w-5 h-5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <div class="text-2xl font-bold text-gray-900"><%= activeUsers %></div>
                            <div class="text-sm text-gray-600">Active Users</div>
                        </div>
                        <div class="p-2 bg-cyan-100 rounded-md">
                            <svg class="w-5 h-5 text-cyan-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <a href="add_staff.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                    <div class="flex items-center">
                        <div class="p-2 bg-blue-100 rounded-md mr-3">
                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="font-medium text-gray-900">Add Staff</div>
                            <div class="text-sm text-gray-600">Register new members</div>
                        </div>
                    </div>
                </a>

                <a href="add_computer.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                    <div class="flex items-center">
                        <div class="p-2 bg-green-100 rounded-md mr-3">
                            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="font-medium text-gray-900">Add Computer</div>
                            <div class="text-sm text-gray-600">Deploy workstations</div>
                        </div>
                    </div>
                </a>

                <a href="view_maintenance.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                    <div class="flex items-center">
                        <div class="p-2 bg-amber-100 rounded-md mr-3">
                            <svg class="w-5 h-5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="font-medium text-gray-900">Maintenance</div>
                            <div class="text-sm text-gray-600">Monitor system</div>
                        </div>
                    </div>
                </a>

                <a href="reports.jsp" class="bg-white rounded-lg shadow-sm p-4 border border-gray-200 hover:shadow-md transition-shadow">
                    <div class="flex items-center">
                        <div class="p-2 bg-purple-100 rounded-md mr-3">
                            <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="font-medium text-gray-900">Reports</div>
                            <div class="text-sm text-gray-600">Generate insights</div>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>



