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

    // Handle status updates
    String message = "";
    String messageType = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        String maintenanceId = request.getParameter("maintenance_id");

        if (maintenanceId != null && !maintenanceId.isEmpty()) {
            try {
                if ("start_work".equals(action)) {
                    PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE maintenance SET status = 'in-progress', assigned_technician = ? WHERE maintenance_id = ? AND assigned_technician IS NULL"
                    );
                    pstmt.setInt(1, technicianId);
                    pstmt.setInt(2, Integer.parseInt(maintenanceId));
                    int updated = pstmt.executeUpdate();
                    if (updated > 0) {
                        message = "Task assigned and started successfully!";
                        messageType = "success";
                    } else {
                        message = "Task is already assigned to another technician.";
                        messageType = "error";
                    }
                    pstmt.close();
                } else if ("complete_work".equals(action)) {
                    String solutionNotes = request.getParameter("solution_notes");
                    PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE maintenance SET status = 'completed', solution_notes = ?, actual_completion = CURDATE() WHERE maintenance_id = ? AND assigned_technician = ?"
                    );
                    pstmt.setString(1, solutionNotes);
                    pstmt.setInt(2, Integer.parseInt(maintenanceId));
                    pstmt.setInt(3, technicianId);
                    pstmt.executeUpdate();
                    pstmt.close();

                    message = "Task completed successfully!";
                    messageType = "success";
                }
            } catch (Exception e) {
                message = "Error updating task: " + e.getMessage();
                messageType = "error";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Panel - CLMS</title>
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        Maintenance Panel
                    </h1>
                    <p class="mt-2 text-gray-600">Manage and resolve maintenance requests</p>
                </div>

                <!-- Message Alert -->
                <% if (!message.isEmpty()) { %>
                    <div class="bg-<%= messageType.equals("success") ? "green" : "red" %>-50 border border-<%= messageType.equals("success") ? "green" : "red" %>-200 rounded-2xl p-6 mb-8">
                        <div class="flex items-center">
                            <svg class="w-6 h-6 <%= messageType.equals("success") ? "text-green-600" : "text-red-600" %> mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<%= messageType.equals("success") ? "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" : "M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" %>"></path>
                            </svg>
                            <p class="<%= messageType.equals("success") ? "text-green-800" : "text-red-800" %> font-medium"><%= message %></p>
                        </div>
                    </div>
                <% } %>

                <!-- Tabs for different task views -->
                <div class="mb-6">
                    <div class="border-b border-gray-200">
                        <nav class="-mb-px flex space-x-8">
                            <button onclick="showTab('available')" class="tab-button active border-blue-500 text-blue-600 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm">
                                Available Tasks
                            </button>
                            <button onclick="showTab('my-tasks')" class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm">
                                My Tasks
                            </button>
                            <button onclick="showTab('completed')" class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm">
                                Completed
                            </button>
                        </nav>
                    </div>
                </div>

                <!-- Available Tasks Tab -->
                <div id="available-tab" class="tab-content">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                        <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Available Maintenance Tasks</h3>
                            <p class="text-sm text-gray-600">Tasks waiting for technician assignment</p>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Issue</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Computer</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Reported By</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Priority</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <%
                                    if (conn != null) {
                                        try {
                                            PreparedStatement pstmt = conn.prepareStatement(
                                                "SELECT m.*, c.computer_number, c.lab_name, COALESCE(s.name, st.name) AS reporter_name " +
                                                "FROM maintenance m " +
                                                "JOIN computer c ON m.computer_id = c.computer_id " +
                                                "LEFT JOIN staff s ON m.request_by = s.staff_id " +
                                                "LEFT JOIN students st ON m.student_id = st.student_id " +
                                                "WHERE m.status = 'pending' AND m.assigned_technician IS NULL " +
                                                "ORDER BY " +
                                                "CASE m.priority " +
                                                "WHEN 'Critical' THEN 1 " +
                                                "WHEN 'High' THEN 2 " +
                                                "WHEN 'Medium' THEN 3 " +
                                                "WHEN 'Low' THEN 4 " +
                                                "END, m.request_date DESC"
                                            );
                                            ResultSet rs = pstmt.executeQuery();
                                            boolean hasTasks = false;
                                            while (rs.next()) {
                                                hasTasks = true;
                                                String priorityClass = "";
                                                if ("Critical".equals(rs.getString("priority"))) priorityClass = "bg-red-100 text-red-800";
                                                else if ("High".equals(rs.getString("priority"))) priorityClass = "bg-orange-100 text-orange-800";
                                                else if ("Medium".equals(rs.getString("priority"))) priorityClass = "bg-yellow-100 text-yellow-800";
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
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <%= rs.getString("reporter_name") != null ? rs.getString("reporter_name") : "Unknown" %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= priorityClass %>">
                                                <%= rs.getString("priority") %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= rs.getDate("request_date") %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <form method="post" action="technician_maintenance_panel.jsp" class="inline">
                                                <input type="hidden" name="action" value="start_work">
                                                <input type="hidden" name="maintenance_id" value="<%= rs.getInt("maintenance_id") %>">
                                                <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                                    Start Work
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                            rs.close(); pstmt.close();
                                            if (!hasTasks) {
                                    %>
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center">
                                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                            </svg>
                                            <h3 class="mt-2 text-sm font-medium text-gray-900">No available tasks</h3>
                                            <p class="mt-1 text-sm text-gray-500">All maintenance requests are currently assigned.</p>
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
                </div>

                <!-- My Tasks Tab -->
                <div id="my-tasks-tab" class="tab-content hidden">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                        <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">My Active Tasks</h3>
                            <p class="text-sm text-gray-600">Tasks currently assigned to you</p>
                        </div>
                        <div class="p-6 space-y-4">
                            <%
                            if (conn != null) {
                                try {
                                    PreparedStatement pstmt = conn.prepareStatement(
                                        "SELECT m.*, c.computer_number, c.lab_name, COALESCE(s.name, st.name) AS reporter_name " +
                                        "FROM maintenance m " +
                                        "JOIN computer c ON m.computer_id = c.computer_id " +
                                        "LEFT JOIN staff s ON m.request_by = s.staff_id " +
                                        "LEFT JOIN students st ON m.student_id = st.student_id " +
                                        "WHERE m.assigned_technician = ? AND m.status = 'in-progress' " +
                                        "ORDER BY m.request_date DESC"
                                    );
                                    pstmt.setInt(1, technicianId);
                                    ResultSet rs = pstmt.executeQuery();
                                    boolean hasTasks = false;
                                    while (rs.next()) {
                                        hasTasks = true;
                            %>
                            <div class="border border-gray-200 rounded-xl p-6">
                                <div class="flex items-start justify-between">
                                    <div class="flex-1">
                                        <div class="flex items-center space-x-3 mb-2">
                                            <h4 class="text-lg font-semibold text-gray-900"><%= rs.getString("issue_type") %> Issue</h4>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                In Progress
                                            </span>
                                        </div>
                                        <p class="text-gray-600 mb-3"><%= rs.getString("issue_description") %></p>
                                        <div class="grid grid-cols-2 gap-4 text-sm text-gray-500">
                                            <div>Computer: <%= rs.getString("lab_name") %> - PC <%= rs.getString("computer_number") %></div>
                                            <div>Reported by: <%= rs.getString("reporter_name") != null ? rs.getString("reporter_name") : "Unknown" %></div>
                                            <div>Priority: <%= rs.getString("priority") %></div>
                                            <div>Requested: <%= rs.getDate("request_date") %></div>
                                        </div>
                                    </div>
                                    <div class="ml-6">
                                        <form method="post" action="technician_maintenance_panel.jsp" class="space-y-3">
                                            <input type="hidden" name="action" value="complete_work">
                                            <input type="hidden" name="maintenance_id" value="<%= rs.getInt("maintenance_id") %>">
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700 mb-1">Solution Notes</label>
                                                <textarea name="solution_notes" rows="3" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500" placeholder="Describe the solution..."></textarea>
                                            </div>
                                            <button type="submit" class="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700">
                                                Mark as Completed
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                    rs.close(); pstmt.close();
                                    if (!hasTasks) {
                            %>
                            <div class="text-center py-12">
                                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                </svg>
                                <h3 class="mt-2 text-sm font-medium text-gray-900">No active tasks</h3>
                                <p class="mt-1 text-sm text-gray-500">You don't have any tasks in progress.</p>
                            </div>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<div class='text-center py-4 text-red-500'>Error loading tasks: " + e.getMessage() + "</div>");
                                }
                            }
                            %>
                        </div>
                    </div>
                </div>

                <!-- Completed Tasks Tab -->
                <div id="completed-tab" class="tab-content hidden">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-gray-100">
                        <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Completed Tasks</h3>
                            <p class="text-sm text-gray-600">Tasks you've successfully resolved</p>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Issue</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Computer</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Completed</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Solution</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <%
                                    if (conn != null) {
                                        try {
                                            PreparedStatement pstmt = conn.prepareStatement(
                                                "SELECT m.*, c.computer_number, c.lab_name FROM maintenance m " +
                                                "JOIN computer c ON m.computer_id = c.computer_id " +
                                                "WHERE m.assigned_technician = ? AND m.status = 'completed' " +
                                                "ORDER BY m.actual_completion DESC LIMIT 10"
                                            );
                                            pstmt.setInt(1, technicianId);
                                            ResultSet rs = pstmt.executeQuery();
                                            boolean hasTasks = false;
                                            while (rs.next()) {
                                                hasTasks = true;
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
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= rs.getDate("actual_completion") %>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900">
                                            <%= rs.getString("solution_notes") != null ? rs.getString("solution_notes") : "No notes provided" %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                            rs.close(); pstmt.close();
                                            if (!hasTasks) {
                                    %>
                                    <tr>
                                        <td colspan="4" class="px-6 py-12 text-center">
                                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                            <h3 class="mt-2 text-sm font-medium text-gray-900">No completed tasks</h3>
                                            <p class="mt-1 text-sm text-gray-500">You haven't completed any maintenance tasks yet.</p>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='4' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                                        }
                                    }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>

    <script>
        function showTab(tabName) {
            // Hide all tabs
            document.getElementById('available-tab').classList.add('hidden');
            document.getElementById('my-tasks-tab').classList.add('hidden');
            document.getElementById('completed-tab').classList.add('hidden');

            // Remove active class from all buttons
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active', 'border-blue-500', 'text-blue-600'));
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.add('border-transparent', 'text-gray-500'));

            // Show selected tab
            document.getElementById(tabName + '-tab').classList.remove('hidden');

            // Activate button
            event.target.classList.remove('border-transparent', 'text-gray-500');
            event.target.classList.add('border-blue-500', 'text-blue-600', 'active');
        }
    </script>
</body>
</html>