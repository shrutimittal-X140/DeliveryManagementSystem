<%@ Page Title="Driver Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DriverManagement.aspx.cs" Inherits="WebUI.DriverManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://unpkg.com/bootstrap-table@1.22.1/dist/bootstrap-table.min.css" rel="stylesheet">
    <style>
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

        .card-custom, .card-metric {
            background-color: #111827 !important;
            border-radius: 12px !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.6), 0 8px 10px -6px rgba(0, 0, 0, 0.4) !important;
            overflow: hidden !important;
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

        .table-responsive-custom {
            width: 100% !important;
            overflow-x: auto !important;
            background-color: #111827 !important;
        }

        .custom-table {
            color: #e2e8f0 !important;
            margin-bottom: 0 !important;
            width: 100% !important;
            background-color: #111827 !important;
            border-collapse: collapse !important;
        }

        .custom-table th {
            background-color: #1a2332 !important;
            color: #94a3b8 !important;
            font-weight: 600 !important;
            border-bottom: 2px solid rgba(255, 255, 255, 0.08) !important;
            padding: 16px 20px !important;
            font-size: 0.75rem !important;
            text-transform: uppercase !important;
            letter-spacing: 0.08em !important;
            text-align: left !important;
        }

        .custom-table td {
            background-color: #111827 !important;
            color: #f3f4f6 !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
            padding: 16px 20px !important;
            font-size: 0.875rem !important;
            vertical-align: middle !important;
            text-align: left !important;
        }

        .custom-table tr:hover td {
            background-color: rgba(255, 255, 255, 0.03) !important;
        }

        .badge-active {
            background-color: rgba(34, 197, 94, 0.15) !important;
            color: #22c55e !important;
            border: 1px solid rgba(34, 197, 94, 0.3) !important;
            padding: 4px 10px !important;
            border-radius: 6px !important;
            font-weight: 600;
        }

        .badge-inactive {
            background-color: rgba(107, 114, 128, 0.15) !important;
            color: #9ca3af !important;
            border: 1px solid rgba(107, 114, 128, 0.3) !important;
            padding: 4px 10px !important;
            border-radius: 6px !important;
            font-weight: 600;
        }

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
                    <i class="fa-solid fa-id-card text-emerald"></i> Driver Management
                </h2>
                <p class="text-muted-custom small mb-0">Manage driver registrations, vehicle numbers, and activation status.</p>
            </div>
            <button type="button" class="btn btn-primary-custom d-flex align-items-center gap-2" onclick="openAddModal()">
                <i class="fa-solid fa-plus"></i> Add Driver
            </button>
        </div>

        <!-- Global Metric Counters -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card card-metric p-3 border-start border-4 border-emerald">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="metric-title">Total Drivers</div>
                            <span id="lblTotalDrivers" class="metric-value">0</span>
                        </div>
                        <i class="fa-solid fa-id-card fa-2x text-emerald opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-metric p-3 border-start border-4 border-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="metric-title">Total Customers</div>
                            <span id="lblTotalCustomers" class="metric-value">0</span>
                        </div>
                        <i class="fa-solid fa-users fa-2x text-success opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-metric p-3 border-start border-4 border-info">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="metric-title">Total Deliveries</div>
                            <span id="lblTotalDeliveries" class="metric-value">0</span>
                        </div>
                        <i class="fa-solid fa-truck-ramp-box fa-2x text-info opacity-50"></i>
                    </div>
                </div>
            </div>
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
                    <input type="text" id="txtSearch" class="form-control search-input" placeholder="Search by Name, Code, Phone..." />
                    <button type="button" id="btnSearch" class="btn btn-search-custom fw-bold px-4">Search</button>
                </div>
            </div>
        </div>

        <!-- Grid Table Container -->
        <div class="card card-custom">
            <div class="table-responsive-custom">
                <table id="driverTable" class="table custom-table align-middle"></table>
            </div>
        </div>
    </div>

    <!-- Add / Edit Driver Modal -->
    <div class="modal fade" id="driverModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title modal-title-custom" id="modalTitle">
                        <i class="fa-solid fa-id-card text-emerald me-2"></i>Add Driver
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <asp:HiddenField ID="hfDriverId" runat="server" Value="0" />

                    <div class="mb-3">
                        <label class="modal-label-custom">Driver Code *</label>
                        <asp:TextBox ID="txtDriverCode" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. DRV-001"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Driver Name *</label>
                        <asp:TextBox ID="txtDriverName" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. John Doe"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Phone Number *</label>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. +91 9123456789"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Email *</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control modal-input-custom" TextMode="Email" Placeholder="e.g. driver@domain.com"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="modal-label-custom">Vehicle Number *</label>
                        <asp:TextBox ID="txtVehicleNumber" runat="server" CssClass="form-control modal-input-custom" Placeholder="e.g. KA-01-AB-1234"></asp:TextBox>
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
                    <button type="button" class="btn btn-modal-cancel btn-sm px-3 py-2" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="btnSaveDriver" class="btn btn-primary-custom btn-sm fw-bold px-4 py-2" onclick="submitDriverForm()">Save Driver</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="https://unpkg.com/bootstrap-table@1.22.1/dist/bootstrap-table.min.js"></script>
    <script>
        var driverModal;
        var allDriversCache = [];

        document.addEventListener("DOMContentLoaded", function () {
            var modalEl = document.getElementById('driverModal');
            if (modalEl && window.bootstrap && bootstrap.Modal) {
                driverModal = new bootstrap.Modal(modalEl);
            }

            initDriverTable();

            $("#btnSearch").click(function (e) {
                e.preventDefault();
                $('#driverTable').bootstrapTable('refresh');
            });

            $("#txtSearch").keyup(function (e) {
                if (e.key === "Enter") {
                    $('#driverTable').bootstrapTable('refresh');
                }
            });
        });

        function initDriverTable() {
            $('#driverTable').bootstrapTable({
                method: 'post',
                contentType: "application/json; charset=utf-8",
                ajax: driverTableAjax,
                sidePagination: 'server',
                pagination: true,
                pageSize: 10,
                pageList: [10, 25, 50, 100],
                sortName: 'DriverId',
                sortOrder: 'desc',
                search: false,
                striped: true,
                columns: [{
                    field: 'DriverCode',
                    title: 'Driver Code',
                    sortable: true
                }, {
                    field: 'DriverName',
                    title: 'Driver Name',
                    sortable: true
                }, {
                    field: 'PhoneNumber',
                    title: 'Phone Number'
                }, {
                    field: 'Email',
                    title: 'Email'
                }, {
                    field: 'VehicleNumber',
                    title: 'Vehicle Number'
                }, {
                    field: 'CreatedBy',
                    title: 'Created By'
                }, {
                    field: 'IsActive',
                    title: 'Active Status',
                    align: 'center',
                    formatter: statusFormatter
                }, {
                    field: 'DriverId',
                    title: 'Actions',
                    align: 'right',
                    escape: false,
                    formatter: driverActionsFormatter
                }]
            });
        }


        document.addEventListener("DOMContentLoaded", function () {
            var modalEl = document.getElementById('driverModal');
            if (modalEl && window.bootstrap && bootstrap.Modal) {
                driverModal = new bootstrap.Modal(modalEl);
            }

            initDriverTable();
            loadDashboardCounts();

            $("#btnSearch").keyup(function (e) {
                e.preventDefault();
                $('#driverTable').bootstrapTable('refresh');
            })

            $("#txtSearch").keyup(function (e) {
                if (e.key === "Enter") {
                    $('#driverTable').bootstrapTable('refresh');
                }
            })
        })

        function driverTableAjax(params) {
            var searchVal = $("#txtSearch").val() || "";
            $.ajax({
                type: "POST",
                url: "WebServices/DriverService.asmx/GetDriversPaged",
                data: JSON.stringify({
                    limit: params.data.limit,
                    offset: params.data.offset,
                    sort: params.data.sort || "DriverId",
                    order: params.data.order || "desc",
                    search: searchVal
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d;
                    allDriversCache = result.rows || [];

                    if (result.metrics) {
                        $("#lblTotalDrivers").text(result.metrics.totalDrivers || 0);
                        $("#lblTotalCustomers").text(result.metrics.totalCustomers || 0);
                        $("#lblTotalDeliveries").text(result.metrics.totalDeliveries || 0);
                    }

                    params.success({ total: result.total, rows: result.rows });
                },
                error: function (xhr) {
                    console.error("Driver grid load failed:", xhr.responseText);
                    params.error();
                }
            });
        }

        function populateItemDropdowns() {
            $.ajax({
                type: "POST",
                url: "WebServices/ItemService.asmx/GetItems",
                contentType: "application/json; charset= utf-8",
                dataType: "json",
                success: function (res) {
                    if (res.d.success) {
                        var options = '<option value= "">-- Select Item --</option>';
                        $.each(res.d.data, function (i, item) {
                            if (item.IsActive) {
                                options += '<option value="' + item.ItemCode + '" data-name=' + item.ItemName + '">' + item.ItemCode + ' - ' + item.ItemName + '</option';
                            }
                        });
                        $('.ddlDeliveryItemsSelect').html(options);
                    }
                }
            })
        }

        function loadDashboardCounts()
        {
            $.ajax({
                type: "POST",
                url: "WebServices/DriverService.asmx/GetDashboardCounts",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;
                    if (res.success) {
                        $("#lblTotalDrivers").text(res.totalDrivers);
                        $("#lblTotalCustomers").text(res.totalCustomers);
                        $("#lblTotalDeliveries").text(res.totalDeliveries);
                    }
                },
                error: function (xhr) {
                    console.error("Failed to load dashboard counts:", xhr.responseText);
                }
            });
        }

        function statusFormatter(value) {
            var active = (value === true || value === "true" || value === undefined);
            return active ? '<span class="badge badge-active">Active</span>' : '<span class="badge badge-inactive">Inactive</span>';
        }

        function driverActionsFormatter(driverId) {
            return '<div class="d-inline-flex gap-2">' +
                '<button type="button" class="btn btn-action-edit btn-sm" onclick="editDriverById(' + driverId + ')">Edit</button>' +
                '<button type="button" class="btn btn-action-delete btn-sm" onclick="deleteDriver(' + driverId + ')">Delete</button>' +
                '</div>';
        }

        function editDriverById(driverId) {
            var driver = allDriversCache.find(d => d.DriverId == driverId);
            if (!driver) return;
            editDriver(driver);
        }

        function editDriver(obj) {
            if (!obj) return;
            document.getElementById('<%= hfDriverId.ClientID %>').value = obj.DriverId || "0";
            document.getElementById('<%= txtDriverCode.ClientID %>').value = obj.DriverCode || "";
            document.getElementById('<%= txtDriverName.ClientID %>').value = obj.DriverName || "";
            document.getElementById('<%= txtPhoneNumber.ClientID %>').value = obj.PhoneNumber || "";
            document.getElementById('<%= txtEmail.ClientID %>').value = obj.Email || "";
            document.getElementById('<%= txtVehicleNumber.ClientID %>').value = obj.VehicleNumber || "";
            document.getElementById('<%= ddlStatus.ClientID %>').value = (obj.IsActive !== undefined ? obj.IsActive.toString() : "true");

            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-pen-to-square text-emerald me-2"></i>Edit Driver';
            if (driverModal) driverModal.show();
        }

        function openAddModal() {
            document.getElementById('<%= hfDriverId.ClientID %>').value = "0";
            document.getElementById('<%= txtDriverCode.ClientID %>').value = "";
            document.getElementById('<%= txtDriverName.ClientID %>').value = "";
            document.getElementById('<%= txtPhoneNumber.ClientID %>').value = "";
            document.getElementById('<%= txtEmail.ClientID %>').value = "";
            document.getElementById('<%= txtVehicleNumber.ClientID %>').value = "";
            document.getElementById('<%= ddlStatus.ClientID %>').value = "true";

            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-id-card text-emerald me-2"></i>Add Driver';
            if (driverModal) driverModal.show();
        }

        function submitDriverForm() {
            var driver = {
                driverId: parseInt(document.getElementById('<%= hfDriverId.ClientID %>').value) || 0,
                driverCode: document.getElementById('<%= txtDriverCode.ClientID %>').value,
                driverName: document.getElementById('<%= txtDriverName.ClientID %>').value,
                phoneNumber: document.getElementById('<%= txtPhoneNumber.ClientID %>').value,
                email: document.getElementById('<%= txtEmail.ClientID %>').value,
                vehicleNumber: document.getElementById('<%= txtVehicleNumber.ClientID %>').value,
                isActive: document.getElementById('<%= ddlStatus.ClientID %>').value === "true"
            };
            saveDriver(driver);
        }

        function saveDriver(driver) {
            $.ajax({
                type: "POST",
                url: "WebServices/DriverService.asmx/SaveDriver",
                data: JSON.stringify(driver),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d;
                    if (result.success) {
                        if (driverModal) driverModal.hide();
                        $('#driverTable').bootstrapTable('refresh');
                    } else {
                        alert(result.message);
                    }
                }
            });
        }

        function deleteDriver(id) {
            if (confirm("Are you sure you want to delete this driver record?")) {
                $.ajax({
                    type: "POST",
                    url: "WebServices/DriverService.asmx/DeleteDriver",
                    data: JSON.stringify({ driverId: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = response.d;
                        if (result.success) {
                            $('#driverTable').bootstrapTable('refresh');
                        } else {
                            alert(result.message);
                        }
                    }
                });
            }
        }
    </script>
</asp:Content>