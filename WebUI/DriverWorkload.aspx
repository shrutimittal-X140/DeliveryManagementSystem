<%@ Page Title="Driver Workload" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DriverWorkload.aspx.cs" Inherits="WebUI.DriverWorkload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background-color: #030712;
        }

        .workload-container {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .metric-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 12px;
            padding: 1.25rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .metric-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .metric-icon.green { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
        .metric-icon.amber { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .metric-icon.red { background: rgba(239, 68, 68, 0.15); color: #ef4444; }

        .metric-label { color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .metric-value { color: #ffffff; font-size: 1.4rem; font-weight: 800; display: block; }

        /* Main Workload Card */
        .workload-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 14px;
            padding: 1.75rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        }

        .driver-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid #1e293b;
        }

        .driver-row:last-child { border-bottom: none; }

        .driver-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #1e293b;
            color: #22c55e;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #334155;
        }

        .driver-name { color: #ffffff; font-weight: 700; font-size: 1.05rem; }
        .driver-sub { color: #94a3b8; font-size: 0.85rem; }

        .load-bar-track {
            width: 220px;
            height: 8px;
            background-color: #1e293b;
            border-radius: 4px;
            overflow: hidden;
        }

        .load-bar-fill {
            height: 100%;
            background-color: #22c55e;
            border-radius: 4px;
            transition: width 0.4s ease;
        }

        .load-bar-fill.warn { background-color: #f59e0b; }
        .load-bar-fill.high { background-color: #ef4444; }

        .active-count {
            font-size: 1.3rem;
            font-weight: 800;
            color: #ffffff;
            min-width: 75px;
            text-align: right;
        }

        @media (max-width: 640px) {
            .driver-row { flex-direction: column; align-items: flex-start; gap: 1rem; }
            .load-bar-track { width: 100%; }
        }
    </style>

    <div class="workload-container">
        <!-- Header -->
        <div class="mb-4">
            <h2 class="text-white fw-bold m-0">Driver Workload</h2>
            <p class="text-muted small">Real-time driver assignment and active capacity status.</p>
        </div>

        <!-- Metric Summaries -->
        <div class="metrics-grid">
            <div class="metric-card">
                <div class="metric-icon green"><i class="fa-solid fa-users"></i></div>
                <div>
                    <span class="metric-label">Total Drivers</span>
                    <span class="metric-value" id="lblTotalDrivers">0</span>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon amber"><i class="fa-solid fa-truck-fast"></i></div>
                <div>
                    <span class="metric-label">Active Orders</span>
                    <span class="metric-value" id="lblActiveOrders">0</span>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon red"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div>
                    <span class="metric-label">Overloaded</span>
                    <span class="metric-value" id="lblOverloaded">0</span>
                </div>
            </div>
        </div>

        <div class="workload-card" id="workloadContainer">
            <div class="text-center py-4 text-muted">
                <i class="fa-solid fa-spinner fa-spin me-2"></i>Loading driver workload...
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            loadDriverWorkload();
        });

        function loadDriverWorkload() {
            $.ajax({
                type: "POST",
                url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/GetDriverWorkload") %>',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;
                    if (!res || !res.success) {
                        $('#workloadContainer').html('<p class = "text-danger mb-0"><i class="fa-solid fa-circle-exclamation me-2"></i>' + (res ? res.message : 'Error loading data') + '</p>');
                        return;
                    }

                    if (!res.data || res.data.length === 0) {
                        $('#workloadContainer').html('<p class="text-muted mb-0"> No drivers registered in system.</p>');
                        return;
                    }

                    var totalDrivers = res.data.length;
                    var totalActive = 0;
                    var overloadedDrivers = 0;
                    var maxActive = Math.max.apply(null, res.data.map(function (d) {
                        return d.ActiveCount;
                    })) || 1;

                    var html = '';

                    $.each(res.data, function (i, d) {
                        totalActive += d.ActiveCount;
                        if (d.ActiveCount >= 5) overloadedDrivers++;

                        var pct = Math.round((d.ActiveCount / Math.max(maxActive, 5)) * 100);
                        var barClass = d.ActiveCount >= 5 ? 'high' : (d.ActiveCount >= 3 ? 'warn' : '');
                        var avatarLetter = (d.DriverName || 'D').charAt(0).toUpperCase();

                        html += '<div class="driver-row">' +
                            '  <div class="d-flex align-items-center gap-3">' +
                            '    <div class="driver-avatar">' + avatarLetter + '</div>' +
                            '    <div>' +
                            '      <div class="driver-name">' + d.DriverName + '</div>' +
                            '      <div class="driver-sub">' + d.DeliveredCount + ' delivered &middot; ' + d.TotalCount + ' total assigned</div>' +
                            '    </div>' +
                            '  </div>' +
                            '  <div class="d-flex align-items-center gap-3 w-xs-100 justify-content-between">' +
                            '    <div class="load-bar-track"><div class="load-bar-fill ' + barClass + '" style="width:' + Math.max(pct, 4) + '%;"></div></div>' +
                            '    <div class="active-count">' + d.ActiveCount + ' <span style="font-size:0.75rem; color:#64748b; font-weight:600;">Active</span></div>' +
                            '  </div>' +
                            '</div>';
                    });

                    $('#lblTotalDrivers').text(totalDrivers);
                    $('#lblActiveOrders').text(totalActive);
                    $('#lblOverloaded').text(overloadedDrivers);

                    $('#workloadContainer').html(html);
                }, 
                error: function () {
                    $('#workloadContainer').html('<p class="text-danger mb-0"><i class="fa-solid fa-wifi me-2"></i>Failed to load driver workload from server.</p>');
                }
            });
        }
    </script>
</asp:Content>