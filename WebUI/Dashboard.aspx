<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebUI.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Header Section */
        .dashboard-header {
            margin-bottom: 1.75rem;
        }

        .dashboard-title {
            color: #ffffff;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: -0.02em;
        }

        .dashboard-subtitle {
            color: #94a3b8;
            font-size: 0.95rem;
        }

        .btn-refresh {
            background-color: transparent;
            border: 1px solid #334155;
            color: #e2e8f0;
            padding: 0.55rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }

        .btn-refresh:hover {
            border-color: #22c55e;
            color: #22c55e;
            background: rgba(34, 197, 94, 0.05);
        }

        /* Access Restricted Banner */
        .alert-access-denied {
            background-color: rgba(239, 68, 68, 0.12);
            border: 1px solid #ef4444;
            color: #f87171;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            font-size: 0.95rem;
        }

        /* 1. Quick Actions Section */
        .quick-actions-card {
            background-color: #0b0e1b;
            border: 1px solid #1e293b;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
        }

        .quick-actions-title {
            color: #ffffff;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1.25rem;
        }

        .action-btn-card {
            background-color: #13192e;
            border: 1px solid #1e293b;
            border-radius: 12px;
            padding: 1.25rem 1rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.25s ease;
            height: 100%;
        }

        .action-btn-card:hover {
            border-color: #22c55e;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.15);
        }

        .action-icon {
            font-size: 1.75rem;
            margin-bottom: 0.75rem;
        }

        .action-text {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .icon-drivers { color: #3b82f6; }
        .icon-customers { color: #06b6d4; }
        .icon-deliveries { color: #f59e0b; }
        .icon-reports { color: #22c55e; }

        /* 2. Glassmorphism Big Arc Diagram Section */
        .diagram-wrapper-full {
            background-color: #0b0e1b;
            border: 1px solid #1e293b;
            border-radius: 24px;
            padding: 3rem 2rem 2.5rem 2rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
            width: 100%;
        }

        .gauge-container {
            position: relative;
            width: 540px;
            height: 270px;
            margin: 0 auto 0.5rem auto;
            display: flex;
            justify-content: center;
        }

        .gauge-outer-ring {
            position: absolute;
            top: -12px;
            left: -12px;
            width: 564px;
            height: 282px;
            border-top-left-radius: 282px;
            border-top-right-radius: 282px;
            border: 1px dashed rgba(255, 255, 255, 0.2);
            border-bottom: none;
            pointer-events: none;
        }

        .gauge-arc-glass {
            width: 540px;
            height: 270px;
            border-top-left-radius: 270px;
            border-top-right-radius: 270px;
            background: rgba(255, 255, 255, 0.07);
            border: 1.5px solid rgba(255, 255, 255, 0.25);
            border-bottom: none;
            position: relative;
            padding: 2px;
            box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.15), 0 8px 32px rgba(0, 0, 0, 0.37);
            backdrop-filter: blur(8px);
        }

        .gauge-inner-bg {
            width: 100%;
            height: 100%;
            background-color: #080a14;
            border-top-left-radius: 268px;
            border-top-right-radius: 268px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            padding-bottom: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .gauge-center-text {
            color: #94a3b8;
            font-size: 0.85rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.25rem;
        }

        .gauge-center-value {
            color: #ffffff;
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1;
            text-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
        }

        /* Connecting Diagram Nodes */
        .node-point {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            position: absolute;
            border: 2px solid #080a14;
            z-index: 5;
        }

        .node-top {
            top: -19px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #22c55e;
            box-shadow: 0 0 10px #22c55e;
        }

        .node-left {
            bottom: -7px;
            left: -7px;
            background-color: #3b82f6;
            box-shadow: 0 0 10px #3b82f6;
        }

        .node-right {
            bottom: -7px;
            right: -7px;
            background-color: #ef4444;
            box-shadow: 0 0 10px #ef4444;
        }

        .diagram-tree-lines {
            width: 100%;
            height: 40px;
            position: relative;
            margin-bottom: 1rem;
        }

        .diagram-tree-lines svg {
            width: 100%;
            height: 100%;
        }

        /* Metrics Cards */
        .metric-card {
            background-color: #13192e;
            border: 1px solid #1e293b;
            border-radius: 14px;
            padding: 1.25rem 1.25rem;
            position: relative;
            transition: all 0.25s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .metric-card:hover {
            transform: translateY(-3px);
        }

        .metric-card.total { border-top: 3px solid #3b82f6; }
        .metric-card.pending { border-top: 3px solid #f59e0b; }
        .metric-card.ofd { border-top: 3px solid #06b6d4; }
        .metric-card.delivered { border-top: 3px solid #22c55e; }
        .metric-card.failed { border-top: 3px solid #ef4444; }

        .metric-node-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin: 0 auto 12px auto;
            border: 2px solid #0b0e1b;
        }

        .dot-total { background-color: #3b82f6; box-shadow: 0 0 8px #3b82f6; }
        .dot-pending { background-color: #f59e0b; box-shadow: 0 0 8px #f59e0b; }
        .dot-ofd { background-color: #06b6d4; box-shadow: 0 0 8px #06b6d4; }
        .dot-delivered { background-color: #22c55e; box-shadow: 0 0 8px #22c55e; }
        .dot-failed { background-color: #ef4444; box-shadow: 0 0 8px #ef4444; }

        .metric-label {
            color: #94a3b8;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .metric-value {
            color: #ffffff;
            font-size: 2rem;
            font-weight: 800;
            margin: 0;
            line-height: 1;
        }

        .icon-box {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .icon-total { background: rgba(59, 130, 246, 0.15); color: #3b82f6; }
        .icon-pending { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .icon-ofd { background: rgba(6, 182, 212, 0.15); color: #06b6d4; }
        .icon-delivered { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
        .icon-failed { background: rgba(239, 68, 68, 0.15); color: #ef4444; }

        /* Dark Table Card */
        .table-card {
            background-color: #0b0e1b;
            border: 1px solid #1e293b;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
        }

        .table-card-header {
            padding: 1.25rem 1.75rem;
            border-bottom: 1px solid #1e293b;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-card-title {
            color: #ffffff;
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0;
        }

        .custom-table {
            width: 100%;
            color: #e2e8f0;
            margin-bottom: 0;
            border-color: #1e293b;
        }

        .custom-table th {
            background-color: #13192e;
            color: #94a3b8;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #1e293b;
        }

        .custom-table td {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #1e293b;
            color: #94a3b8;
            font-size: 0.9rem;
            vertical-align: middle;
            background-color: #0b0e1b;
        }

        /* Status Badge Styling */
        .badge-status {
            padding: 0.35em 0.8em;
            border-radius: 50rem;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        .badge-status-pending { background-color: rgba(245, 158, 11, 0.15); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3); }
        .badge-status-ofd { background-color: rgba(6, 182, 212, 0.15); color: #06b6d4; border: 1px solid rgba(6, 182, 212, 0.3); }
        .badge-status-delivered { background-color: rgba(34, 197, 94, 0.15); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.3); }
        .badge-status-failed { background-color: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Clean Professional Error Message Notification Panel -->
    <asp:Panel ID="pnlAccessDenied" runat="server" Visible="false" CssClass="alert-access-denied mb-4">
        <div class="d-flex align-items-center">
            <i class="fa-solid fa-shield-halved me-3 fs-4 text-danger"></i>
            <div>
                <strong class="d-block text-white mb-1">Access Restricted</strong>
                <asp:Label ID="lblAccessDeniedMsg" runat="server"></asp:Label>
            </div>
        </div>
    </asp:Panel>

    <!-- Dashboard Header -->
    <div class="dashboard-header d-flex align-items-center justify-content-between">
        <div>
            <h2 class="dashboard-title"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Executive Dashboard</h2>
            <p class="dashboard-subtitle mb-0">Real-time overview of active delivery operations, dispatch statuses, and performance metrics.</p>
        </div>
        <div>
            <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn-refresh text-decoration-none" OnClick="btnRefresh_Click">
                <i class="fa-solid fa-rotate-right me-2"></i>Refresh Data
            </asp:LinkButton>
        </div>
    </div>

    <!-- 1. Quick Actions Section -->
    <div class="quick-actions-card">
        <h5 class="quick-actions-title">Quick Actions</h5>
        <div class="row g-3">
            <div class="col-lg-3 col-md-6 col-6" id="divDrivers" runat="server">
                <a href="DriverManagement.aspx" class="action-btn-card">
                    <div class="action-icon icon-drivers"><i class="fa-solid fa-address-card"></i></div>
                    <span class="action-text">Manage Drivers</span>
                </a>
            </div>
           <div class="col-lg-3 col-md-6 col-6" id="divCustomers" runat="server">
            <a href="CustomerManagement.aspx" class="action-btn-card">
                <div class="action-icon icon-customers"><i class="fa-solid fa-users"></i></div>
                <span class="action-text">Manage Customers</span>
            </a>
        </div>
            <div class="col-lg-3 col-md-6 col-6" id="divDeliveries" runat="server">
                <a href="DeliveryManagement.aspx" class="action-btn-card">
                    <div class="action-icon icon-deliveries"><i class="fa-solid fa-box-archive"></i></div>
                    <span class="action-text">Manage Deliveries</span>
                </a>
            </div>
            <div class="col-lg-3 col-md-6 col-6" id="divReports" runat="server">
                <a href="SearchReports.aspx" class="action-btn-card">
                    <div class="action-icon icon-reports"><i class="fa-solid fa-magnifying-glass"></i></div>
                    <span class="action-text">Search & Reports</span>
                </a>
            </div>
        </div>
    </div>


    <div class="diagram-wrapper-full">
        <div class="gauge-container">
            <div class="gauge-outer-ring"></div>
            <div class="gauge-arc-glass">
                <div class="node-point node-top"></div>
                <div class="node-point node-left"></div>
                <div class="node-point node-right"></div>

                <div class="gauge-inner-bg">
                    <span class="gauge-center-text">Total Dispatches</span>
                    <span class="gauge-center-value">
                        <asp:Label ID="lblGaugeTotal" runat="server" Text="0"></asp:Label>
                    </span>
                </div>
            </div>
        </div>

        <!-- Connecting Lines to Metrics -->
        <div class="diagram-tree-lines d-none d-md-block">
            <svg preserveAspectRatio="none" viewBox="0 0 1000 40">
                <path d="M 500 0 L 500 20 M 100 20 L 900 20 M 100 20 L 100 40 M 300 20 L 300 40 M 500 20 L 500 40 M 700 20 L 700 40 M 900 20 L 900 40" 
                      stroke="rgba(255, 255, 255, 0.18)" 
                      stroke-width="1.5" 
                      stroke-dasharray="4,4" 
                      fill="none" />
            </svg>
        </div>

        <!-- 5 Metric Cards -->
        <div class="row g-3">
            <div class="col-lg col-md-4 col-6">
                <div class="metric-node-dot dot-total d-none d-md-block"></div>
                <div class="metric-card total">
                    <div class="metric-label">
                        <span>Total Deliveries</span>
                        <div class="icon-box icon-total"><i class="fa-solid fa-boxes-stacked"></i></div>
                    </div>
                    <h3 class="metric-value">
                        <asp:Label ID="lblTotalDeliveries" runat="server" Text="0"></asp:Label>
                    </h3>
                </div>
            </div>

            <div class="col-lg col-md-4 col-6">
                <div class="metric-node-dot dot-pending d-none d-md-block"></div>
                <div class="metric-card pending">
                    <div class="metric-label">
                        <span>Pending</span>
                        <div class="icon-box icon-pending"><i class="fa-solid fa-hourglass-half"></i></div>
                    </div>
                    <h3 class="metric-value">
                        <asp:Label ID="lblPending" runat="server" Text="0"></asp:Label>
                    </h3>
                </div>
            </div>

            <div class="col-lg col-md-4 col-6">
                <div class="metric-node-dot dot-ofd d-none d-md-block"></div>
                <div class="metric-card ofd">
                    <div class="metric-label">
                        <span>Out For Delivery</span>
                        <div class="icon-box icon-ofd"><i class="fa-solid fa-truck-fast"></i></div>
                    </div>
                    <h3 class="metric-value">
                        <asp:Label ID="lblOutForDelivery" runat="server" Text="0"></asp:Label>
                    </h3>
                </div>
            </div>

            <div class="col-lg col-md-6 col-6">
                <div class="metric-node-dot dot-delivered d-none d-md-block"></div>
                <div class="metric-card delivered">
                    <div class="metric-label">
                        <span>Delivered</span>
                        <div class="icon-box icon-delivered"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                    <h3 class="metric-value">
                        <asp:Label ID="lblDelivered" runat="server" Text="0"></asp:Label>
                    </h3>
                </div>
            </div>

            <div class="col-lg col-md-6 col-12">
                <div class="metric-node-dot dot-failed d-none d-md-block"></div>
                <div class="metric-card failed">
                    <div class="metric-label">
                        <span>Failed Deliveries</span>
                        <div class="icon-box icon-failed"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    </div>
                    <h3 class="metric-value">
                        <asp:Label ID="lblFailedDeliveries" runat="server" Text="0"></asp:Label>
                    </h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Delivery Orders Table -->
    <div class="table-card">
        <div class="table-card-header">
            <h5 class="table-card-title d-flex align-items-center">
                <i class="fa-solid fa-clock-rotate-left text-success me-2"></i>
                Recent Delivery Orders
            </h5>
            <a href="DeliveryManagement.aspx" class="text-success small fw-bold text-decoration-none">View All Deliveries &rarr;</a>
        </div>
        
        <div class="table-responsive">
            <asp:GridView ID="gvRecentDeliveries" runat="server" AutoGenerateColumns="False" 
                CssClass="table custom-table" GridLines="None" EmptyDataText="No matching records found">
                <Columns>
                    <asp:BoundField DataField="DeliveryNo" HeaderText="DELIVERY NO" />
                    <asp:BoundField DataField="CustomerName" HeaderText="CUSTOMER" />
                    <asp:BoundField DataField="DriverName" HeaderText="ASSIGNED DRIVER" />
                    <asp:BoundField DataField="DeliveryDate" HeaderText="DELIVERY DATE" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="Address" HeaderText="ADDRESS" />
                    <asp:TemplateField HeaderText="CURRENT STATUS">
                        <ItemTemplate>
                            <span class='<%# GetStatusBadgeClass(Eval("CurrentStatus")) %>'>
                                <%# Eval("CurrentStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>