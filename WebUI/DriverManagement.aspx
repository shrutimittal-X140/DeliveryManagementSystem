<%@ Page Title="Driver Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DriverManagement.aspx.cs" Inherits="WebUI.DriverManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body, html {
            background-color: #0b0f19 !important;
            color: #ffffff !important;
        }

        .page-header-title {
            color: #ffffff !important;
            font-weight: 700 !important;
        }

        .card-custom, .card-metric, .card {
            background-color: #111827 !important;
            border: 1px solid #1f2937 !important;
            border-radius: 10px !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.5) !important;
            padding: 1rem !important;
        }


        table.custom-table,
        table.custom-table th,
        table.custom-table td,
        table.custom-table tr,
        table.custom-table td *,
        .table-dark-custom,
        .table-dark-custom th,
        .table-dark-custom td,
        .table-dark-custom tr,
        .table-dark-custom td * {
            color: #ffffff !important;
            background-color: #111827 !important;
        }

        table.custom-table th,
        .table-dark-custom th {
            background-color: #1f2937 !important;
            color: #ffffff !important;
            font-weight: 600 !important;
            border-bottom: 1px solid #374151 !important;
            padding: 12px 16px !important;
        }

        table.custom-table td,
        .table-dark-custom td {
            border-bottom: 1px solid #1f2937 !important;
            padding: 12px 16px !important;
        }
        .search-input {
            background-color: #1f2937 !important;
            border: 1px solid #374151 !important;
            color: #ffffff !important;
        }

        .badge-active {
            background-color: #10b981 !important;
            color: #ffffff !important;
            padding: 5px 12px !important;
            border-radius: 6px !important;
        }

        .badge-inactive {
            background-color: #6b7280 !important;
            color: #ffffff !important;
            padding: 5px 12px !important;
            border-radius: 6px !important;
        }

        .btn-action-edit {
            color: #ffffff !important;
            border: 1px solid #3b82f6 !important;
            background: transparent !important;
            border-radius: 6px !important;
            padding: 4px 10px !important;
        }

        .btn-action-edit:hover {
            background-color: #3b82f6 !important;
            color: #ffffff !important;
        }

        .btn-action-delete {
            color: #ef4444 !important;
            border: 1px solid #ef4444 !important;
            background: transparent !important;
            border-radius: 6px !important;
            padding: 4px 10px !important;
        }

        .btn-action-delete:hover {
            background-color: #ef4444 !important;
            color: #ffffff !important;
        }

        .metric-title {
            font-size: 0.85rem;
            color: #9ca3af !important;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }

        .metric-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #ffffff !important;
            margin: 0;
        }

        .modal-content-custom {
            background-color: #111827 !important;
            border: 1px solid #374151 !important;
            border-radius: 12px !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.7) !important;
        }

        .modal-header-custom {
            border-bottom: 1px solid #1f2937 !important;
            padding: 1.25rem 1.5rem !important;
        }

        .modal-title-custom {
            color: #ffffff !important;
            font-weight: 700 !important;
        }

        .modal-label-custom {
            color: #f1f5f9 !important;
            font-weight: 600 !important;
            margin-bottom: 0.4rem !important;
            display: block;
        }

        .modal-input-custom {
            background-color: #ffffff !important;
            border: 1px solid #cbd5e1 !important;
            color: #0f172a !important;
            font-weight: 500 !important;
        }

        .modal-footer-custom {
            border-top: 1px solid #1f2937 !important;
            padding: 1rem 1.5rem !important;
        }

        .btn-modal-cancel {
            color: #e2e8f0 !important;
            border: 1px solid #475569 !important;
            background-color: #1e293b !important;
            font-weight: 600 !important;
        }
        .btn-modal-cancel {
            color: #e2e8f0 !important;
            border: 1px solid #475569 !important;
            background-color: #1e293b !important;
            font-weight: 600 !important;
        }

 
        :root {
            --accent-green: #22c55e;
            --accent-green-hover: #16a34a;
        }
        .btn-primary {
            background-color: var(--accent-green) !important;
            border-color: var(--accent-green) !important;
            color: #000000 !important;
        }
        .btn-primary:hover, .btn-primary:focus {
            background-color: var(--accent-green-hover) !important;
            border-color: var(--accent-green-hover) !important;
            color: #ffffff !important;
        }
        .text-primary {
            color: var(--accent-green) !important;
        }
        .border-primary {
            border-color: var(--accent-green) !important;
        }
        .text-info {
            color: var(--accent-green) !important;
        }
        .border-info {
            border-color: var(--accent-green) !important;
        }
        .btn-action-edit {
            color: #ffffff !important;
            border: 1px solid var(--accent-green) !important;
        }
        .btn-action-edit:hover {
            background-color: var(--accent-green) !important;
            color: #000000 !important;
        }
        .search-input:focus {
            border-color: var(--accent-green) !important;
            box-shadow: 0 0 0 0.25rem rgba(34, 197, 94, 0.25) !important;
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <asp:UpdatePanel ID="upDriverManagement" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="container-fluid px-4 py-3">
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2 class="page-header-title mb-1">
                            <i class="fa-solid fa-id-card me-2 text-primary"></i>Driver Management
                        </h2>
                        <p class="text-muted small mb-0">Manage driver registrations, vehicle numbers, and activation status.</p>
                    </div>
                    <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Add Driver" CssClass="btn btn-primary fw-bold px-3 py-2" OnClick="btnOpenAddModal_Click" />
                </div>

                <!-- Global Metric Counters -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card card-metric border-start border-4 border-primary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="metric-title">Total Drivers</div>
                                    <asp:Label ID="lblTotalDrivers" runat="server" CssClass="metric-value" Text="0"></asp:Label>
                                </div>
                                <i class="fa-solid fa-id-card fa-2x text-primary opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card card-metric border-start border-4 border-success">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="metric-title">Total Customers</div>
                                    <asp:Label ID="lblTotalCustomers" runat="server" CssClass="metric-value" Text="0"></asp:Label>
                                </div>
                                <i class="fa-solid fa-users fa-2x text-success opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card card-metric border-start border-4 border-info">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="metric-title">Total Deliveries</div>
                                    <asp:Label ID="lblTotalDeliveries" runat="server" CssClass="metric-value" Text="0"></asp:Label>
                                </div>
                                <i class="fa-solid fa-truck-ramp-box fa-2x text-info opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search Bar -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="input-group">
                            <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" CssClass="form-control search-input" Placeholder="Search by Name, Code, Phone..." onkeyup="filterDriverGrid()" />
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary fw-bold px-3" OnClientClick="filterDriverGrid(); return false;" />
                        </div>
                    </div>
                </div>

                <!-- Grid Table Container -->
                <div class="card card-custom shadow-lg">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDrivers" runat="server" AutoGenerateColumns="False" 
                            CssClass="table custom-table align-middle" DataKeyNames="DriverId" 
                            AllowPaging="True" PageSize="10" 
                            OnPageIndexChanging="gvDrivers_PageIndexChanging" 
                            OnRowCommand="gvDrivers_RowCommand">
                            
                            <Columns>
                                <asp:BoundField DataField="DriverCode" HeaderText="Driver Code" />
                                <asp:BoundField DataField="DriverName" HeaderText="Driver Name" />
                                <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="VehicleNumber" HeaderText="Vehicle Number" />
                                <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
                                
                                <asp:TemplateField HeaderText="Active Status">
                                    <ItemTemplate>
                                        <span class='<%# Convert.ToBoolean(Eval("IsActive") ?? true) ? "badge badge-active" : "badge badge-inactive" %>'>
                                            <%# Convert.ToBoolean(Eval("IsActive") ?? true) ? "Active" : "Inactive" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditDriver" 
                                            CommandArgument='<%# Eval("DriverId") %>' CssClass="btn btn-sm btn-action-edit me-1">
                                            <i class="fa-solid fa-pen-to-square me-1"></i>Edit
                                        </asp:LinkButton>
                                        
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteDriver" 
                                            CommandArgument='<%# Eval("DriverId") %>' CssClass="btn btn-sm btn-action-delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this driver?');">
                                            <i class="fa-solid fa-trash me-1"></i>Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>

                            <EmptyDataTemplate>
                                <div class="p-4 text-center text-muted fs-6">No driver records found.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- Driver Modal (Add / Edit) -->
            <div class="modal fade" id="driverModal" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content modal-content-custom">
                        <div class="modal-header modal-header-custom">
                            <h5 class="modal-title modal-title-custom" id="modalTitle">
                                <asp:Literal ID="litModalTitle" runat="server" Text="Add Driver"></asp:Literal>
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body p-4">
                            <asp:HiddenField ID="hfDriverId" runat="server" Value="0" />
                            
                            <div class="mb-3">
                                <label class="modal-label-custom">Driver Code</label>
                                <asp:TextBox ID="txtDriverCode" runat="server" CssClass="form-control modal-input-custom" Placeholder="Enter Driver Code"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="modal-label-custom">Driver Name</label>
                                <asp:TextBox ID="txtDriverName" runat="server" CssClass="form-control modal-input-custom" Placeholder="Enter Driver Name"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="modal-label-custom">Phone Number</label>
                                <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control modal-input-custom" Placeholder="Enter Phone Number"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="modal-label-custom">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control modal-input-custom" Placeholder="Enter Email"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="modal-label-custom">Vehicle Number</label>
                                <asp:TextBox ID="txtVehicleNumber" runat="server" CssClass="form-control modal-input-custom" Placeholder="Enter Vehicle Number"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="modal-label-custom">Active Status</label>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select modal-input-custom">
                                    <asp:ListItem Text="Active" Value="true" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="false"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="modal-footer modal-footer-custom">
                            <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnSaveDriver" runat="server" Text="Save Driver" CssClass="btn btn-primary fw-bold" OnClick="btnSaveDriver_Click" />
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        function openDriverModal() {
            var el = document.getElementById('driverModal');
            if (el) {
                var modal = bootstrap.Modal.getOrCreateInstance(el);
                modal.show();
            }
        }

        function hideDriverModal() {
            var el = document.getElementById('driverModal');
            if (el) {
                var modal = bootstrap.Modal.getInstance(el);
                if (modal) {
                    modal.hide();
                }
            }
            $('.modal-backdrop').remove();
            $('body').removeClass('modal-open').css('overflow', '');
        }

        function filterDriverGrid() {
            var input = document.getElementById('txtSearch');
            if (!input) return;

            var filterValue = input.value.toLowerCase().trim();
            var grid = document.getElementById('<%= gvDrivers.ClientID %>');
            if (!grid) return;

            var rows = grid.getElementsByTagName('tr');

           
            for (var i = 1; i < rows.length; i++) {
                var row = rows[i];

               
                if (row.getElementsByTagName('th').length > 0 || row.cells.length < 6) {
                    continue;
                }

                var driverCode = row.cells[0].innerText || row.cells[0].textContent;
                var driverName = row.cells[1].innerText || row.cells[1].textContent;
                var phoneNumber = row.cells[2].innerText || row.cells[2].textContent;
                var email = row.cells[3].innerText || row.cells[3].textContent;
                var vehicleNumber = row.cells[4].innerText || row.cells[4].textContent;

                var combinedText = (driverCode + " " + driverName + " " + phoneNumber + " " + email + " " + vehicleNumber).toLowerCase();

                if (combinedText.indexOf(filterValue) > -1) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            }
        }

   
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                filterDriverGrid();
            });
        }
    </script>
</asp:Content>