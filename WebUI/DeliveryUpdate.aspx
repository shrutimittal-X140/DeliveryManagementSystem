<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryUpdate.aspx.cs" Inherits="WebUI.DeliveryUpdate" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Delivery Update - DeliveryERP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                    <span class="text-white small">
                        <i class="fa-regular fa-user-circle me-1"></i> <%= Session["Username"] %> 
                    </span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-danger btn-sm" OnClick="btnLogout_Click" />
                </div>
            </div>
        </nav>

        <div class="container pb-5">
            <div id="pnlAlert" class="alert alert-dismissible fade show col-md-8 mx-auto mb-4 d-none" role="alert">
                <span id="lblAlert"></span>
                <button type="button" class="btn-close" onclick="$('#pnlAlert').addClass('d-none');"></button>
            </div>

            <div class="erp-card shadow-lg col-md-8 mx-auto">
                <div class="erp-card-header text-center py-3">
                    <i class="fa-solid fa-pen-to-square text-success me-2"></i>Update Operational Delivery Status
                </div>
                <div class="card-body p-4">
                    
                    <!-- Delivery Selection Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Select Delivery Order</label>
                        <select id="ddlDeliveries" class="form-select"></select>
                    </div>

                    <!-- Status Workflow Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Status</label>
                        <select id="ddlStatus" class="form-select">
                            <option value="Pending">Pending</option>
                            <option value="Out For Delivery">Out For Delivery</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Failed">Failed</option>
                        </select>
                    </div>

                    <!-- Delivery Notes -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Update Delivery Notes</label>
                        <textarea id="txtNotes" rows="3" class="form-control" placeholder="Enter delivery comments or progress notes..."></textarea>
                    </div>

                    <!-- Conditional Failure Reason Panel -->
                    <div id="pnlFailure" class="mb-3 d-none">
                        <label class="form-label text-danger fw-bold">Failure Reason (Required for Failed status)</label>
                        <textarea id="txtFailureReason" rows="2" class="form-control border-danger" placeholder="e.g. Customer not available, Incorrect address..."></textarea>
                    </div>

                    <!-- Status History Info -->
                    <div class="mb-4 p-3" style="background-color: var(--input-bg); border-radius: 8px; border: 1px solid var(--input-border);">
                        <span class="fw-bold" style="color: var(--text-main); font-size: 0.9rem;">
                            <i class="fa-regular fa-clock me-1 text-success"></i>Delivered Date/Time:
                        </span>
                        <span id="lblDeliveredAt" class="text-success ms-2 fw-bold">N/A</span>
                    </div>

                    <button type="button" id="btnUpdateStatus" class="btn btn-emerald w-100">Record Status Change</button>
                </div>
            </div>
        </div>
    </form>

    <script>
        $(document).ready(function () {
            loadDeliveriesDropdown(0);

            $('#ddlDeliveries').on('change', function () {
                var selectedId = $(this).val();
                if (selectedId && selectedId > 0) {
                    loadDeliveryRecord(selectedId);
                }
            });

            $('#ddlStatus').on('change', function () {
                toggleFailurePanel($(this).val());
            });

            $('#btnUpdateStatus').on('click', function () {
                updateDeliveryStatus();
            });
        });

        function showAlert(message, type) {
            $('#lblAlert').text(message);
            $('#pnlAlert').removeClass().addClass('alert alert-' + type + ' alert-dismissible fade show col-md-8 mx-auto mb-4');
        }

        function toggleFailurePanel(status) {
            if (status === 'Failed') {
                $('#pnlFailure').removeClass('d-none');
            } else {
                $('#pnlFailure').addClass('d-none');
            }
        }

        function loadDeliveriesDropdown(selectDeliveryId) {
            $.ajax({
                type: "POST",
                url: "DeliveryUpdateService.asmx/GetDeliveriesDropdown",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var r = res.d;
                    if (r.redirect) {
                        window.location.href = "Login.aspx";
                        return;
                    }
                    if (r.success) {
                        var $ddl = $('#ddlDeliveries');
                        $ddl.empty();
                        $.each(r.data, function (i, item) {
                            $ddl.append($('<option>', { value: item.Value, text: item.Text }));
                        });

                        if (selectDeliveryId > 0) {
                            $ddl.val(selectDeliveryId);
                        }

                        if ($ddl.val()) {
                            loadDeliveryRecord($ddl.val());
                        }
                    }
                }
            });
        }

        function loadDeliveryRecord(deliveryId) {
            $.ajax({
                type: "POST",
                url: "DeliveryUpdateService.asmx/GetDeliveryRecord",
                data: JSON.stringify({ deliveryId: parseInt(deliveryId) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var r = res.d;
                    if (r.redirect) {
                        window.location.href = "Login.aspx";
                        return;
                    }
                    if (r.success) {
                        $('#ddlStatus').val(r.currentStatus);
                        $('#txtNotes').val(r.deliveryNotes);
                        $('#txtFailureReason').val(r.failureReason);
                        $('#lblDeliveredAt').text(r.deliveredAt);
                        toggleFailurePanel(r.currentStatus);
                    } else {
                        showAlert(r.message, 'danger');
                    }
                }
            });
        }

        function updateDeliveryStatus() {
            var deliveryId = $('#ddlDeliveries').val();
            var status = $('#ddlStatus').val();
            var notes = $('#txtNotes').val();
            var failureReason = $('#txtFailureReason').val();

            if (!deliveryId) return;

            if (status === "Failed" && !$.trim(failureReason)) {
                showAlert("Please record a Failure Reason before marking the delivery as Failed.", "danger");
                return;
            }

            $.ajax({
                type: "POST",
                url: "DeliveryUpdateService.asmx/UpdateDeliveryStatus",
                data: JSON.stringify({
                    deliveryId: parseInt(deliveryId),
                    status: status,
                    notes: notes,
                    failureReason: failureReason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var r = res.d;
                    if (r.redirect) {
                        window.location.href = "Login.aspx";
                        return;
                    }
                    if (r.success) {
                        showAlert(r.message, "success");
                        loadDeliveriesDropdown(deliveryId);
                    } else {
                        showAlert(r.message, "danger");
                    }
                }
            });
        }
    </script>
</body>
</html>