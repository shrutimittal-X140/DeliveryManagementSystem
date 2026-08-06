<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerManagement.aspx.cs" Inherits="WebUI.CustomerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Force Dark Background & Smooth Global Typography */
        body, html {
            background-color: #0b0f19 !important;
            color: #e2e8f0 !important;
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .page-header-title {
            color: #ffffff !important;
            font-weight: 700 !important;
            letter-spacing: -0.02em;
        }

        .text-emerald {
            color: #22c55e !important;
        }

        .text-muted-custom {
            color: #94a3b8 !important;
        }

        /* --- MAIN CONTAINER CARD (Glassmorphism + Dark Glow) --- */
        .card-custom {
            background-color: #111827 !important;
            border-radius: 12px !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.6), 0 8px 10px -6px rgba(0, 0, 0, 0.4) !important;
            overflow: hidden !important;
        }

        /* --- TABLE STYLING --- */
        .custom-table {
            color: #e2e8f0 !important;
            margin-bottom: 0 !important;
            width: 100%;
            background-color: #111827 !important;
            border-collapse: separate;
            border-spacing: 0;
        }

        .custom-table th {
            background-color: #1a2332 !important;
            color: #94a3b8 !important;
            font-weight: 600 !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
            padding: 16px 20px !important;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .custom-table td {
            background-color: #111827 !important;
            color: #f3f4f6 !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
            padding: 16px 20px !important;
            font-size: 0.875rem;
            vertical-align: middle !important;
            transition: background-color 0.15s ease-in-out;
        }

        .custom-table tr:hover td {
            background-color: rgba(255, 255, 255, 0.03) !important;
        }

        /* Custom Code Badge in Table */
        .code-badge {
            background-color: rgba(34, 197, 94, 0.1) !important;
            color: #22c55e !important;
            border: 1px solid rgba(34, 197, 94, 0.25) !important;
            padding: 4px 8px;
            border-radius: 6px;
            font-family: monospace;
            font-weight: 600;
            font-size: 0.8rem;
        }

        /* --- SEARCH CONTROLS --- */
        .search-input {
            background-color: #1f2937 !important;
            border: 1px solid #374151 !important;
            color: #f3f4f6 !important;
            border-top-right-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
            border-top-left-radius: 8px !important;
            border-bottom-left-radius: 8px !important;
            padding: 0.6rem 1rem !important;
            font-size: 0.9rem !important;
        }

        .search-input::placeholder {
            color: #6b7280 !important;
        }

        .search-input:focus {
            border-color: #22c55e !important;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.25) !important;
            background-color: #1f2937 !important;
            color: #ffffff !important;
        }

        .btn-search-custom {
            background-color: #22c55e !important;
            color: #0b0f19 !important;
            border: 1px solid #22c55e !important;
            border-top-left-radius: 0 !important;
            border-bottom-left-radius: 0 !important;
            border-top-right-radius: 8px !important;
            border-bottom-right-radius: 8px !important;
            font-size: 0.9rem !important;
            font-weight: 700 !important;
            transition: all 0.2s ease;
        }

        .btn-search-custom:hover {
            background-color: #16a34a !important;
            border-color: #16a34a !important;
            color: #ffffff !important;
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3) !important;
        }

        /* Primary Add Customer Button */
        .btn-primary-custom {
            background: linear-gradient(135deg, #22c55e, #16a34a) !important;
            color: #ffffff !important;
            font-weight: 600 !important;
            border: none !important;
            border-radius: 8px !important;
            padding: 0.6rem 1.25rem !important;
            box-shadow: 0 4px 14px rgba(34, 197, 94, 0.35) !important;
            transition: all 0.2s ease !important;
        }

        .btn-primary-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(34, 197, 94, 0.5) !important;
            color: #ffffff !important;
        }

        /* --- ACTION BUTTONS (Outline Soft Style) --- */
        .btn-action-edit {
            color: #22c55e !important;
            border: 1px solid rgba(34, 197, 94, 0.25) !important;
            background: rgba(34, 197, 94, 0.08) !important;
            font-weight: 500 !important;
            padding: 5px 12px !important;
            border-radius: 6px !important;
            font-size: 0.8rem !important;
            transition: all 0.15s ease-in-out !important;
        }

        .btn-action-edit:hover {
            background-color: #22c55e !important;
            border-color: #22c55e !important;
            color: #0b0f19 !important;
            box-shadow: 0 2px 8px rgba(34, 197, 94, 0.4) !important;
        }

        .btn-action-delete {
            color: #f87171 !important;
            border: 1px solid rgba(248, 113, 113, 0.2) !important;
            background: rgba(248, 113, 113, 0.05) !important;
            font-weight: 500 !important;
            padding: 5px 12px !important;
            border-radius: 6px !important;
            font-size: 0.8rem !important;
            transition: all 0.15s ease-in-out !important;
        }

        .btn-action-delete:hover {
            background-color: #dc2626 !important;
            border-color: #dc2626 !important;
            color: #ffffff !important;
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.4) !important;
        }

        /* --- MODAL DARK THEME MATCHING --- */
        .modal-content-custom {
            background-color: #111827 !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 12px !important;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.85) !important;
        }

        .modal-header-custom {
            border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
            padding: 1.25rem 1.5rem !important;
        }

        .modal-title-custom {
            color: #ffffff !important;
            font-weight: 700 !important;
            font-size: 1.1rem;
        }

        .modal-label-custom {
            color: #cbd5e1 !important;
            font-weight: 500 !important;
            font-size: 0.85rem !important;
            margin-bottom: 0.4rem !important;
            display: block;
        }

        .modal-input-custom {
            background-color: #1f2937 !important;
            border: 1px solid #374151 !important;
            color: #ffffff !important;
            font-weight: 400 !important;
            border-radius: 8px !important;
            padding: 0.55rem 0.85rem !important;
            font-size: 0.9rem !important;
        }

        .modal-input-custom::placeholder {
            color: #6b7280 !important;
        }

        .modal-input-custom:focus {
            background-color: #1f2937 !important;
            border-color: #22c55e !important;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.25) !important;
            color: #ffffff !important;
        }

        .modal-footer-custom {
            border-top: 1px solid rgba(255, 255, 255, 0.08) !important;
            padding: 1rem 1.5rem !important;
            background-color: #0d131f !important;
            border-bottom-left-radius: 12px !important;
            border-bottom-right-radius: 12px !important;
        }

        .btn-modal-cancel {
            color: #94a3b8 !important;
            border: 1px solid #334155 !important;
            background-color: transparent !important;
            font-weight: 500 !important;
            border-radius: 6px !important;
        }

        .btn-modal-cancel:hover {
            background-color: #1e293b !important;
            color: #ffffff !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container-fluid px-4 py-4">
        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="page-header-title mb-1 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-users text-emerald"></i> Customer Management
                </h2>
                <p class="text-muted-custom small mb-0">Manage client profiles, contact details, and default delivery addresses.</p>
            </div>
            <button type="button" class="btn btn-primary-custom d-flex align-items-center gap-2" onclick="openAddModal()">
                <i class="fa-solid fa-plus"></i> Add Customer
            </button>
        </div>

        <!-- Alert Messages -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show bg-dark border-secondary text-light" role="alert">
            <asp:Label ID="lblAlertMsg" runat="server"></asp:Label>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- Search Bar Section -->
        <div class="row mb-4">
            <div class="col-md-5 col-lg-4">
                <div class="input-group">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control search-input" Placeholder="Search by Name, Code, Phone..." />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-search-custom fw-bold px-4" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>

        <!-- Grid Table Container -->
        <div class="card card-custom">
            <div class="table-responsive">
                <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="False" 
                    CssClass="table custom-table align-middle" GridLines="None" DataKeyNames="CustomerId"
                    OnRowCommand="gvCustomers_RowCommand">
                    
                    <Columns>
                        <asp:TemplateField HeaderText="Code">
                            <ItemTemplate>
                                <span class="code-badge"><%# Eval("CustomerCode") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" ItemStyle-CssClass="fw-semibold text-white" />
                        <asp:BoundField DataField="ContactPerson" HeaderText="Contact Person" ItemStyle-CssClass="text-secondary" />
                        <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
                        
                        <asp:TemplateField HeaderText="Email">
                            <ItemTemplate>
                                <a href='mailto:<%# Eval("Email") %>' class="text-decoration-none text-emerald">
                                    <%# Eval("Email") %>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="DeliveryAddress" HeaderText="Delivery Address" ItemStyle-CssClass="text-secondary" />
                        
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="160px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                            <ItemTemplate>
                                <div class="d-inline-flex gap-1">
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCustomer" 
                                        CommandArgument='<%# Eval("CustomerId") %>' CssClass="btn btn-action-edit">
                                        <i class="fa-solid fa-pen-to-square me-1"></i>Edit
                                    </asp:LinkButton>
                                    
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCustomer" 
                                        CommandArgument='<%# Eval("CustomerId") %>' CssClass="btn btn-action-delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this customer?');">
                                        <i class="fa-solid fa-trash me-1"></i>Delete
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                    <EmptyDataTemplate>
                        <div class="p-5 text-center text-secondary">
                            <i class="fa-solid fa-inbox fs-2 d-block mb-3 text-muted"></i>
                            No customer records found. Click 'Add Customer' to get started.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Add / Edit Customer Modal -->
    <div class="modal fade" id="customerModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title modal-title-custom" id="modalTitle">
                        <i class="fa-solid fa-user-plus text-emerald me-2"></i>Add Customer
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <asp:HiddenField ID="hfCustomerId" runat="server" Value="0" />

                    <div class="mb-3">
                        <label class="modal-label-custom">Customer Code *</label>
                        <asp:TextBox ID="txtCustomerCode" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. CUST-001"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Customer Name *</label>
                        <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. Mittal Enterprises"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Contact Person *</label>
                        <asp:TextBox ID="txtContactPerson" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. Shruti Mittal"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Phone Number *</label>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. +91 9123456789"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Email *</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control modal-input-custom" TextMode="Email" Placeholder="e.g. customer@domain.com"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Delivery Address *</label>
                        <asp:TextBox ID="txtDeliveryAddress" runat="server" CssClass="form-control modal-input-custom" TextMode="MultiLine" Rows="3" Placeholder="Full street address..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn btn-modal-cancel btn-sm px-3 py-2" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveCustomer" runat="server" Text="Save Customer" CssClass="btn btn-primary-custom btn-sm fw-bold px-4 py-2" OnClick="btnSaveCustomer_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var customerModal;

        document.addEventListener("DOMContentLoaded", function () {
            var modalEl = document.getElementById('customerModal');
            if (modalEl) {
                customerModal = new bootstrap.Modal(modalEl);
            }
        });

        function openAddModal() {
            document.getElementById('<%= hfCustomerId.ClientID %>').value = "0";
            document.getElementById('<%= txtCustomerCode.ClientID %>').value = "";
            document.getElementById('<%= txtCustomerName.ClientID %>').value = "";
            document.getElementById('<%= txtContactPerson.ClientID %>').value = "";
            document.getElementById('<%= txtPhoneNumber.ClientID %>').value = "";
            document.getElementById('<%= txtEmail.ClientID %>').value = "";
            document.getElementById('<%= txtDeliveryAddress.ClientID %>').value = "";

            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-user-plus text-emerald me-2"></i>Add Customer';
            if (customerModal) {
                customerModal.show();
            }
        }

        function openModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-pen-to-square text-emerald me-2"></i>Edit Customer';
            if (customerModal) {
                customerModal.show();
            }
        }
    </script>
</asp:Content>