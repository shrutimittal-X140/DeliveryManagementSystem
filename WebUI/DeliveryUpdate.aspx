<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryUpdate.aspx.cs" Inherits="WebUI.DeliveryUpdate" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Delivery Update - DeliveryERP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --bg-main: #0b0f19;
            --card-bg: #111827;
            --card-border: #1f293d;
            --accent-green: #22c55e;
            --accent-green-hover: #16a34a;
            --text-main: #f3f4f6;
            --text-muted: #9ca3af;
            --input-bg: #1f2937;
            --input-border: #374151;
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .erp-navbar {
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--card-border);
        }

        .brand-logo {
            font-weight: 800;
            font-size: 1.4rem;
            color: #ffffff;
            letter-spacing: -0.5px;
        }

        .brand-logo span {
            color: var(--accent-green);
        }

        .nav-link-custom {
            color: var(--text-muted);
            text-decoration: none;
            padding: 0.5rem 0.8rem;
            font-size: 0.95rem;
            transition: color 0.2s;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            color: #ffffff;
        }

        .erp-card {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 12px;
        }

        .erp-card-header {
            border-bottom: 1px solid var(--card-border);
            padding: 1.25rem;
            font-weight: 700;
            font-size: 1.1rem;
            color: #ffffff;
        }

        .form-label {
            color: var(--text-muted);
            font-size: 0.875rem;
            font-weight: 500;
        }

        .form-control, .form-select {
            background-color: var(--input-bg) !important;
            border: 1px solid var(--input-border) !important;
            color: var(--text-main) !important;
            border-radius: 8px;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--accent-green) !important;
            box-shadow: 0 0 0 0.25rem rgba(34, 197, 94, 0.25) !important;
        }

        .btn-emerald {
            background-color: var(--accent-green);
            color: #000000;
            font-weight: 600;
            border: none;
            border-radius: 8px;
            padding: 0.6rem 1.25rem;
            transition: all 0.2s;
        }

        .btn-emerald:hover {
            background-color: var(--accent-green-hover);
            color: #ffffff;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- Navigation Header -->
        <nav class="erp-navbar py-3 mb-5">
            <div class="container d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-4">
                    <div class="brand-logo">
                        <i class="fa-solid fa-truck-fast me-2 text-success"></i>Delivery<span>ERP</span>
                    </div>
                    <div class="d-none d-md-flex align-items-center gap-2">
                        <a href="DeliveryManagement.aspx" class="nav-link-custom">Deliveries</a>
                        <a href="DeliveryUpdate.aspx" class="nav-link-custom active fw-bold text-success">Update Status</a>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted small">
                        <i class="fa-regular fa-user-circle me-1"></i> <%= Session["Username"] %> 
                        <span class="badge bg-secondary ms-1"><%= Session["Role"] %></span>
                    </span>
                    <span class="text-white small">
    <i class="fa-regular fa-user-circle me-1"></i> <%= Session["Username"] %> 
   
</span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-danger btn-sm" OnClick="btnLogout_Click" />
                </div>
            </div>
        </nav>

        <div class="container pb-5">
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show col-md-8 mx-auto mb-4">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <div class="erp-card shadow-lg col-md-8 mx-auto">
                <div class="erp-card-header text-center py-3">
                    <i class="fa-solid fa-pen-to-square text-success me-2"></i>Update Operational Delivery Status
                </div>
                <div class="card-body p-4">
                    
                    <!-- Delivery Selection Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Select Delivery Order</label>
                        <asp:DropDownList ID="ddlDeliveries" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDeliveries_SelectedIndexChanged"></asp:DropDownList>
                    </div>

                    <!-- Status Workflow Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Out For Delivery">Out For Delivery</asp:ListItem>
                            <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                            <asp:ListItem Value="Failed">Failed</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Delivery Notes -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Update Delivery Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Enter delivery comments or progress notes..."></asp:TextBox>
                    </div>

                    <!-- Conditional Failure Reason Panel -->
                    <asp:Panel ID="pnlFailure" runat="server" Visible="false" CssClass="mb-3">
                        <label class="form-label text-danger fw-bold">Failure Reason (Required for Failed status)</label>
                        <asp:TextBox ID="txtFailureReason" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control border-danger" placeholder="e.g. Customer not available, Incorrect address..."></asp:TextBox>
                    </asp:Panel>

                    <!-- Status History Info -->
                <div class="mb-4 p-3" style="background-color: var(--input-bg); border-radius: 8px; border: 1px solid var(--input-border);">
                    <span class="fw-bold" style="color: var(--text-main); font-size: 0.9rem;">
                     <i class="fa-regular fa-clock me-1 text-success"></i>Delivered Date/Time:
                     </span>
                   <asp:Label ID="lblDeliveredAt" runat="server" Text="Not delivered yet" Font-Bold="true" CssClass="text-success ms-2"></asp:Label>
                </div>

                    <asp:Button ID="btnUpdateStatus" runat="server" Text="Record Status Change" CssClass="btn btn-emerald w-100" OnClick="btnUpdateStatus_Click" />
                </div>
            </div>
        </div>

    </form>
</body>
</html>