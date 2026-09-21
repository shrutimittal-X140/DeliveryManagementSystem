<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryManagement.aspx.cs" Inherits="WebUI.DeliveryManagement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Delivery Management - DeliveryERP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://unpkg.com/bootstrap-table@1.22.1/dist/bootstrap-table.min.css" rel="stylesheet" />
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
            width: 100% !important;
            background-color: var(--card-bg) !important;
            border: 1px solid var(--card-border) !important;
            border-radius: 8px !important;
            overflow: hidden !important;
            margin-bottom: 0 !important;
        }

        .table-dark-custom th {
            background-color: #1a2332 !important;
            color: var(--text-muted) !important;
            font-size: 0.8rem !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 0.05em !important;
            padding: 12px 16px !important;
            border-bottom: 1px solid var(--card-border) !important;
            border-top: none !important;
        }

        .table-dark-custom td {
            background-color: var(--card-bg) !important;
            color: var(--text-main) !important;
            padding: 12px 16px !important;
            border-bottom: 1px solid var(--card-border) !important;
            vertical-align: middle !important;
        }

        .table-dark-custom tr:last-child td {
            border-bottom: none !important;
        }

        .table-dark-custom tbody tr:hover td {
            background-color: #1a2332 !important;
        }

        .bootstrap-table .fixed-table-container {
            border: 1px solid var(--card-border) !important;
            border-radius: 8px !important;
            background-color: var(--card-bg) !important;
        }

        .fixed-table-pagination .pagination-detail,
        .fixed-table-pagination .page-list {
            color: var(--text-muted) !important;
        }

        .page-item .page-link {
            background-color: var(--input-bg) !important;
            border-color: var(--card-border) !important;
            color: var(--text-main) !important;
        }

        .page-item.active .page-link {
            background-color: var(--accent-green) !important;
            border-color: var(--accent-green) !important;
            color: #000000 !important;
            font-weight: bold;
        }

        .bootstrap-table .search input {
            background-color: var(--input-bg) !important;
            border: 1px solid var(--input-border) !important;
            color: var(--text-main) !important;
            border-radius: 6px;
        }

        .status-pill {
         display: inline-block !important;
         padding: 6px 16px !important;
         border-radius: 50px !important;
         font-size: 0.72rem !important;
         font-weight: 800 !important;
         letter-spacing: 0.05em !important;
         text-transform: uppercase !important;
         text-align: center !important;
         min-width: 140px !important;
         }

       .badge-pending { 
        background-color: rgba(245, 158, 11, 0.12) !important;
        color: #f59e0b !important;
        border: 1px solid rgba(245, 158, 11, 0.4) !important;
        padding: 6px 12px !important; 
        border-radius: 20px !important; 
        font-weight: 600 !important; 
        font-size: 0.75rem !important;
        display: inline-block !important;
        text-align: center !important;
        min-width: 110px !important;
        }

       .badge-out { 
        background-color: rgba(14, 165, 233, 0.12) !important;
        color: #0ea5e9 !important;
        border: 1px solid rgba(14, 165, 233, 0.4) !important;
        padding: 6px 12px !important; 
        border-radius: 20px !important; 
        font-weight: 600 !important; 
        font-size: 0.75rem !important;
        display: inline-block !important;
        text-align: center !important;
        min-width: 110px !important;
        }

       .badge-delivered { 
        background-color: rgba(34, 197, 94, 0.12) !important;
        color: #22c55e !important;
        border: 1px solid rgba(34, 197, 94, 0.4) !important;
        padding: 6px 12px !important; 
        border-radius: 20px !important; 
        font-weight: 600 !important; 
        font-size: 0.75rem !important;
        display: inline-block !important;
        text-align: center !important;
        min-width: 110px !important;
        }

       .badge-failed { 
        background-color: rgba(239, 68, 68, 0.12) !important;
        color: #ef4444 !important; 
        border: 1px solid rgba(239, 68, 68, 0.4) !important;
        padding: 6px 12px !important; 
        border-radius: 20px !important; 
        font-weight: 600 !important; 
        font-size: 0.75rem !important;
        display: inline-block !important;
        text-align: center !important;
        min-width: 110px !important;
        }
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
                        <a href="Default.aspx" class="nav-link-custom"><i class="fa-solid fa-house me-1"></i>Home</a>
                        <a href="DeliveryManagement.aspx" class="nav-link-custom active fw-bold text-success">Deliveries</a>
                        <a href="DeliveryUpdate.aspx" class="nav-link-custom">Update Status</a>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted small">
                        <i class="fa-regular fa-user-circle me-1"></i> <%= Session["Username"] %> 
                        <span class="badge bg-secondary ms-1"><%= Session["Role"] %></span>
                    </span>
                  <a href="Logout.aspx" class="btn btn-outline-danger btn-sm">Logout</a>
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
                        <table id="tblItems" class="table table-dark-custom">
                            <thead>
                                <tr>
                                    <th style= "width: 22%;"> Select Item </th>
                                    <th style =" width: 22%;"> Item Code</th>
                                    <th style ="width: 33%;"> Item Name</th>
                                    <th style ="width:13%;"> Quantity</th>
                                    <th style =" width: 10%;" class="text-center"> Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                    <button type="button" id="btnAddRow" class="btn btn-outline-success" onclick="addNewItemRow()">+ Add Row</button>
                    <button type="button" id="btnSave" class="btn btn-success ms-2" onclick="saveDeliveryForm()">Save Delivery Record</button>
                </div>
            </div>

            <!-- Master Records Table -->
            <div class="erp-card shadow-lg p-3">
                <div class="erp-card-header mb-3 ps-1">
                    <i class="fa-solid fa-table-list me-2 text-success"></i>Deliveries Overview
                </div>
                <table id="tblDeliveries" class="table table-dark-custom"></table>
            </div>
        </div>

    </form>

    <!-- View Delivery Details Modal -->
    <div class="modal fade" id="viewDeliveryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="background-color: var(--card-bg); border: 1px solid var(--card-border); border-radius: 12px;">
                <div class="modal-header" style="border-bottom: 1px solid var(--card-border);">
                    <h5 class="modal-title text-white fw-bold">
                        <i class="fa-solid fa-circle-info text-success me-2"></i>Delivery Details <span id="viewDeliveryNumber" class="text-success"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <div class="form-label mb-1">Delivery Date</div>
                            <div class="text-white fw-semibold" id="viewDate">-</div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-label mb-1">Customer</div>
                            <div class="text-white fw-semibold" id="viewCustomer">-</div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-label mb-1">Assigned Driver</div>
                            <div class="text-white fw-semibold" id="viewDriver">-</div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-label mb-1">Current Status</div>
                            <div id="viewStatus">-</div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-label mb-1">Delivery Address</div>
                            <div class="text-white" id="viewAddress">-</div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-label mb-1">Delivery Notes</div>
                            <div class="text-white" id="viewNotes">-</div>
                        </div>
                    </div>

                    <h6 class="text-white fw-bold mb-3"><i class="fa-solid fa-list-check me-2 text-success"></i>Delivery Items</h6>
                    <div class="table-responsive">
                        <table class="table table-dark-custom">
                            <thead>
                                <tr>
                                    <th>Item Code</th>
                                    <th>Item Name</th>
                                    <th>Quantity</th>
                                </tr>
                            </thead>
                            <tbody id="viewItemsBody">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid var(--card-border);">
                    <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-emerald" id="btnViewToEdit">Edit This Delivery</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/bootstrap-table@1.22.1/dist/bootstrap-table.min.js"></script>
    <script type="text/javascript">

        var allCatalogItems = [];

        $(document).ready(function () {
            loadInitialDropdowns();
            loadCatalogItems();
            addNewItemRow();
            initDeliveriesTable();
        });

        function loadCatalogItems() {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/GetAllItemsSimple") %>',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;
                    if (res.success) {
                        allCatalogItems = res.items || [];

                        $('.ddlCatalogItem').each(function () {
                            var currentCode = $(this).closest('tr').find("input[id*= 'txtItemCode']").val();
                            $(this).html(buildCatalogOptions(currentCode));
                        });
                    }
                },
                error: function (xhr) {
                    console.error("Failed to load items catalog:", xhr.status, xhr.responseText);
                }
            });
        }

        function buildCatalogOptions(selectedCode) {
            var options = '<option value="">-- Select Item (optional) --</option>';
            $.each(allCatalogItems, function (i, it) {
                var isSelected = (selectedCode && it.ItemCode === selectedCode) ? 'selected' : '';
                options += '<option value="' + it.ItemCode + '" data-name="' + it.ItemName + '" ' + isSelected + '>' + it.ItemCode + ' - ' + it.ItemName + '</option>';
            });
            return options;
        }

        function loadInitialDropdowns() {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/GetInitialData") %>',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;

                    if (!res.success) {
                        showFlash(res.message || "Session expired. Please log in again.", "error");
                        setTimeout(function () { window.location.href = "Login.aspx"; }, 1500);
                        return;
                    }

                    populateDropdown($('#<%= ddlCustomer.ClientID %>'), res.customers, "CustomerId", "CustomerName");
                    populateDropdown($('#<%= ddlDriver.ClientID %>'), res.drivers, "DriverId", "DriverName");
                },
                error: function (xhr) {
                    console.error("Failed to load customers/drivers:", xhr.status, xhr.responseText);
                    showFlash("Failed to load customer/driver lists. Please refresh the page.", "error");
                }
            });
        }

        function populateDropdown(selectEl, items, valueField, textField) {
            var currentVal = selectEl.val();
            selectEl.empty();
            selectEl.append('<option value="">-- Select --</option>');
            $.each(items, function (i, item) {
                selectEl.append(`<option value="${item[valueField]}">${item[textField]}</option>`);
            });
            if (currentVal) selectEl.val(currentVal);
        }

        function initDeliveriesTable() {
            $('#tblDeliveries').bootstrapTable('destroy').bootstrapTable({
                cache: false,
                method: 'post',
                contentType: "application/json; charset=utf-8",
                ajax: deliveryTableAjax,
                sidePagination: 'server',
                pagination: true,
                pageSize: 10,
                pageList: [10, 25, 50, 100],
                sortName: 'DeliveryId',
                sortOrder: 'desc',
                search: true,
                columns: [{
                    field: 'DeliveryId',
                    title: 'Delivery ID',
                    sortable: true
                }, {
                    field: 'DeliveryNumber',
                    title: 'Delivery #',
                    sortable: true
                }, {
                    field: 'DeliveryDate',
                    title: 'Date',
                    sortable: true
                }, {
                    field: 'CustomerName',
                    title: 'Customer',
                    sortable: true
                }, {
                    field: 'DriverName',
                    title: 'Driver',
                    sortable: false
                }, {
                    field: 'DeliveryAddress',
                    title: 'Address',
                    sortable: false
                }, {
                    field: 'CurrentStatus',
                    title: 'Status',
                    sortable: true,
                    align: 'center',
                    halign: 'center',
                    formatter: statusFormatter
                }, {
                    field: 'DeliveryId',
                    title: 'Actions',
                    escape: false,
                    formatter: deliveryActionsFormatter
                }]
            });
        }

        function deliveryTableAjax(params) {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/GetDeliveriesPaged") %>',
                data: JSON.stringify({
                    limit: params.data.limit || 10,
                    offset: params.data.offset || 0,
                    sort: params.data.sort || "DeliveryId",
                    order: params.data.order || "desc",
                    search: params.data.search || ""
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.d ? response.d : response;
                    if (typeof data === 'string') {
                        data = JSON.parse(data);
                    }
                    if (Array.isArray(data)) {
                        params.success({
                            total: data.length,
                            rows: data
                        });
                    } else {
                        params.success({
                            total: data.total || 0,
                            rows: data.rows || []
                        });
                    }
                },
                error: function (xhr) {
                    console.error("Delivery grid load failed: ", xhr.responseText);
                    params.error();
                }
            });
        }

        function statusFormatter(value, row, index) {
            var status = value ? value.toString().trim() : "";
            var s = status.toLowerCase().replace(/\s+/g, ' ');
            var badgeClass = "badge-pending";

            if (s === "pending") {
                badgeClass = "badge-pending";
            } else if (s === "out for delivery" || s === "outfordelivery") {
                badgeClass = "badge-out";
            } else if (s === "delivered") {
                badgeClass = "badge-delivered";
            } else if (s === "failed") {
                badgeClass = "badge-failed";
            }

            return '<span class="status-pill ' + badgeClass + '">' + status + '</span>';
        }

        function deliveryActionsFormatter(value, row, index) {
            var deliveryId = value;
            return '<button type="button" class="btn btn-sm btn-outline-success me-1" onclick="viewDeliveryDetails(' + deliveryId + ')" title="View Details"><i class="fa-solid fa-eye"></i></button>' +
                '<button type="button" class="btn btn-sm btn-outline-info me-1" onclick="loadDeliveryForEdit(' + deliveryId + ')" title="Edit"><i class="fa-solid fa-pen-to-square"></i></button>' +
                '<button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteDeliveryRecord(' + deliveryId + ')" title="Delete"><i class="fa-solid fa-trash-can"></i></button>';
        }

        function loadDeliveryForEdit(deliveryId) {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/LoadDelivery") %>',
                data: JSON.stringify({ deliveryId: deliveryId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;
                    if (res.success) {
                        $('#<%= hfDeliveryId.ClientID %>').val(res.master.DeliveryId);
                        $('#<%= txtDeliveryDate.ClientID %>').val(res.master.DeliveryDate);
                        $('#<%= ddlCustomer.ClientID %>').val(res.master.CustomerId);
                        $('#<%= ddlDriver.ClientID %>').val(res.master.DriverId);
                        $('#<%= txtAddress.ClientID %>').val(res.master.DeliveryAddress);
                        $('#<%= txtNotes.ClientID %>').val(res.master.DeliveryNotes);
                        $('#<%= ddlStatus.ClientID %>').val(res.master.CurrentStatus);

                        $('#tblItems tbody').empty();
                        if (res.items && res.items.length > 0) {
                            $.each(res.items, function (index, item) {
                                addNewItemRow(item.ItemCode, item.ItemName, item.Quantity);
                            });
                        } else {
                            addNewItemRow();
                        }

                        $('html, body').animate({ scrollTop: 0 }, 'fast');
                    } else {
                        alert("Could not load details: " + res.message);
                    }
                },
                error: function (xhr) {
                    console.error(xhr.responseText);
                    alert("Error communicating with service while loading delivery profile.");
                }
            });
        }

        var currentViewDeliveryId = 0;
        function viewDeliveryDetails(deliveryId) {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/LoadDelivery") %>',
                data: JSON.stringify({ deliveryId: deliveryId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;
                    if (!res.success) {
                        alert("Could not load details : " + res.message);
                        return;
                    }

                    currentViewDeliveryId = deliveryId;

                    $('#viewDeliveryNumber').text('#' + res.message);
                    $('#viewDate').text(res.master.DeliveryDate || '-');
                    $('#viewAddress').text(res.master.DeliveryAddress || '-');
                    $('#viewNotes').text(res.master.DeliveryNotes || 'No notes recorded');
                    $('#viewStatus').html(statusFormatter(res.master.CurrentStatus));

                    var custOption = $('#<%= ddlCustomer.ClientID %> option[value="' + res.master.CustomerId + '"]');
                    $('#viewCustomer').text(custOption.length ? custOption.text() : res.master.CustomerId);

                    var driverOption = $('#<%= ddlDriver.ClientID %> option[value="' + res.master.DriverId + '"]');
                    $('#viewDriver').text(driverOption.length ? driverOption.text() : res.master.DriverId);

                    var itemsBody = $('#viewItemsBody');
                    itemsBody.empty();
                    if (res.items && res.items.length > 0) {
                        $.each(res.items, function (index, item) {
                            itemsBody.append('<tr><td>' + (item.ItemCode || '-') + '</td><td>' + (item.ItemName || '-') + '</td> <td>' + (item.Quantity || '-') + '</td></tr>');
                        });
                    } else {
                        itemsBody.append('<tr><td colspan= "3" class= "text-center text-muted"> No items recorded </td></tr>');
                    }

                    var modal = new bootstrap.Modal(document.getElementById('viewDeliveryModal'));
                    modal.show();
                },
                error: function (xhr) {
                    console.error(xhr.responseText);
                    alert("Error communicating with service while loading delivery profile.");
                }
            });
        }

        $(document).on('click', '#btnViewToEdit', function () {
            var modalEl = document.getElementById('viewDeliveryModal');
            var modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
            loadDeliveryForEdit(currentViewDeliveryId);
        })

        function deleteDeliveryRecord(deliveryId) {
            if (confirm("Are you sure you want to completely erase delivery data profile #" + deliveryId + "?")) {
                $.ajax({
                    type: "POST",
                    url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/DeleteDelivery") %>',
                    data: JSON.stringify({ deliveryId: deliveryId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var res = response.d;
                        alert(res.message);
                        if (res.success) {
                            $('#tblDeliveries').bootstrapTable('refresh');
                        }
                    },
                    error: function (xhr) {
                        alert("Error handling request: " + xhr.responseText);
                    }
                });
            }
        }

        function saveDeliveryForm(e) {
            if (e && e.preventDefault) { e.preventDefault(); }

            var deliveryId = parseInt($('#<%= hfDeliveryId.ClientID %>').val()) || 0;
            var deliveryDate = $('#<%= txtDeliveryDate.ClientID %>').val();
            var customerId = parseInt($('#<%= ddlCustomer.ClientID %>').val()) || 0;
            var driverId = parseInt($('#<%= ddlDriver.ClientID %>').val()) || 0;
            var address = $('#<%= txtAddress.ClientID %>').val();
            var notes = $('#<%= txtNotes.ClientID %>').val();
            var status = $('#<%= ddlStatus.ClientID %>').val();

            if (!deliveryDate || customerId === 0 || driverId === 0) {
                alert("Please fill out all required fields (Date, Customer, and Driver).");
                return false;
            }

            var items = [];
            $('#tblItems tbody tr').each(function () {
                var code = $(this).find("input[id*='txtItemCode']").val();
                var name = $(this).find("input[id*='txtItemName']").val();
                var qty = $(this).find("input[id*='txtQuantity']").val();
                if (code || name) {
                    items.push({ ItemCode: code || "", ItemName: name || "", Quantity: parseInt(qty) || 1 });
                }
            });

            var payload = {
                deliveryId: deliveryId,
                deliveryDate: deliveryDate,
                customerId: customerId,
                driverId: driverId,
                address: address,
                notes: notes,
                status: status,
                items: items
            };

            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/SaveDelivery") %>',
                data: JSON.stringify(payload),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;

                    if (!res.success) {
                        showFlash(res.message, "error");
                        return;
                    }

                    if (res.emailSent) {
                        showFlash(res.message, "success");
                    } else if (res.message && res.message.toLowerCase().indexOf("delivered") !== -1) {
                        showFlash(res.message, "warning");
                    } else {
                        showFlash(res.message, "success");
                    }

                    resetFormFields();
                    $('#tblDeliveries').bootstrapTable('refresh');
                },
                error: function (xhr) {
                    alert("Error saving record: " + xhr.responseText);
                }
            });

            return false;
        }

        function resetFormFields() {
            $('#<%= hfDeliveryId.ClientID %>').val('0');
            $('#<%= txtDeliveryDate.ClientID %>').val('');
            $('#<%= ddlCustomer.ClientID %>').val('');
            $('#<%= ddlDriver.ClientID %>').val('');
            $('#<%= txtAddress.ClientID %>').val('');
            $('#<%= txtNotes.ClientID %>').val('');
            $('#<%= ddlStatus.ClientID %>').val('Pending');
            $('#tblItems tbody').empty();
            addNewItemRow();
        }

        function showFlash(message, type) {
            var colors = { success: "#22c55e", warning: "#f59e0b", error: "#ef4444" };
            var $flash = $("<div/>").html('<i class="fa-solid ' +
                (type === "success" ? "fa-circle-check" : type === "warning" ? "fa-triangle-exclamation" : "fa-circle-xmark") +
                ' me-2"></i>' + message).css({
                    position: "fixed", top: "20px", right: "20px", zIndex: 9999,
                    padding: "12px 20px", borderRadius: "8px", color: type === "success" || type === "error" ? "#fff" : "#000",
                    backgroundColor: colors[type] || "#333", boxShadow: "0 4px 12px rgba(0,0,0,.3)",
                    fontWeight: "600", fontSize: "0.9rem"
                });
            $("body").append($flash);
            setTimeout(function () { $flash.fadeOut(400, function () { $(this).remove(); }); }, 3500);
        }

        function addNewItemRow(itemCode, itemName, quantity) {
            var codeValue = itemCode || "";
            var nameValue = itemName || "";
            var qtyValue = quantity || 1;

            var rowHtml = `<tr>
        <td>
            <select class="form-select form-select-sm ddlCatalogItem">
                ${buildCatalogOptions(codeValue)}
            </select>
        </td>
        <td><input type="text" id="txtItemCode" class="form-control form-control-sm" value="${codeValue}" placeholder="Code..." /></td>
        <td><input type="text" id="txtItemName" class="form-control form-control-sm" value="${nameValue}" placeholder="Item Name..." /></td>
        <td><input type="number" id="txtQuantity" class="form-control form-control-sm" value="${qtyValue}" min="1" /></td>
        <td class="text-center">
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItemRow(this)">
                <i class="fa-solid fa-trash-can"></i>
            </button>
        </td>
    </tr>`;

            $('#tblItems tbody').append(rowHtml);
        }

        $(document).on('change', '.ddlCatalogItem', function () {
            var selectedOption = $(this).find('option:selected');
            var code = selectedOption.val();
            var name = selectedOption.data('name');
            var row = $(this).closest('tr');

            if (code) {
                row.find("input[id*= 'txtItemCode']").val(code);
                row.find("input[id*= 'txtItemName']").val(name);
            }
        });

        function removeItemRow(btn) {
            $(btn).closest('tr').remove();
            if ($('#tblItems tbody tr').length === 0) {
                addNewItemRow();
            }
        }
    </script>
</body>
</html>