# Delivery Management System (DeliveryERP)

An enterprise-grade, web-based logistics and delivery management application built with ASP.NET Web Forms, C#, SQL Server, and jQuery / Bootstrap. The system provides real-time shipment tracking, driver workload distribution, automated email notifications, and comprehensive order lifecycle management.

---

# Key Features

Public Shipment Tracking:
  * Publicly accessible tracking interface (`TrackDelivery.aspx`) requiring no user authentication.
  * Real-time visual timeline showing order progression (`Pending` ? `Dispatched` ? `In Transit` ? `Delivered`).
  * Direct lookup by **Delivery ID**.

Delivery Lifecycle Management:
  * Complete CRUD operations for handling deliveries, items, and schedules.
  * Paginated, sortable, and searchable grid views for efficient data management.
  * Role-Based Access Control (RBAC) supporting `SuperAdmin`, `Admin`, and field users.

Driver & Workload Optimization:
  * Real-time monitoring of driver workload metrics (Active, Delivered, and Total assigned packages).
  * Automated driver assignment and route dispatching.

Automated Notifications:
  * Asynchronous email notifications dispatched automatically to customers when orders are marked as **Delivered**.

---

# Tech Stack & Prerequisites

# Frontend & UI
* ASP.NET Web Forms (Master Pages, ASPX)
* Bootstrap 5 / Modern CSS Design
* jQuery & AJAX (ASMX JSON integration)
* FontAwesome Icons

# Backend & Database
* Framework: .NET Framework 4.8 (C#)
* Architecture: N-Tier Architecture (WebUI, BusinessLayer BLL)
* Web Services: ASP.NET ASMX Web Services (`ScriptService` / JSON endpoints)
* Database: Microsoft SQL Server (ADO.NET)
