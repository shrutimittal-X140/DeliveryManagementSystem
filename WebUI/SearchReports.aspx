<%@ Page Title="Search & Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SearchReports.aspx.cs" Inherits="WebUI.SearchReports" EnableEventValidation="false" %>

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
        table.custom-table td * {
            color: #ffffff !important;
            background-color: #111827 !important;
        }

        table.custom-table th {
            background-color: #1f2937 !important;
            color: #ffffff !important;
            font-weight: 600 !important;
            border-bottom: 1px solid #374151 !important;
            padding: 12px 16px !important;
        }

        table.custom-table td {
            border-bottom: 1px solid #1f2937 !important;
            padding: 12px 16px !important;
        }

        .form-control-custom, .form-select-custom {
            background-color: #1f2937 !important;
            border: 1px solid #374151 !important;
            color: #ffffff !important;
        }

        .form-control-custom:focus, .form-select-custom:focus {
            background-color: #1f2937 !important;
            border-color: #10b981 !important;
            color: #ffffff !important;
        }

        .btn-theme-green {
            background-color: #10b981 !important;
            border-color: #10b981 !important;
            color: #ffffff !important;
        }

        .btn-theme-green:hover {
            background-color: #059669 !important;
            border-color: #059669 !important;
        }

        .text-theme-green {
            color: #10b981 !important;
        }

        .badge-pending { background-color: #f59e0b !important; color: #ffffff !important; }
        .badge-intransit { background-color: #3b82f6 !important; color: #ffffff !important; }
        .badge-delivered { background-color: #10b981 !important; color: #ffffff !important; }
        .badge-cancelled { background-color: #ef4444 !important; color: #ffffff !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="container-fluid px-4 py-3">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="page-header-title mb-1">
                    <i class="fa-solid fa-magnifying-glass me-2 text-theme-green"></i>Search & Analytics
                </h3>
                <p class="text-muted small mb-0">Search historical delivery logs and generate system analytics.</p>
            </div>
            <div>
                <asp:Button ID="btnExport" runat="server" Text="Export to CSV" CssClass="btn btn-outline-success fw-bold px-3 py-2" OnClick="btnExport_Click" />
            </div>
        </div>

        <asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
        
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnApplyFilter" CssClass="card card-metric p-4 mb-4 shadow-sm">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold text-light">Search Keywords</label>
                            <asp:TextBox ID="txtKeywords" runat="server" CssClass="form-control form-control-custom" 
                                Placeholder="Order ID, Customer, Driver..." AutoPostBack="false"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-light">Status Filter</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-custom">
                                <asp:ListItem Value="" Text="All Statuses" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                                <asp:ListItem Value="In Transit" Text="In Transit"></asp:ListItem>
                                <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                                <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <asp:Button ID="btnApplyFilter" runat="server" Text="Apply Filter" 
                                CssClass="btn btn-theme-green w-100 fw-bold" OnClick="btnApplyFilter_Click" />
                        </div>
                    </div>
                </asp:Panel>

                <div class="card card-custom shadow-lg">
                    <div class="table-responsive">
                        <asp:GridView ID="gvSearchResults" runat="server" AutoGenerateColumns="False"
                            CssClass="table custom-table align-middle" DataKeyNames="OrderId"
                            AllowPaging="True" PageSize="10"
                            OnPageIndexChanging="gvSearchResults_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="OrderId" HeaderText="Order ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                                <asp:BoundField DataField="DriverName" HeaderText="Driver Name" />
                                <asp:BoundField DataField="DeliveryAddress" HeaderText="Address" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="Date Created" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeCss(Convert.ToString(Eval("CurrentStatus"))) %>'>
                                            <%# Eval("CurrentStatus") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="p-4 text-center text-muted fs-6">No historical records match your search criteria.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnApplyFilter" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>