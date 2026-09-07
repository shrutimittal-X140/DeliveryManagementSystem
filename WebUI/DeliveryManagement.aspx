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
            background-color: #111827 !important;
            border: 1px solid #374151 !important;
            border-radius: 6px !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            overflow: hidden !important;
            margin-bottom: 0 !important;
        }

        .table-dark-custom th {
            background-color: #1a2332 !important;
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

        .badge-pending { background-color: #f59e0b; color: #000; padding: 4px 8px; border-radius: 4px; font-weight: 600; }
        .badge-out { background-color: #3b82f6; color: #fff; padding: 4px 8px; border-radius: 4px; font-weight: 600; }
        .badge-delivered { background-color: var(--accent-green); color: #000; padding: 4px 8px; border-radius: 4px; font-weight: 600; }
        .badge-failed { background-color: #ef4444; color: #fff; padding: 4px 8px; border-radius: 4px; font-weight: 600; }
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
                                    <th style="width: 30%;">Item Code</th>
                                    <th style="width: 45%;">Item Name</th>
                                    <th style="width: 15%;">Quantity</th>
                                    <th style="width: 10%;">Action</th>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/bootstrap-table@1.22.1/dist/bootstrap-table.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        loadDropdownsOnly();
        addNewItemRow();
        initDeliveriesTable();
    });

    function loadDropdownsOnly() {
        $.ajax({
            type: "POST",
            url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/GetInitialData") %>',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var res = response.d;
                if (!res.success) {
                    alert("Error loading data: " + res.message);
                    return;
                }
                populateDropdown($('#<%= ddlCustomer.ClientID %>'), res.customers, "CustomerId", "CustomerName");
                populateDropdown($('#<%= ddlDriver.ClientID %>'), res.drivers, "DriverId", "DriverName");
            },
            error: function (xhr) {
                console.error("AJAX Error details: ", xhr.responseText);
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
                sortable: false,
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
        var status = value || "";
        var badgeClass = "badge bg-secondary";
        var s = status.trim().toLowerCase();
        if (s === "pending") badgeClass = "badge-pending";
        else if (s === "out for delivery") badgeClass = "badge-out";
        else if (s === "delivered") badgeClass = "badge-delivered";
        else if (s === "failed") badgeClass = "badge-failed";
        return '<span class="' + badgeClass + '">' + status + '</span>';
    }

    function deliveryActionsFormatter(value, row, index) {
        var deliveryId = value;
        return '<button type="button" class="btn btn-sm btn-outline-info me-1" onclick="loadDeliveryForEdit(' + deliveryId + ')"><i class="fa-solid fa-pen-to-square"></i></button>' +
            '<button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteDeliveryRecord(' + deliveryId + ')"><i class="fa-solid fa-trash-can"></i></button>';
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
                alert(res.message);
                if (res.success) {
                    resetFormFields();
                    $('#tblDeliveries').bootstrapTable('refresh');
                }
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

    function addNewItemRow(itemCode, itemName, quantity) {
        var codeValue = itemCode || "";
        var nameValue = itemName || "";
        var qtyValue = quantity || 1;

        var rowHtml = `<tr>
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

    function removeItemRow(btn) {
        $(btn).closest('tr').remove();
        if ($('#tblItems tbody tr').length === 0) {
            addNewItemRow();
        }
    }
</script>
</body>
</html>