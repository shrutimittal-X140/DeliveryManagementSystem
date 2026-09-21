<%@ Page Title="Track Delivery" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TrackDelivery.aspx.cs" Inherits="WebUI.TrackDelivery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background-color: #030712;
        }

        .track-container {
            max-width: 720px;
            margin: 3rem auto;
            padding: 0 1rem;
        }

        .hero-title {
            color: #ffffff;
            font-size: 2rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .hero-subtitle {
            color: #9ca3af;
            font-size: 1rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .track-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 16px;
            padding: 2.25rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5), 0 8px 10px -6px rgba(0, 0, 0, 0.5);
        }

        .search-group {
            position: relative;
            display: flex;
            gap: 10px;
        }

        .track-input {
            background-color: #0f172a;
            border: 1px solid #334155;
            color: #ffffff !important;
            border-radius: 10px;
            padding: 0.85rem 1.2rem;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
        }

        .track-input::placeholder {
            color: #64748b;
        }

        .track-input:focus {
            background-color: #0f172a;
            border-color: #22c55e;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.25);
            outline: none;
        }

        .track-btn {
            background-color: #22c55e;
            border: none;
            color: #030712;
            font-weight: 700;
            font-size: 1rem;
            border-radius: 10px;
            padding: 0.85rem 2rem;
            transition: all 0.2s ease-in-out;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .track-btn:hover {
            background-color: #16a34a;
            color: #ffffff;
            transform: translateY(-1px);
        }

   
        .result-box {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #1e293b;
        }

     
        .timeline-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin: 2.5rem 0 2rem;
        }

        .timeline-steps::before {
            content: '';
            position: absolute;
            top: 18px;
            left: 10%;
            right: 10%;
            height: 4px;
            background-color: #1e293b;
            z-index: 0;
        }

        .step {
            position: relative;
            z-index: 1;
            text-align: center;
            flex: 1;
        }

        .step-dot {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #0f172a;
            border: 3px solid #1e293b;
            margin: 0 auto 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .step.active .step-dot {
            background-color: #22c55e;
            border-color: #22c55e;
            color: #030712;
            box-shadow: 0 0 15px rgba(34, 197, 94, 0.4);
        }

        .step.failed .step-dot {
            background-color: #ef4444;
            border-color: #ef4444;
            color: #ffffff;
            box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
        }

        .step-label {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 600;
        }

        .step.active .step-label { color: #ffffff; }
        .step.failed .step-label { color: #ef4444; }

        .details-grid {
            background-color: #0f172a;
            border: 1px solid #1e293b;
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.25rem;
        }

        @media (max-width: 576px) {
            .details-grid { grid-template-columns: 1fr; }
            .search-group { flex-direction: column; }
        }

        .detail-item {
            display: flex;
            flex-direction: column;
        }

        .detail-label {
            color: #64748b;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }

        .detail-value {
            color: #ffffff;
            font-weight: 600;
            font-size: 1rem;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 700;
            background-color: rgba(34, 197, 94, 0.15);
            color: #22c55e;
            width: fit-content;
        }

        .search-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1.5rem;
        }

        .result-grid {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 1.5rem;
            align-items: start;
        }

        @media (max-width: 900px) {
            .result-grid { grid-template-columns: 1fr; }
        }

        .map-card {
            background-color: #0b1120;
            border: 1px solid #1e293b;
            border-radius: 16px;
            padding: 1.25rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5), 0 8px 10px -6px rgba(0, 0, 0, 0.5);
        }

        .map-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #ffffff;
            font-weight: 700;
            font-size: 0.95rem;
            margin-bottom: 0.85rem;
            flex-wrap: nowrap;
            gap: 0.75rem;
        }

        .illustrative-tag {
            font-size: 0.65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            background-color: #0f172a;
            border: 1px solid #1e293b;
            padding: 3px 8px;
            border-radius: 20px;
        }

        .map-canvas {
            position: relative;
            width: 100%;
            aspect-ratio: 300 / 220;
            background: radial-gradient(circle at 30% 20%, #0f1a2e 0%, #060a14 70%);
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #1e293b;
        }

        .map-grid-svg {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
        }

        .map-pin {
            position: absolute;
            transform: translate(-50%, -100%);
            text-align: center;
            color: #94a3b8;
        }

        .map-pin i {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #0f172a;
            border: 2px solid #334155;
            font-size: 0.85rem;
            margin: 0 auto 4px;
        }

        .dest-pin i {
            color: #22c55e;
            border-color: #22c55e;
        }

        .pin-label {
            font-size: 0.65rem;
            font-weight: 600;
        }

        .map-marker {
            position: absolute;
            transform: translate(-50%, -50%);
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #030712;
            background-color: #22c55e;
            border-radius: 50%;
            font-size: 0.9rem;
            z-index: 2;
            transition: left 0.8s ease, top 0.8s ease;
            box-shadow: 0 0 20px rgba(34, 197, 94, 0.6);
        }

        .map-marker.marker-failed {
            background-color: #ef4444;
            box-shadow: 0 0 20px rgba(239, 68, 68, 0.6);
        }

        .marker-pulse {
            position: absolute;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(34, 197, 94, 0.5);
            animation: pulse 1.6s infinite ease-out;
        }

        .map-marker.marker-failed .marker-pulse {
            background-color: rgba(239, 68, 68, 0.5);
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.7; }
            100% { transform: scale(2.4); opacity: 0; }
        }

        .map-footer {
            margin-top: 0.85rem;
            padding-top: 0.85rem;
            border-top: 1px solid #1e293b;
            color: #cbd5e1;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .result-grid {
            align-items: stretch;
        }

        .track-card, .map-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .details-grid {
            margin-top: auto;
        }

        .detail-label {
            white-space: nowrap;
        }

        .detail-item {
            min-width: 0;
        }

        .map-header {
            flex-wrap: nowrap;
            gap: 0.75rem;
        }

        .map-header > span:first-child {
            white-space: nowrap;
            font-size: 1rem;
        }

        .illustrative-tag {
            white-space: nowrap;
            flex-shrink: 0;
        }

        .map-canvas {
            margin-top: 0.25rem;
        }

        .map-pin {
            padding-top: 6px;
        }

        .map-pin.dest-pin {
            top: 20% !important;
        }

        .map-pin.origin-pin {
            top: 80% !important;
        }

        .map-footer {
            margin-top: auto;
            padding-top: 0.85rem;
        }

        @media (min-width: 901px) {
            .map-card {
                justify-content: space-between;
            }
        }

    </style>

   <div class="track-container">
        <h1 class="hero-title">Track Your Shipment</h1>
        <p class="hero-subtitle">Enter your Delivery ID below to view real-time status and driver information.</p>

        <div class="search-card">
            <div class="search-group">
                <input type="number" id="txtTrackId" class="form-control track-input" placeholder="Enter Delivery ID (e.g. 26)" onkeypress="handleKeyPress(event)" />
                <button type="button" class="btn track-btn" onclick="trackDelivery()">
                    <i class="fa-solid fa-magnifying-glass"></i> Track
                </button>
            </div>
            <div id="trackError" class="alert alert-danger mt-3 mb-0" style="display:none; background-color: rgba(239, 68, 68, 0.1); border-color: #ef4444; color: #fca5a5; border-radius: 10px;"></div>
        </div>

        <div id="trackResult" class="result-grid" style="display:none;">

            <div class="track-card">
                <div class="timeline-steps" id="timelineSteps"></div>

                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label">Delivery #</span>
                        <span class="detail-value text-success fw-bold" id="resDeliveryNumber">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Status</span>
                        <span class="detail-value" id="resStatus">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Delivery Date</span>
                        <span class="detail-value" id="resDate">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Customer</span>
                        <span class="detail-value" id="resCustomer">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Assigned Driver</span>
                        <span class="detail-value" id="resDriver">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Delivery Address</span>
                        <span class="detail-value" id="resAddress">-</span>
                    </div>
                </div>
            </div>

            <div class="map-card">
                <div class="map-header">
                    <span><i class="fa-solid fa-route me-2"></i>Route Preview</span>
                    <span class="illustrative-tag">Illustrative view</span>
                </div>

                <div class="map-canvas">
                    <svg viewBox="0 0 300 220" class="map-grid-svg">
                        <defs>
                            <pattern id="gridPattern" width="20" height="20" patternUnits="userSpaceOnUse">
                                <path d="M 20 0 L 0 0 0 20" fill="none" stroke="#1e293b" stroke-width="1"/>
                            </pattern>
                        </defs>
                        <rect width="300" height="220" fill="url(#gridPattern)" />
                        <path id="routePath" d="M 40 180 C 100 60, 200 200, 260 40" fill="none" stroke="#334155" stroke-width="3" stroke-dasharray="6,6" />
                    </svg>

                    <div class="map-pin origin-pin" style="left: 13%; top: 82%;">
                        <i class="fa-solid fa-warehouse"></i>
                        <span class="pin-label">Origin</span>
                    </div>
                    <div class="map-pin dest-pin" style="left: 87%; top: 18%;">
                        <i class="fa-solid fa-location-dot"></i>
                        <span class="pin-label">Destination</span>
                    </div>
                    <div class="map-marker" id="mapMarker" style="left: 13%; top: 82%;">
                        <div class="marker-pulse"></div>
                        <i class="fa-solid fa-truck"></i>
                    </div>
                </div>

                <div class="map-footer">
                    <span id="mapStatusText">Awaiting tracking info...</span>
                </div>
            </div>

        </div>
    </div>

      <script>
          function handleKeyPress(e) {
              if (e.key === 'Enter') {
                  e.preventDefault();
                  trackDelivery();
              }
          }

          function trackDelivery() {
              var id = parseInt($('#txtTrackId').val());

              $('#trackError').hide();
              $('#trackResult').hide();

              if (!id || id <= 0) {
                  $('#trackError').text('Please enter a valid Delivery ID.').show();
                  return;
              }

              $.ajax({
                  type: "POST",
                  url: '<%= ResolveUrl("~/WebServices/DeliveryService.asmx/TrackDelivery") %>',
                data: JSON.stringify({ deliveryId: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var res = response.d;

                    if (!res.success) {
                        $('#trackError').text(res.message).show();
                        return;
                    }

                    $('#resDeliveryNumber').text(res.deliveryNumber);
                    $('#resStatus').text(res.currentStatus);
                    $('#resDate').text(res.deliveryDate || '-');
                    $('#resCustomer').text(res.customerName || '-');
                    $('#resDriver').text(res.driverName || '-');
                    $('#resAddress').text(res.deliveryAddress || '-');

                    renderTimeline(res.currentStatus);
                    updateMapVisual(res.currentStatus, res.deliveryAddress);
                    $('#trackResult').show();
                },
                error: function (xhr) {
                    console.error(xhr.responseText);
                    $('#trackError').text('Error communicating with server. Please try again.').show();
                }
            });
          }

          function renderTimeline(status) {
              var s = (status || '').trim().toLowerCase();
              var steps;

              if (s === 'failed') {
                  steps = [
                      { label: 'Pending', icon: 'fa-box', active: true },
                      { label: 'Out For Delivery', icon: 'fa-truck', active: true },
                      { label: 'Failed', icon: 'fa-triangle-exclamation', active: true, failed: true }
                  ];
              } else {
                  var order = ['pending', 'out for delivery', 'delivered'];
                  var currentIndex = order.indexOf(s);
                  steps = [
                      { label: 'Pending', icon: 'fa-box' },
                      { label: 'Out For Delivery', icon: 'fa-truck' },
                      { label: 'Delivered', icon: 'fa-circle-check' }
                  ];
                  steps.forEach(function (step, i) {
                      step.active = i <= currentIndex;
                  });
              }

              var html = '';
              steps.forEach(function (step) {
                  html += '<div class="step ' + (step.active ? 'active' : '') + (step.failed ? ' failed' : '') + '">' +
                      '<div class="step-dot"><i class="fa-solid ' + step.icon + '"></i></div>' +
                      '<div class="step-label">' + step.label + '</div>' +
                      '</div>';
              });

              $('#timelineSteps').html(html);
          }

          function updateMapVisual(status, address) {
              var s = (status || '').trim().toLowerCase();
              var pathEl = document.getElementById('routePath');
              var marker = $('#mapMarker');
              var pathLength = pathEl.getTotalLength();
              var progress = 0;
              var statusText = '';

              if (s === 'pending') {
                  progress = 0;
                  statusText = 'Package is prepared at the origin facility.';
              } else if (s === 'out for delivery') {
                  progress = 0.55;
                  statusText = 'On the way to ' + (address || 'the destination') + '.';
              } else if (s === 'delivered') {
                  progress = 1;
                  statusText = 'Delivered to ' + (address || 'the destination') + '.';
              } else if (s === 'failed') {
                  progress = 0.55;
                  statusText = 'Delivery attempt failed en route.';
              } else {
                  progress = 0;
                  statusText = 'Status: ' + status;
              }

              var point = pathEl.getPointAtLength(pathLength * progress);
              var svgRect = { w: 300, h: 220 };
              var leftPct = (point.x / svgRect.w) * 100;
              var topPct = (point.y / svgRect.h) * 100;

              marker.css({ left: leftPct + '%', top: topPct + '%' });
              marker.toggleClass('marker-failed', s === 'failed');

              $('#mapStatusText').text(statusText);
          }
    </script>
</asp:Content>