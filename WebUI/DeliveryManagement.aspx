<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryManagement.aspx.cs" Inherits="WebUI.DeliveryManagement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Delivery Management - DeliveryERP</title>
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

        /* Navbar Styling */
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

        /* Cards & Containers */
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

        /* Form Controls */
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
            padding: 0.5rem 1.25rem;
            transition: all 0.2s;
        }

        .btn-emerald:hover {
            background-color: var(--accent-green-hover);
            color: #ffffff;
        }

        .btn-outline-custom {
            border: 1px solid var(--input-border);
            color: var(--text-main);
            border-radius: 8px;
        }

        .btn-outline-custom:hover {
            background-color: var(--input-bg);
            color: #ffffff;
        }

       
        .table-dark-custom {
            color: var(--text-main);
            margin-bottom: 0;
        }

        .table-dark-custom th {
            background-color: #1a2332;
            border-bottom: 1px solid var(--card-border);
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
        }
        #<%= gvDeliveries.ClientID %> td, 
        #<%= gvDeliveries.ClientID %> th
        {
        color: #ffffff !important;
        }
        .table-dark-custom td {
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--card-border);
            vertical-align: middle;
        }
    
.card-overview-container {
    background-color: #111827 !important;
    border: 1px solid #1f2937 !important;
    border-radius: 10px !important;
    padding: 1.5rem !important;
    margin-top: 1.5rem !important;
}

.table-dark-custom {
    width: 100% !important;
    background-color: #111827 !important;
    border: 1px solid #374151 !important;
    border-radius: 6px !important;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    overflow: hidden !important;
    margin-bottom: 0 !important;
}


.table-dark-custom th {
    background-color: #111827 !important;
    color: #9ca3af !important;
    font-size: 0.8rem !important;
    font-weight: 700 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.05em !important;
    padding: 12px 16px !important;
    border-bottom: 1px solid #1f2937 !important;
    text-align: left !important;
}


.table-dark-custom td {
    background-color: #111827 !important;
    color: #ffffff !important;
    padding: 12px 16px !important;
    border-bottom: 1px solid #1f2937 !important;
    vertical-align: middle !important;
    text-align: left !important;
}


.table-dark-custom tr:last-child td {
    border-bottom: none !important;
}
        .badge-pending { background-color: #f59e0b; color: #000; }
        .badge-out { background-color: #3b82f6; color: #fff; }
        .badge-delivered { background-color: var(--accent-green); color: #000; }
        .badge-failed { background-color: #ef4444; color: #fff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
   
        <nav class="erp-navbar py-3 mb-4">
            <div class="container d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-4">
                    <div class="brand-logo">
                        <i class="fa-solid fa-truck-fast me-2 text-success"></i>Delivery<span>ERP</span>
                    </div>
                    <div class="d-none d-md-flex align-items-center gap-2">
                        <a href ="Default.aspx" class ="nav-link-custom"><i class="fa-solid fa-house me-1"></i>Home</a>
                        <a href="DeliveryManagement.aspx" class="nav-link-custom active fw-bold text-success">Deliveries</a>
                        <a href="DeliveryUpdate.aspx" class="nav-link-custom">Update Status</a>
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
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <!-- Master Delivery Form -->
            <div class="erp-card mb-4 shadow-lg">
                <div class="erp-card-header d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-boxes-packing text-success me-2"></i>Create / Edit Delivery Record</span>
                </div>
                <div class="card-body p-4">
                    <asp:HiddenField ID="hfDeliveryId" runat="server" Value="0" />
                    
                    <div class="row g-3 mb-4">
                        <div class="col-md-3">
                            <label class="form-label">Delivery Date</label>
                            <asp:TextBox ID="txtDeliveryDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Customer</label>
                            <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Assigned Driver</label>
                            <asp:DropDownList ID="ddlDriver" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Current Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                <asp:ListItem Value="Out For Delivery">Out For Delivery</asp:ListItem>
                                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                                <asp:ListItem Value="Failed">Failed</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Delivery Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Delivery Notes</label>
                            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <!-- Dynamic Items Grid -->
                    <h6 class="text-white fw-bold mb-3"><i class="fa-solid fa-list-check me-2 text-success"></i>Delivery Items</h6>
                    <div class="table-responsive mb-3">
                        <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="table table-dark-custom" OnRowCommand="gvItems_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="Item Code">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtItemCode" runat="server" Text='<%# Eval("ItemCode") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtItemName" runat="server" Text='<%# Eval("ItemName") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Quantity") %>' TextMode="Number" CssClass="form-control form-control-sm"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnRemoveRow" runat="server" CommandName="RemoveRow" CommandArgument='<%# Container.DataItemIndex %>' Text="Remove" CssClass="btn btn-sm btn-outline-danger" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <asp:Button ID="btnAddRow" runat="server" Text="+ Add Row" CssClass="btn btn-outline-custom btn-sm mb-4" OnClick="btnAddRow_Click" />
                    <div>
                        <asp:Button ID="btnSave" runat="server" Text="Save Delivery Record" CssClass="btn btn-emerald" OnClick="btnSave_Click" />
                    </div>
                </div>
            </div>

            <!-- Master Records Table -->
            <div class="erp-card shadow-lg">
                <div class="erp-card-header">
                    <i class="fa-solid fa-table-list me-2 text-success"></i>Deliveries Overview
                </div>
                <div class="table-responsive">
                   <asp:GridView ID="gvDeliveries" runat="server" AutoGenerateColumns="False" DataKeyNames="DeliveryId,CreatedBy" CssClass="table table-dark-custom" OnRowCommand="gvDeliveries_RowCommand">
    <Columns>
        <asp:BoundField DataField="DeliveryNumber" HeaderText="Delivery #" />
        <asp:BoundField DataField="DeliveryDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
        <asp:BoundField DataField="DriverName" HeaderText="Driver" />
        <asp:BoundField DataField="DeliveryAddress" HeaderText="Address" />
        <asp:BoundField DataField="DeliveryNotes" HeaderText="Notes" />
        <asp:BoundField DataField="CurrentStatus" HeaderText="Status" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Container.DataItemIndex %>' Text="Edit" CssClass="btn btn-sm btn-outline-light me-1" />
                <asp:Button ID="btnDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Container.DataItemIndex %>' Text="Delete" CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Delete this record?');" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
                </div>
            </div>
        </div>

    </form>
</body>
</html>