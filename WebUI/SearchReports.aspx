<%@ Page Title="Search & Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SearchReports.aspx.cs" Inherits="WebUI.SearchReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

       <style>
        .reports-wrapper {
            display: flex;
            flex-direction: column;
            min-height: calc(100vh - 120px); 
        }

        .reports-toolbar {
            background-color: #1a1d23;
            border: 1px solid #343a40;
            border-radius: 0.5rem;
            padding: 0.85rem 1rem;
            margin-bottom: 1rem;
        }

        .reports-toolbar .form-control,
        .reports-toolbar .form-select {
            height: 40px;
            width: auto;
        }

        .reports-toolbar .input-icon-wrap {
            position: relative;
            flex: 0 1 280px;
        }

        .reports-toolbar .input-icon-wrap input {
            width: 100%;
            padding-left: 34px;
        }

        .reports-toolbar .input-icon-wrap i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            pointer-events: none;
        }

        .reports-toolbar d-flex justify-content-between align-items-center flex-wrap gap-2{
            padding-top: 50px;
            height:150px;
        }
        .reports-toolbar .filter-select-wrap {
            position: relative;
            flex: 0 0 200px;
        }

        .reports-toolbar .filter-select-wrap select {
            width: 100%;
            padding-left: 34px;
        }

        .reports-toolbar .filter-select-wrap i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            pointer-events: none;
            z-index: 2;
        }

        .reports-table-container {
            margin-top: auto;
        }

        .reports-table-container table {
            margin-bottom: 0;
        }

        .reports-table-container thead th {
            border-bottom: 1px solid #343a40;
            letter-spacing: 0.03em;
        }
    </style>

    <div class="container-fluid px-4 py-3 reports-wrapper">

        <asp:Label ID="lblMessage" runat="server" Visible="false" class="d-block mb-3"></asp:Label>

        <div class="reports-toolbar d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div class="d-flex gap-2 align-items-center flex-wrap">
                <div class="filter-select-wrap">
                    <i class="bi bi-"></i>
                    <asp:TextBox ID="txtKeywords" runat="server" CssClass="form-control bg-dark text-white border-secondary"></asp:TextBox>
                </div>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select bg-dark text-white border-secondary">
                    <asp:ListItem Value="">All Statuses</asp:ListItem>  
                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    <asp:ListItem Value="In Transit">In Transit</asp:ListItem>
                    <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                    <asp:ListItem Value="Failed">Failed</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnApplyFilterServer" runat="server" Text="Search" CssClass="btn btn-success fw-bold px-4" OnClick="btnApplyFilterServer_Click" />
            </div>
            <div>
                <asp:Button ID="btnExport" runat="server" Text="Export CSV" CssClass="btn btn-outline-light" OnClick="btnExport_Click" />
            </div>
        </div>

        <div class="reports-table-container table-responsive rounded-3 border border-secondary">
            <table class="table table-dark table-hover align-middle mb-0">
                <thead>
                    <tr class="text-uppercase small text-muted">
                        <th>Order ID</th>
                        <th>Customer Name</th>
                        <th>Driver Name</th>
                        <th>Delivery Address</th>
                        <th>Created Date</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptReportsTable" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="fw-semibold text-white"><%# Eval("OrderId") %></td>
                                <td><%# Eval("CustomerName") == DBNull.Value ? "N/A" : Eval("CustomerName") %></td>
                                <td><%# Eval("DriverName") == DBNull.Value ? "N/A" : Eval("DriverName") %></td>
                                <td><%# Eval("DeliveryAddress") == DBNull.Value ? "N/A" : Eval("DeliveryAddress") %></td>
                                <td><%# Eval("CreatedDate", "{0:yyyy-MM-dd HH:mm}") %></td>
                                <td>
                <span class='badge px-2 py-1 rounded-2 <%# GetStatusBadgeClass(Convert.ToString(Eval("CurrentStatus"))) %>'>
                    <%# Eval("CurrentStatus") %>
                </span>
                                </td>
                                <td class="text-end">
                                 <button type="button" class="btn btn-sm btn-outline-success me-1" 
        onclick='openEditReportModal(
            <%# Eval("OrderId") %>, 
            <%# Eval("CustomerId") == DBNull.Value ? 0 : Eval("CustomerId") %>, 
            <%# Eval("DriverId") == DBNull.Value ? 0 : Eval("DriverId") %>, 
            <%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("CustomerName")), true) %>, 
            <%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("DriverName")), true) %>, 
            <%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("DeliveryAddress")), true) %>)'>
    Edit
</button>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit Record Modal -->
    <div class="modal fade" id="editReportModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark text-white border-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title">Edit Report Record</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="modalOrderId" />
                    <input type="hidden" id="modalCustomerId" />
                    <input type="hidden" id="modalDriverId" />
                    <div class="mb-3">
                        <label class="form-label">Customer Name</label>
                        <input type="text" id="modalCustomerName" class="form-control bg-dark text-white border-secondary" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Driver Name</label>
                        <input type="text" id="modalDriverName" class="form-control bg-dark text-white border-secondary" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Delivery Address</label>
                        <input type="text" id="modalAddress" class="form-control bg-dark text-white border-secondary" />
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" onclick="saveReportUpdate()">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openEditReportModal(orderId, customerId, driverId, custName, driverName, address) {
            document.getElementById('modalOrderId').value = orderId || 0;
            document.getElementById('modalCustomerId').value = customerId || 0;
            document.getElementById('modalDriverId').value = driverId || 0;
            document.getElementById('modalCustomerName').value = (custName === 'N/A' || !custName) ? '' : custName;
            document.getElementById('modalDriverName').value = (driverName === 'N/A' || !driverName) ? '' : driverName;
            document.getElementById('modalAddress').value = (address === 'N/A' || !address) ? '' : address;

            var modalElement = document.getElementById('editReportModal');
            var modal = bootstrap.Modal.getOrCreateInstance(modalElement);
            modal.show();
        }

        function saveReportUpdate() {
            var payload = JSON.stringify({
                orderId: parseInt(document.getElementById('modalOrderId').value) || 0,
                customerId: parseInt(document.getElementById('modalCustomerId').value) || 0,
                driverId: parseInt(document.getElementById('modalDriverId').value) || 0,
                customerName: $.trim($('#modalCustomerName').val()),
                driverName: $.trim($('#modalDriverName').val()),
                address: $.trim($('#modalAddress').val())
            });

            $.ajax({
                type: "POST",
                url: "WebServices/ReportService.asmx/UpdateRecord",
                data: JSON.stringify(payload),
                contentType: "application/json ; charset = utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.hasOwnProperty('d') ? response.d : response;
                    if (data.success) {
                        alert('record updated successfully');
                        location.reload();
                    } else {
                        alert('server Response:' + data.message);
                    }
                },
                error: function (xhr, status, error) {
                    var errDetail = "HTTP" + xhr.status + " - " + error;
                    if (xhr.responseJSON && xhr.responseJSON.Message) {
                        errDetail += "\nDetails: " + xhr.responseJSON.Message;
                    } else if (xhr.responseText) {
                        errorDetail += "\nRaw Error: " + xhr.responseText.substring(0, 300);
                    }
                    alert("Error: " + errDetail);
                }
            });
        }                
    </script>
</asp:Content>