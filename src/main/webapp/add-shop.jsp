<%@ page import="uz.pdp.uzummarket.entities.User" %>
<%@ page import="uz.pdp.uzummarket.entities.Shop" %>
<%@ page import="java.util.List" %>
<%@ page import="uz.pdp.uzummarket.service.ShopService" %>
<%@ page import="uz.pdp.uzummarket.service.NotificationService" %>
<%@ page import="uz.pdp.uzummarket.repositories.NotificationRepository" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <title>Seller</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <!-- Favicons -->
    <link href="admin-assets/img/favicon.png" rel="icon">
    <link href="admin-assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="admin-assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="admin-assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="admin-assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="admin-assets/vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="admin-assets/vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="admin-assets/vendor/remixicon/remixicon.css" rel="stylesheet">
    <link href="admin-assets/vendor/simple-datatables/style.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="admin-assets/css/style.css" rel="stylesheet">

    <style>
        .shop-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px;
            position: relative;
        }

        .shop-actions {
            margin-top: 15px;
            text-align: right;
        }

        .shop-actions .btn {
            margin-left: 10px;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        .container .form-control::placeholder {
            padding-top: 10mm; /* Adjust as needed */
        }

        .shop-list-wrapper {
            padding-left: 20px;
        }

        .shop-card {
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s;
        }

        .shop-card:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .shop-name {
            color: #333;
            font-weight: bold;
            font-size: 1.2em;
        }

        .shop-description {
            color: #666;
            margin-top: 5px;
            font-size: 1em;
        }

        .shop-address {
            color: #888;
            margin-top: 5px;
            font-size: 0.9em;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            transition: background-color 0.3s;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>


</head>

<body>

<!-- ======= Header ======= -->
<header id="header" class="header fixed-top d-flex align-items-center">
    <div class="d-flex align-items-center justify-content-between">
        <div class="logo d-flex align-items-center">
            <img src="/admin-assets/img/logo.png" alt="Logo" style="max-height: 40px;">
            <span class="d-none d-lg-block">SELLER</span>
        </div>
        <i class="bi bi-list toggle-sidebar-btn"></i>
    </div>

    <div class="search-bar">
        <form class="search-form d-flex align-items-center" method="POST" action="#">
            <input type="text" name="query" placeholder="Search" title="Enter search keyword">
            <button type="submit" title="Search"><i class="bi bi-search"></i></button>
        </form>
    </div><!-- End Search Bar -->

    <nav class="header-nav ms-auto">
        <ul class="d-flex align-items-center">

            <%
                // Assuming you have a method to get unread notifications count
                NotificationService notificationService = new NotificationService(NotificationRepository.getInstance());
                User user = (User) session.getAttribute("user");
                if (user == null || user.getId() == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                long unreadCount = notificationService.countUnreadNotificationsByUserId(user.getId());
                request.setAttribute("unreadCount", unreadCount);
            %>

            <!-- Notifications Dropdown -->
            <li class="nav-item dropdown">
                <a class="nav-link nav-icon" href="/show-notifications">
                    <i class="bi bi-bell"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="badge bg-primary badge-number">
                            <c:out value="${unreadCount}" />
                        </span>
                    </c:if>
                </a>
            </li>

            <!-- Messages Dropdown -->
            <li class="nav-item dropdown">
                <a class="nav-link nav-icon" href="/show-messages">
                    <i class="bi bi-chat-left-text"></i>
                    <c:if test="${messageCount > 0}">
                        <span class="badge bg-success badge-number">
                            <c:out value="${messageCount}" />
                        </span>
                    </c:if>
                </a>
            </li>

            <!-- User Profile Dropdown -->
            <li class="nav-item dropdown pe-3">
                <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle fs-4 me-2"></i>
                    <span class="d-none d-md-block dropdown-toggle ps-2">
                        <%
                            String sellerName = user.getFirstName() + " " + user.getLastName();
                        %>
                        <%= sellerName %>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                    <li class="dropdown-header">
                        <h6><%= sellerName %></h6>
                        <span>SELLER</span>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item d-flex align-items-center" href="/seller-profile.jsp"><i class="bi bi-person"></i><span>My Profile</span></a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item d-flex align-items-center" href="/users-profile.jsp"><i class="bi bi-gear"></i><span>Account Settings</span></a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item d-flex align-items-center" href="logout.jsp"><i class="bi bi-box-arrow-right"></i><span>Sign Out</span></a></li>
                </ul>
            </li>
        </ul>
    </nav><!-- End Icons Navigation -->

</header><!-- End Header -->

<!-- ======= Sidebar ======= -->
<aside id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

        <li class="nav-item">
            <a class="nav-link collapsed" href="seller.jsp">
                <i class="bi bi-grid"></i>
                <span>Dashboard</span>
            </a>
        </li><!-- End Dashboard Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="addProduct.jsp">
                <i class="bi bi-menu-button-wide"></i>
                <span>Add Product</span>
            </a>
        </li><!-- End Show Sellers Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="add-shop.jsp">
                <i class="bi bi-receipt"></i>
                <span>Manage Shops</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link collapsed" href="seller-profile.jsp">
                <i class="bi bi-person"></i>
                <span>Profile</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link collapsed" href="logout.jsp">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </li>

    </ul>

</aside><!-- End Sidebar -->

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Add Shop</h1>
    </div><!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <div class="col-lg-12">
                <div class="shop-form-wrapper">
                    <form action="/app/seller/add-shop" method="post">
                        <div class="mb-3">
                            <input type="text" name="name" class="form-control" placeholder="Shop Name" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" name="description" class="form-control" placeholder="Shop Description" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" name="address" class="form-control" placeholder="Shop Address" required>
                        </div>
                        <button class="btn btn-primary" type="submit">Add Shop</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main><!-- End #main -->

<%
    if (user != null) {
        ShopService shopService = new ShopService();
        List<Shop> sellerShops = shopService.getShopsBySeller(user);
        request.setAttribute("sellerShops", sellerShops);
        System.out.println("Number of shops: " + (sellerShops != null ? sellerShops.size() : "0"));
%>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Your Shops</h1>
    </div><!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <div class="col-lg-12">
                <div class="shop-list-wrapper">
                    <c:choose>
                        <c:when test="${not empty sellerShops}">
                            <c:forEach var="shop" items="${sellerShops}">
                                <div class="shop-card p-3 mb-3">
                                    <div class="shop-name">${shop.name}</div>
                                    <div class="shop-description">Description: ${shop.description}</div>
                                    <div class="shop-address">Address: ${shop.address}</div>
                                    <div class="shop-actions mt-2">
                                        <a href="/editShop?id=${shop.id}" class="btn btn-primary">Edit</a>
                                        <a href="/deleteShop?id=${shop.id}" class="btn btn-danger">Delete</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p>No shops found.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>
</main><!-- End #main -->

<% } %>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
<!-- Your Custom JS -->
<script src="css_files/js/enter.js"></script>


<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

<!-- Vendor JS Files -->
<script src="/admin-assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="admin-assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="admin-assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="admin-assets/vendor/chart.js/chart.umd.js"></script>
<script src="admin-assets/vendor/echarts/echarts.min.js"></script>
<script src="admin-assets/vendor/quill/quill.js"></script>
<script src="admin-assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="admin-assets/vendor/tinymce/tinymce.min.js"></script>
<script src="admin-assets/vendor/php-email-form/validate.js"></script>

<!-- Template Main JS File -->
<script src="admin-assets/js/main.js"></script>

</body>

</html>