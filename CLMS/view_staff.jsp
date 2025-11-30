<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user_type") == null || !"admin".equals(session.getAttribute("user_type"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = (Connection) application.getAttribute("dbConnection");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Staff - CLMS</title>
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
                    <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                        <svg class="w-8 h-8 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                        </svg>
                        Staff Management
                    </h1>
                    <p class="mt-2 text-gray-600">Manage staff members and their information</p>
                </div>

                <!-- Message Alert -->
                <% String message = request.getParameter("message");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="bg-blue-50 border border-blue-200 rounded-2xl p-6 mb-8">
                        <div class="flex items-center">
                            <svg class="w-6 h-6 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <p class="text-blue-800 font-medium"><%= message %></p>
                        </div>
                    </div>
                <% } %>

                <!-- Table Controls Bar -->
                <div class="bg-white rounded-2xl shadow-lg p-6 mb-8 border border-gray-100">
                    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
                        <!-- Search and Filters -->
                        <div class="flex flex-col sm:flex-row gap-4 flex-1">
                            <div class="relative flex-1 max-w-md">
                                <svg class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                                </svg>
                                <input type="text" id="searchInput" placeholder="Search staff..." class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-4 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all duration-300">
                            </div>
                            <select id="statusFilter" class="px-4 py-3 border border-gray-200 rounded-xl focus:ring-4 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all duration-300">
                                <option value="">All Status</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                            <select id="designationFilter" class="px-4 py-3 border border-gray-200 rounded-xl focus:ring-4 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all duration-300">
                                <option value="">All Designations</option>
                                <option value="Lecturer">Lecturer</option>
                                <option value="Assistant Professor">Assistant Professor</option>
                                <option value="Professor">Professor</option>
                            </select>
                        </div>

                        <!-- Actions -->
                        <div class="flex gap-3">
                            <button id="exportBtn" class="inline-flex items-center px-4 py-3 border border-gray-200 text-gray-700 rounded-xl hover:bg-gray-50 transition-all duration-300">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                                </svg>
                                Export
                            </button>
                            <a href="add_staff.jsp" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                </svg>
                                Add Staff
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Staff Table -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gradient-to-r from-gray-50 to-gray-100">
                                <tr>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">ID</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Staff Member</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Contact</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Role</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Lab</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Status</th>
                                    <th class="px-6 py-5 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50">
                            <%
                                if (conn != null) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement("SELECT s.*, l.lab_name FROM staff s LEFT JOIN labs l ON s.lab_id = l.lab_id ORDER BY s.staff_id");
                                        ResultSet rs = pstmt.executeQuery();
                                        int rowCount = 0;
                                        while (rs.next()) {
                                            rowCount++;
                            %>
                            <tr class="<%= rowCount % 2 == 0 ? "bg-gray-50/50" : "bg-white" %> hover:bg-indigo-50/50 transition-all duration-300">
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 w-10 h-10">
                                            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
                                                <span class="text-white font-bold text-sm"><%= rs.getString("name").charAt(0) %></span>
                                            </div>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-semibold text-gray-900">#<%= rs.getInt("staff_id") %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 w-12 h-12">
                                            <div class="w-12 h-12 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                                                <span class="text-white font-bold"><%= rs.getString("name").charAt(0) %></span>
                                            </div>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-semibold text-gray-900"><%= rs.getString("name") %></div>
                                            <div class="text-sm text-gray-500">@<%= rs.getString("username") %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <div class="text-sm text-gray-900"><%= rs.getString("email") %></div>
                                    <div class="text-sm text-gray-500"><%= rs.getString("phone") != null ? rs.getString("phone") : "No phone" %></div>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <div class="text-sm font-medium text-gray-900"><%= rs.getString("designation") %></div>
                                    <div class="text-xs text-gray-500">Staff Member</div>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <div class="text-sm text-gray-900"><%= rs.getString("lab_name") != null ? rs.getString("lab_name") : "Unassigned" %></div>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap">
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium <%= "active".equals(rs.getString("status")) ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                        <span class="<%= "active".equals(rs.getString("status")) ? "bg-green-400" : "bg-red-400" %> w-2 h-2 rounded-full mr-2"></span>
                                        <%= rs.getString("status") %>
                                    </span>
                                </td>
                                <td class="px-6 py-6 whitespace-nowrap text-sm font-medium">
                                    <div class="flex space-x-2">
                                        <a href="edit_staff.jsp?id=<%= rs.getInt("staff_id") %>" class="inline-flex items-center px-3 py-2 border border-transparent text-xs font-medium rounded-lg text-indigo-700 bg-indigo-100 hover:bg-indigo-200 transition-all duration-200 transform hover:scale-105">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                            </svg>
                                            Edit
                                        </a>
                                        <a href="toggle_staff_status.jsp?id=<%= rs.getInt("staff_id") %>" class="inline-flex items-center px-3 py-2 border border-transparent text-xs font-medium rounded-lg text-purple-700 bg-purple-100 hover:bg-purple-200 transition-all duration-200 transform hover:scale-105">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path>
                                            </svg>
                                            Toggle
                                        </a>
                                        <a href="delete_staff.jsp?id=<%= rs.getInt("staff_id") %>" class="inline-flex items-center px-3 py-2 border border-transparent text-xs font-medium rounded-lg text-red-700 bg-red-100 hover:bg-red-200 transition-all duration-200 transform hover:scale-105" onclick="return confirm('Are you sure you want to delete this staff member?')">
                                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                                            </svg>
                                            Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                        }
                                        rs.close();
                                        pstmt.close();
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='7' class='px-6 py-8 text-center'><div class='bg-red-50 border border-red-200 rounded-xl p-6'><p class='text-red-800 font-medium'>Error loading staff data: " + e.getMessage() + "</p></div></td></tr>");
                                    }
                                } else {
                                    out.println("<tr><td colspan='7' class='px-6 py-8 text-center'><div class='bg-gray-50 border border-gray-200 rounded-xl p-6'><p class='text-gray-600'>Database connection not available</p></div></td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>

    <script>
        // Search and Filter Functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            const statusFilter = document.getElementById('statusFilter');
            const designationFilter = document.getElementById('designationFilter');
            const tableRows = document.querySelectorAll('tbody tr');

            function filterTable() {
                const searchTerm = searchInput.value.toLowerCase();
                const statusValue = statusFilter.value;
                const designationValue = designationFilter.value;

                tableRows.forEach(row => {
                    const name = row.cells[1].textContent.toLowerCase();
                    const email = row.cells[2].textContent.toLowerCase();
                    const designation = row.cells[3].textContent.toLowerCase();
                    const status = row.cells[5].textContent.toLowerCase();

                    const matchesSearch = name.includes(searchTerm) || email.includes(searchTerm);
                    const matchesStatus = !statusValue || status.includes(statusValue);
                    const matchesDesignation = !designationValue || designation.includes(designationValue.toLowerCase());

                    if (matchesSearch && matchesStatus && matchesDesignation) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            searchInput.addEventListener('input', filterTable);
            statusFilter.addEventListener('change', filterTable);
            designationFilter.addEventListener('change', filterTable);

            // Export functionality (placeholder)
            document.getElementById('exportBtn').addEventListener('click', function() {
                alert('Export functionality would be implemented here');
            });
        });
    </script>
</body>
</html>



