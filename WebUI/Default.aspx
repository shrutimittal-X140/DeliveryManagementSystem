<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebUI.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
       .hero-section {
            background-color: #0b0e1b;
            color: #ffffff;
            border-radius: 20px;
            padding: 4.5rem 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            border: 1px solid #1e293b;
        }

        .hero-title {
            font-size: 3.25rem;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.03em;
            color: #ffffff;
        }

        .hero-title span {
            color: #22c55e;
        }

        .hero-subtitle {
            font-size: 1.1rem;
            color: #94a3b8;
            max-width: 580px;
            margin-top: 1.25rem;
            margin-bottom: 2.25rem;
            line-height: 1.6;
        }

        .btn-neon {
            background-color: #22c55e;
            color: #0b0e1b;
            font-weight: 700;
            padding: 0.85rem 2.25rem;
            border-radius: 8px;
            border: none;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-neon:hover {
            background-color: #16a34a;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.3);
        }

        .btn-outline-custom {
            border: 1px solid #334155;
            color: #ffffff;
            font-weight: 600;
            padding: 0.85rem 2rem;
            border-radius: 8px;
            background: transparent;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-outline-custom:hover {
            border-color: #22c55e;
            color: #22c55e;
            transform: translateY(-2px);
        }

        .feature-card {
            background-color: #13192e;
            border: 1px solid #1e293b;
            border-top: 3px solid #22c55e;
            border-radius: 14px;
            padding: 1.75rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            border-color: #22c55e;
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(34, 197, 94, 0.12);
        }

        .feature-icon-badge {
            width: 46px;
            height: 46px;
            border-radius: 10px;
            background: rgba(34, 197, 94, 0.1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            color: #22c55e;
        }

        .module-badge {
            background: rgba(34, 197, 94, 0.1);
            color: #22c55e;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 0.3rem 0.65rem;
            border-radius: 5px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .feature-card-title {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.15rem;
            margin: 1rem 0 0.6rem 0;
        }

        .feature-card-desc {
            color: #94a3b8;
            font-size: 0.875rem;
            line-height: 1.55;
            flex-grow: 1;
            margin-bottom: 1.25rem;
        }

        .feature-card-link {
            color: #22c55e;
            font-size: 0.875rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: gap 0.2s ease;
        }

        .feature-card-link:hover {
            color: #4ade80;
            gap: 0.65rem;
        }

        .hero-graphic-badge {
            width: 310px; 
            height: 310px; 
            border: 3px solid rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.05) 0%, rgba(11, 14, 27, 0) 75%);
            box-shadow: 0 0 30px rgba(255, 255, 255, 0.05);
        }


        .analytics-wrapper {
            padding-top: 2.5rem;
            padding-bottom: 3.5rem;
        }

        .analytics-card {
            background-color: #13192e;
            border: 1px solid #1e293b;
            border-radius: 16px;
            padding: 1.75rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
        }

        .chart-box {
            position: relative;
            height: 260px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hero Section -->
    <div class="hero-section mb-4">
        <div class="row align-items-center position-relative" style="z-index: 2;">
            <div class="col-lg-7 ps-lg-5 ps-3">
                <h1 class="hero-title">
                    Smart Delivery<br />
                    <span>Management System</span>
                </h1>
                <p class="hero-subtitle">
                    Streamline end-to-end delivery workflows with a high-performance, 3-tier ERP tracking solution powered by ASP.NET and SQL Server, featuring granular role-based security control.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <asp:HyperLink id ="lnkLogin" runat ="server" NavigateUrl="Login.aspx" Cssclass="btn-neon">
                        Login / Sign In <i class="fa-solid fa-arrow-right ms-2"></i>
                    </asp:HyperLink>
                    <a href="Dashboard.aspx" class="btn-outline-custom">
                        View Dashboard Metrics &rarr;
                    </a>
                </div>
            </div>

           <div class="col-lg-5 text-center position-relative d-none d-lg-block">
                 <div class="hero-graphic-badge" style="padding-left: 20px;">
                 <i class="fa-solid fa-truck-fast" style="font-size: 10.5rem; color: #ffffff;"></i>
           </div>
</div>
        </div>
    </div>

    <!-- Live System Analytics Graphs Container with Custom Padding -->
    <div class="analytics-wrapper">
        <div class="d-flex align-items-center justify-content-between mb-4 ps-lg-1">
            <div>
                <h4 class="fw-bold text-white mb-1">
                    <i class="fa-solid fa-chart-line text-success me-2"></i>System Analytics & Overview
                </h4>
                <p class="text-secondary small mb-0">Live record metrics synchronized with core database tables.</p>
            </div>
            <span class="badge" style="background: rgba(34, 197, 94, 0.1); color: #22c55e; border: 1px solid #22c55e; padding: 0.55rem 0.9rem; font-size: 0.75rem;">
                <i class="fa-solid fa-rotate me-1"></i> Live Data Sync
            </span>
        </div>

        <div class="row g-4 align-items-stretch">
            <!-- Delivery Status Distribution -->
            <div class="col-lg-5">
                <div class="analytics-card">
                    <div class="mb-3">
                        <h5 class="fw-bold text-white mb-1">Delivery Status Breakdown</h5>
                        <p class="text-secondary small mb-0">Real-time breakdown of overall dispatch orders</p>
                    </div>
                    <div class="chart-box">
                        <canvas id="chartDeliveryStatus"></canvas>
                    </div>
                </div>
            </div>

            <!-- Operations Module Record Totals -->
            <div class="col-lg-7">
                <div class="analytics-card">
                    <div class="mb-3">
                        <h5 class="fw-bold text-white mb-1">Operations Module Summary</h5>
                        <p class="text-secondary small mb-0">Active database record counts across system modules</p>
                    </div>
                    <div class="chart-box">
                        <canvas id="chartModuleTotals"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <asp:HiddenField ID="hfPending" runat="server" Value="0" />
    <asp:HiddenField ID="hfOFD" runat="server" Value="0" />
    <asp:HiddenField ID="hfDelivered" runat="server" Value="0" />
    <asp:HiddenField ID="hfFailed" runat="server" Value="0" />
    <asp:HiddenField ID="hfTotalDrivers" runat="server" Value="0" />
    <asp:HiddenField ID="hfTotalCustomers" runat="server" Value="0" />

  
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {

            var pending = parseInt(document.getElementById('<%= hfPending.ClientID %>').value) || 0;
            var ofd = parseInt(document.getElementById('<%= hfOFD.ClientID %>').value) || 0;
            var delivered = parseInt(document.getElementById('<%= hfDelivered.ClientID %>').value) || 0;
            var failed = parseInt(document.getElementById('<%= hfFailed.ClientID %>').value) || 0;

            var totalDrivers = parseInt(document.getElementById('<%= hfTotalDrivers.ClientID %>').value) || 0;
            var totalCustomers = parseInt(document.getElementById('<%= hfTotalCustomers.ClientID %>').value) || 0;
            var totalDeliveries = pending + ofd + delivered + failed;


            var ctxStatus = document.getElementById('chartDeliveryStatus').getContext('2d');
            new Chart(ctxStatus, {
                type: 'doughnut',
                data: {
                    labels: ['Pending', 'Out for Delivery', 'Delivered', 'Failed'],
                    datasets: [{
                        data: [pending, ofd, delivered, failed],
                        backgroundColor: ['#f59e0b', '#06b6d4', '#22c55e', '#ef4444'],
                        borderWidth: 0,
                        hoverOffset: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    layout: {
                        padding: { top: 10, bottom: 10 }
                    },
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: '#94a3b8',
                                padding: 15,
                                font: { family: 'sans-serif', size: 12 }
                            }
                        }
                    },
                    cutout: '68%'
                }
            });

            var ctxModules = document.getElementById('chartModuleTotals').getContext('2d');
            new Chart(ctxModules, {
                type: 'bar',
                data: {
                    labels: ['Total Dispatches', 'Registered Drivers', 'Active Customers'],
                    datasets: [{
                        label: 'Total Records', 
                        data: [totalDeliveries, totalDrivers, totalCustomers],
                        backgroundColor: ['#0ea5e9', '#22c55e', '#ef4444'],
                        borderRadius: 8,
                        barThickness: 36
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    layout: {
                        padding: { top: 15 }
                    },
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        x: {
                            ticks: { color: '#94a3b8', font: { size: 12 } },
                            grid: { display: false }
                        },
                        y: {
                            ticks: { color: '#94a3b8', precision: 0 },
                            grid: { color: '#1e293b' },
                            beginAtZero: true
                        }
                    }
                }
            });
        });
    </script>

    <!-- System Modules Grid Header -->
    <div class="d-flex align-items-center justify-content-between mb-4 ps-lg-1">
        <div>
            <h4 class="fw-bold text-white mb-1"><i class="fa-solid fa-cubes text-success me-2"></i>System Modules</h4>
            <p class="text-secondary small mb-0">Core functional modules engineered for the delivery management lifecycle.</p>
        </div>
    </div>

    <!-- ERP System Modules Cards -->
    <div class="row g-4 mb-5">
        <div class="col-lg-4 col-md-6">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="module-badge">Module 2</span>
                    <div class="feature-icon-badge"><i class="fa-solid fa-chart-pie"></i></div>
                </div>
                <h5 class="feature-card-title">Dashboard Overview</h5>
                <p class="feature-card-desc">
                    Summary metrics for Total Deliveries, Pending, Out for Delivery, Delivered, and Failed Deliveries with Bootstrap Table recent delivery logs.
                </p>
                <a href="Dashboard.aspx" class="feature-card-link">Open Dashboard <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="module-badge">Module 3</span>
                    <div class="feature-icon-badge"><i class="fa-solid fa-id-card"></i></div>
                </div>
                <h5 class="feature-card-title">Driver Directory</h5>
                <p class="feature-card-desc">
                    Register drivers with Driver Code, Name, Phone, Email, Vehicle Number, and Active Status. Search, activate/deactivate, and manage drivers.
                </p>
                <a href="DriverManagement.aspx" class="feature-card-link">Manage Drivers <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="module-badge">Module 4</span>
                    <div class="feature-icon-badge"><i class="fa-solid fa-users"></i></div>
                </div>
                <h5 class="feature-card-title">Customer CRM</h5>
                <p class="feature-card-desc">
                    Maintain Customer Code, Contact Person, Phone, Email, and Delivery Address records using interactive Bootstrap Tables.
                </p>
                <a href="CustomerManagement.aspx" class="feature-card-link">Manage Customers <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="module-badge">Module 5 & 6</span>
                    <div class="feature-icon-badge"><i class="fa-solid fa-boxes-stacked"></i></div>
                </div>
                <h5 class="feature-card-title">Delivery Orders & Status Workflow</h5>
                <p class="feature-card-desc">
                    Auto-generate Delivery Numbers, assign active drivers, manage multi-item dispatches, and enforce workflow transitions (Pending &rarr; Out For Delivery &rarr; Delivered / Failed).
                </p>
                <a href="DeliveryManagement.aspx" class="feature-card-link">Manage Dispatches <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="module-badge">Module 7 & 8</span>
                    <div class="feature-icon-badge"><i class="fa-solid fa-clock-rotate-left"></i></div>
                </div>
                <h5 class="feature-card-title">Search, Reports & Audit Logs</h5>
                <p class="feature-card-desc">
                    Filter dispatches by Customer, Driver, Date Range, or Status. View complete audit history tracking status updates, timestamped user actions, and driver changes.
                </p>
                <a href="SearchReports.aspx" class="feature-card-link">View Reports & Logs <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>
    </div>
</asp:Content>