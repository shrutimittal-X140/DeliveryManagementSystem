<%@ Page Title="Item Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemManagement.aspx.cs" Inherits="WebUI.ItemManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Matching UI CSS based on reference image -->
    <style>
        .page-header-title {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.5rem;
        }

        /* Outer Dark Card Container */
        .erp-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 10px;
            padding: 1.25rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.4);
        }

        /* Custom Dark ERP Table */
        .table-erp {
            width: 100%;
            background-color: transparent;
            color: #cbd5e1;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
        }

        .table-erp th {
            background-color: #0f172a;
            color: #94a3b8;
            border-bottom: 1px solid #1e293b;
            text-transform: uppercase;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            padding: 12px 16px;
        }

        .table-erp td {
            background-color: #0b1120;
            border-bottom: 1px solid #1e293b;
            padding: 14px 16px;
            vertical-align: middle;
            font-size: 0.9rem;
            color: #cbd5e1;
        }

        .table-erp tr:hover td {
            background-color: #0f172a;
        }

        /* Specific Cell Text Highlights */
        .td-code {
            color: #60a5fa !important;
            font-weight: 500;
        }

        .td-name {
            color: #ffffff !important;
            font-weight: 600;
        }

        /* Rounded Pill Badges */
        .badge-pill-custom {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            display: inline-block;
        }

        .badge-active {
            background-color: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .badge-inactive {
            background-color: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        /* Dark Modal Styling */
        .modal-content-dark {
            background-color: #0b1120;
            color: #cbd5e1;
            border: 1px solid #1e293b;
            border-radius: 10px;
        }

        .modal-content-dark .modal-header,
        .modal-content-dark .modal-footer {
            border-color: #1e293b;
        }

        .modal-content-dark .modal-title {
            color: #ffffff;
            font-weight: 600;
        }

        .form-control-dark {
            background-color: #0f172a;
            border: 1px solid #1e293b;
            color: #ffffff;
            border-radius: 6px;
        }

        .form-control-dark:focus {
            background-color: #0f172a;
            border-color: #10b981;
            color: #ffffff;
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.2);
        }

        .btn-erp-primary {
            background-color: #10b981;
            border-color: #10b981;
            color: #ffffff;
            font-weight: 600;
            border-radius: 6px;
            padding: 6px 16px;
        }

        .btn-erp-primary:hover {
            background-color: #059669;
            border-color: #059669;
            color: #ffffff;
        }
      
.btn-action-icon {
    width: 36px;
    height: 36px;
    padding: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 6px;
    background-color: transparent;
    transition: all 0.2s ease-in-out;
}

.btn-action-edit {
    border: 1px solid #06b6d4;
    color: #06b6d4;
}
.btn-action-edit:hover {
    background-color: rgba(6, 182, 212, 0.15);
    color: #22d3ee;
    border-color: #22d3ee;
}

.btn-action-delete {
    border: 1px solid #ef4444;
    color: #ef4444;
}
.btn-action-delete:hover {
    background-color: rgba(239, 68, 68, 0.15);
    color: #f87171;
    border-color: #f87171;
}
    </style>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="page-header-title">Item Management</h2>
            <button type="button" class="btn btn-erp-primary" onclick="openItemModal()">+ Add New Item</button>
        </div>

        <!-- Table Outer Card -->
        <div class="erp-card">
            <div class="table-responsive">
                <table id="tblItems" class="table table-erp">
                    <thead>
                        <tr>
                            <th>ITEM ID</th>
                            <th>ITEM CODE</th>
                            <th>ITEM NAME</th>
                            <th>UNIT PRICE</th>
                            <th>STATUS</th>
                            <th style="width: 140px; text-align: right;">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add/Edit Modal -->
    <div class="modal fade" id="itemModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content modal-content-dark">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Item Details</h5>
                    <button type="button" class="close text-white" data-bs-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="txtItemId" value="0" />
                    <div class="form-group mb-3">
                        <label class="text-light">Item Code</label>
                        <input type="text" id="txtItemCode" class="form-control form-control-dark" placeholder="e.g. ITM-001" />
                    </div>
                    <div class="form-group mb-3">
                        <label class="text-light">Item Name</label>
                        <input type="text" id="txtItemName" class="form-control form-control-dark" placeholder="e.g. Box Container" />
                    </div>
                    <div class="form-group mb-3">
                        <label class="text-light">Unit Price</label>
                        <input type="number" step="0.01" id="txtUnitPrice" class="form-control form-control-dark" placeholder="0.00" />
                    </div>
                    <div class="form-check mb-2">
                        <input type="checkbox" id="chkIsActive" class="form-check-input" checked />
                        <label class="form-check-label text-light" for="chkIsActive">Is Active</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-erp-primary btn-sm" onclick="saveItem()">Save Item</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        var allItems = [];

        $(document).ready(function () {
            loadItems();
        });

        function loadItems() {
            $.ajax({
                type: "POST",
                url: "WebServices/ItemService.asmx/GetItems",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var data = res.d.data;
                    allItems = data || [];
                    var rows = '';
                    if (data && data.length > 0) {
                        $.each(data, function (i, item) {
                         
                            var editSvg = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>';
                            var deleteSvg = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>';

                            rows += '<tr>' +
                                '<td>' + item.ItemId + '</td>' +
                                '<td class="td-code">' + item.ItemCode + '</td>' +
                                '<td class="td-name">' + item.ItemName + '</td>' +
                                '<td>$' + item.UnitPrice.toFixed(2) + '</td>' +
                                '<td>' + (item.IsActive ? '<span class="badge-pill-custom badge-active">Active</span>' : '<span class="badge-pill-custom badge-inactive">Inactive</span>') + '</td>' +
                                '<td style="text-align: right;">' +
                                '<button type="button" title="Edit" class="btn btn-action-icon btn-action-edit mr-2" onclick="editItem(' + item.ItemId + ')">' + editSvg + '</button>' +
                                '<button type="button" title="Delete" class="btn btn-action-icon btn-action-delete" onclick="deleteItem(' + item.ItemId + ')">' + deleteSvg + '</button>' +
                                '</td>' +
                                '</tr>';
                        });
                    } else {
                        rows = '<tr><td colspan="6" class="text-center text-muted py-4">No items found. Click "+ Add New Item" to create one.</td></tr>';
                    }
                    $('#tblItems tbody').html(rows);
                }
            });
        }

        function openItemModal() {
            $('#modalTitle').text('Add New Item');
            $('#txtItemId').val(0);
            $('#txtItemCode').val('');
            $('#txtItemName').val('');
            $('#txtUnitPrice').val('');
            $('#chkIsActive').prop('checked', true);
            new bootstrap.Modal(document.getElementById('itemModal')).show();
        }

        function editItem(id) {
            $.ajax({
                type: "POST",
                url: "WebServices/ItemService.asmx/GetItemById",
                data: JSON.stringify({ itemId: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var item = response.d;

                    if (!item.success) {
                        alert(item.message || "Could not load item.");
                        return;
                    }

                    $('#modalTitle').text('Edit Item');
                    $('#txtItemId').val(item.ItemId);
                    $('#txtItemCode').val(item.ItemCode);
                    $('#txtItemName').val(item.ItemName);
                    $('#txtUnitPrice').val(item.UnitPrice);
                    $('#chkIsActive').prop('checked', item.IsActive);
                    new bootstrap.Modal(document.getElementById('itemModal')).show();
                },
                error: function (xhr) {
                    console.error(xhr.responseText);
                    alert("Error loading item details.");
                }
            });
        }

        function saveItem() {
            var payload = {
                itemId: parseInt($('#txtItemId').val()),
                itemCode: $('#txtItemCode').val(),
                itemName: $('#txtItemName').val(),
                unitPrice: parseFloat($('#txtUnitPrice').val()) || 0,
                isActive: $('#chkIsActive').is(':checked')
            };

            $.ajax({
                type: "POST",
                url: "WebServices/ItemService.asmx/SaveItem",
                data: JSON.stringify(payload),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    if (res.d.success) {
                        var modalEl = document.getElementById('itemModal');
                        var modalInstance = bootstrap.Modal.getInstance(modalEl);
                        if (modalInstance) modalInstance.hide();
                        loadItems();
                    } else {
                        alert(res.d.message);
                    }
                }
            });
        }

        function deleteItem(id) {
            if (confirm("Are you sure you want to delete this item?")) {
                $.ajax({
                    type: "POST",
                    url: "WebServices/ItemService.asmx/DeleteItem",
                    data: JSON.stringify({ itemId: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        if (res.d.success) {
                            loadItems();
                        } else {
                            alert(res.d.message);
                        }
                    }
                });
            }
        }
    </script>
</asp:Content>