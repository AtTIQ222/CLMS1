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

    // Get student's lab computers
    String labId = "";
    if (conn != null) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT lab_id FROM students WHERE student_id = ?");
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                labId = rs.getString("lab_id");
            }
            rs.close(); pstmt.close();
        } catch (Exception e) {
            // Handle error
        }
    }

    // Handle form submission
    String message = "";
    String messageType = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String computerId = request.getParameter("computer_id");
        String issueType = request.getParameter("issue_type");
        String priority = request.getParameter("priority");
        String description = request.getParameter("description");

        if (conn != null && computerId != null && !computerId.isEmpty()) {
            try {
                PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO maintenance (computer_id, request_by, student_id, issue_type, priority, issue_description, status, request_date) " +
                    "VALUES (?, NULL, ?, ?, ?, ?, 'pending', CURDATE())"
                );
                pstmt.setInt(1, Integer.parseInt(computerId));
                pstmt.setInt(2, studentId);
                pstmt.setString(3, issueType);
                pstmt.setString(4, priority);
                pstmt.setString(5, description);
                pstmt.executeUpdate();
                pstmt.close();

                message = "Maintenance request submitted successfully!";
                messageType = "success";
            } catch (Exception e) {
                message = "Error submitting request: " + e.getMessage();
                messageType = "error";
            }
        } else {
            message = "Please select a computer.";
            messageType = "error";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Issue - CLMS</title>
    <link rel="stylesheet" href="modern-theme.css">
</head>
<body class="bg-gray-50">
    <div class="layout-container">
        <%@ include file="header.jsp" %>
        <%@ include file="navigation.jsp" %>

        <div class="main-area">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                        <svg class="w-8 h-8 text-red-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        Report Maintenance Issue
                    </h1>
                    <p class="mt-2 text-gray-600">Submit a maintenance request for lab equipment</p>
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

                <!-- Maintenance Request Form -->
                <div class="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
                    <form method="post" action="student_maintenance_request.jsp" class="space-y-6">
                        <!-- Computer Selection -->
                        <div>
                            <label for="computer_id" class="block text-sm font-medium text-gray-700 mb-2">Select Computer</label>
                            <select id="computer_id" name="computer_id" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all duration-300">
                                <option value="">Choose a computer...</option>
                                <%
                                if (conn != null && !labId.isEmpty()) {
                                    try {
                                        PreparedStatement pstmt = conn.prepareStatement("SELECT computer_id, computer_number, lab_name FROM computer WHERE lab_name LIKE ? ORDER BY computer_number");
                                        pstmt.setString(1, "%" + labId + "%");
                                        ResultSet rs = pstmt.executeQuery();
                                        while (rs.next()) {
                                %>
                                <option value="<%= rs.getInt("computer_id") %>"><%= rs.getString("lab_name") %> - Computer <%= rs.getString("computer_number") %></option>
                                <%
                                        }
                                        rs.close(); pstmt.close();
                                    } catch (Exception e) {
                                        out.println("<option disabled>Error loading computers</option>");
                                    }
                                }
                                %>
                            </select>
                        </div>

                        <!-- Issue Type -->
                        <div>
                            <label for="issue_type" class="block text-sm font-medium text-gray-700 mb-2">Issue Type</label>
                            <select id="issue_type" name="issue_type" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all duration-300">
                                <option value="">Select issue type...</option>
                                <option value="Hardware">Hardware Problem</option>
                                <option value="Software">Software Issue</option>
                                <option value="Network">Network Problem</option>
                                <option value="Electrical">Electrical Issue</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <!-- Priority -->
                        <div>
                            <label for="priority" class="block text-sm font-medium text-gray-700 mb-2">Priority Level</label>
                            <select id="priority" name="priority" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all duration-300">
                                <option value="Low">Low - Minor inconvenience</option>
                                <option value="Medium" selected>Medium - Affects functionality</option>
                                <option value="High">High - Prevents work</option>
                                <option value="Critical">Critical - System down</option>
                            </select>
                        </div>

                        <!-- Description -->
                        <div>
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                            <textarea id="description" name="description" rows="4" required
                                placeholder="Please describe the issue in detail..."
                                class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all duration-300 resize-none"></textarea>
                        </div>

                        <!-- Submit Button -->
                        <div class="flex justify-end">
                            <button type="submit" class="px-8 py-3 bg-gradient-to-r from-red-500 to-pink-500 text-white font-semibold rounded-xl hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1">
                                <svg class="w-5 h-5 mr-2 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path>
                                </svg>
                                Submit Request
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Guidelines -->
                <div class="bg-blue-50 rounded-2xl p-6 mt-8 border border-blue-200">
                    <h3 class="text-lg font-semibold text-blue-900 mb-4 flex items-center">
                        <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        Reporting Guidelines
                    </h3>
                    <ul class="text-blue-800 space-y-2 text-sm">
                        <li>• Provide clear, detailed description of the problem</li>
                        <li>• Specify what you were doing when the issue occurred</li>
                        <li>• Include error messages if any</li>
                        <li>• Select appropriate priority level</li>
                        <li>• Only report issues with lab computers assigned to your lab</li>
                    </ul>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>