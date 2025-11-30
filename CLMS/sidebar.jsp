<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userType = (String) session.getAttribute("user_type");
    String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>
<!-- Modern Collapsible Sidebar -->
<div class="sidebar-area">
    <div class="sidebar-content">
        <div class="sidebar">
            <!-- Sidebar Header -->
            <div class="sidebar-header">
                <div class="flex items-center">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"></path>
                    </svg>
                    <span class="sidebar-item-text ml-2 font-semibold text-gray-800">Navigation</span>
                </div>
                <button class="sidebar-toggle md:hidden" onclick="toggleMobileSidebar()">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <!-- Navigation Menu -->
            <nav class="sidebar-nav">
                <% if ("admin".equals(userType)) { %>
                    <!-- Admin Navigation -->
                    <div class="sidebar-item <%= "admin_dashboard.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('admin_dashboard.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                        <span class="sidebar-item-text">Dashboard</span>
                        <div class="sidebar-item-tooltip">Admin Dashboard</div>
                    </div>

                    <div class="sidebar-item <%= "view_staff.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('view_staff.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Staff Management</span>
                        <div class="sidebar-item-tooltip">Manage Staff</div>
                    </div>

                    <div class="sidebar-item <%= "view_computer.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('view_computer.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                        </svg>
                        <span class="sidebar-item-text">Computer Management</span>
                        <div class="sidebar-item-tooltip">Manage Computers</div>
                    </div>

                    <div class="sidebar-item <%= "view_accessory.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('view_accessory.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Accessories</span>
                        <div class="sidebar-item-tooltip">Manage Accessories</div>
                    </div>

                    <div class="sidebar-item <%= "view_maintenance.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('view_maintenance.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Maintenance</span>
                        <div class="sidebar-item-tooltip">View Maintenance</div>
                    </div>

                    <div class="sidebar-item <%= "view_usage.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('view_usage.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Lab Usage</span>
                        <div class="sidebar-item-tooltip">View Usage Reports</div>
                    </div>

                    <div class="sidebar-item <%= "reports.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('reports.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                        <span class="sidebar-item-text">Reports</span>
                        <div class="sidebar-item-tooltip">Generate Reports</div>
                    </div>

                <% } else if ("staff".equals(userType)) { %>
                    <!-- Staff Navigation -->
                    <div class="sidebar-item <%= "staff_dashboard.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('staff_dashboard.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                        <span class="sidebar-item-text">Dashboard</span>
                        <div class="sidebar-item-tooltip">Staff Dashboard</div>
                    </div>

                    <div class="sidebar-item <%= "staff_assigned_computer.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('staff_assigned_computer.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                        </svg>
                        <span class="sidebar-item-text">Assigned Computer</span>
                        <div class="sidebar-item-tooltip">View Assigned PC</div>
                    </div>

                    <div class="sidebar-item <%= "add_maintenance.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('add_maintenance.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        <span class="sidebar-item-text">Request Maintenance</span>
                        <div class="sidebar-item-tooltip">Report Issues</div>
                    </div>

                    <div class="sidebar-item <%= "staff_usage.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('staff_usage.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Lab Usage</span>
                        <div class="sidebar-item-tooltip">Log Usage</div>
                    </div>

                    <div class="sidebar-item <%= "maintenance_status.jsp".equals(currentPage) ? "active" : "" %>" onclick="navigateTo('maintenance_status.jsp')">
                        <svg class="sidebar-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <span class="sidebar-item-text">Maintenance Status</span>
                        <div class="sidebar-item-tooltip">Check Status</div>
                    </div>
                <% } %>
            </nav>
        </div>
    </div>
</div>

<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeMobileSidebar()"></div>

<script>
// Sidebar functionality
let sidebarCollapsed = false;

function toggleSidebar() {
    const layout = document.querySelector('.layout-container');
    sidebarCollapsed = !sidebarCollapsed;

    if (sidebarCollapsed) {
        layout.classList.remove('sidebar-expanded');
        layout.classList.add('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', 'true');
    } else {
        layout.classList.remove('sidebar-collapsed');
        layout.classList.add('sidebar-expanded');
        localStorage.setItem('sidebarCollapsed', 'false');
    }
}

function toggleMobileSidebar() {
    const layout = document.querySelector('.layout-container');
    const overlay = document.getElementById('sidebarOverlay');

    if (layout.classList.contains('sidebar-mobile-open')) {
        closeMobileSidebar();
    } else {
        openMobileSidebar();
    }
}

function openMobileSidebar() {
    const layout = document.querySelector('.layout-container');
    const overlay = document.getElementById('sidebarOverlay');

    layout.classList.add('sidebar-mobile-open');
    overlay.classList.add('active');
}

function closeMobileSidebar() {
    const layout = document.querySelector('.layout-container');
    const overlay = document.getElementById('sidebarOverlay');

    layout.classList.remove('sidebar-mobile-open');
    overlay.classList.remove('active');
}

function navigateTo(page) {
    window.location.href = page;
}

// Initialize sidebar state on page load
document.addEventListener('DOMContentLoaded', function() {
    const layout = document.querySelector('.layout-container');
    const savedState = localStorage.getItem('sidebarCollapsed');

    if (savedState === 'true') {
        layout.classList.add('sidebar-collapsed');
        sidebarCollapsed = true;
    } else {
        layout.classList.add('sidebar-expanded');
        sidebarCollapsed = false;
    }

    // Close mobile sidebar when clicking on a menu item
    document.querySelectorAll('.sidebar-item').forEach(item => {
        item.addEventListener('click', () => {
            if (window.innerWidth < 768) {
                closeMobileSidebar();
            }
        });
    });
});
</script>



