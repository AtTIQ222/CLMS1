<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modern Header -->
<div class="header-area">
    <div class="flex items-center justify-between h-16 px-4 bg-white border-b border-gray-200">
        <!-- Left Section: Sidebar Toggle + Logo -->
        <div class="flex items-center space-x-4">
            <!-- Sidebar Toggle Button (Desktop) -->
            <button onclick="toggleSidebar()" class="hidden md:flex items-center justify-center w-10 h-10 rounded-lg hover:bg-gray-100 transition-colors duration-200" title="Toggle Sidebar">
                <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7"></path>
                </svg>
            </button>

            <!-- Mobile Menu Button -->
            <button onclick="toggleMobileSidebar()" class="md:hidden flex items-center justify-center w-10 h-10 rounded-lg hover:bg-gray-100 transition-colors duration-200" title="Open Menu">
                <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
            </button>

            <!-- Logo and Brand -->
            <div class="flex items-center space-x-3">
                <div class="flex-shrink-0">
                    <h1 class="text-xl font-bold text-gradient">CLMS</h1>
                </div>
                <div class="hidden sm:block">
                    <span class="text-sm text-gray-500">Computer Lab Management System</span>
                </div>
            </div>
        </div>

        <!-- Right Section: User Info + Actions -->
        <div class="flex items-center space-x-4">
            <!-- User Info -->
            <div class="hidden md:flex items-center space-x-3">
                <div class="flex items-center space-x-2 text-gray-700">
                    <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    <span class="text-sm font-medium">
                        Welcome, <%= session.getAttribute("name") != null ? session.getAttribute("name") : "User" %>
                    </span>
                </div>

                <!-- User Role Badge -->
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                    <%= session.getAttribute("user_type") != null ? session.getAttribute("user_type").toString().toUpperCase() : "GUEST" %>
                </span>
            </div>

            <!-- Logout Button -->
            <a href="logout.jsp" class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-all duration-200 shadow-sm hover:shadow-md">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                </svg>
                <span class="hidden sm:inline">Logout</span>
            </a>
        </div>
    </div>
</div>

<!-- Include Modern Theme -->
<link rel="stylesheet" href="modern-theme.css">



