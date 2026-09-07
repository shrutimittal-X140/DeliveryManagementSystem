<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebUI.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-wrapper {
            min-height: 75vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background-color: #0b0e1b;
            border: 1px solid #1e293b;
            border-radius: 20px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        .login-icon-badge {
            width: 70px;
            height: 70px;
            background: rgba(34, 197, 94, 0.12);
            border: 2px solid #22c55e;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #22c55e;
            font-size: 2rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 0 20px rgba(34, 197, 94, 0.2);
        }

        .login-title {
            color: #ffffff;
            font-weight: 800;
            font-size: 1.75rem;
            letter-spacing: -0.02em;
            margin-bottom: 0.35rem;
        }

        .login-subtitle {
            color: #94a3b8;
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }

        .form-label-custom {
            color: #cbd5e1;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control-custom {
            background-color: #13192e;
            border: 1px solid #1e293b;
            color: #ffffff;
            border-radius: 10px;
            padding: 0.8rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            width: 100%;
        }

        .form-control-custom:focus {
            background-color: #13192e;
            border-color: #22c55e;
            color: #ffffff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.25);
        }

        .btn-neon-block {
            background-color: #22c55e;
            color: #0b0e1b;
            font-weight: 700;
            font-size: 1rem;
            padding: 0.85rem;
            border-radius: 10px;
            border: none;
            width: 100%;
            transition: all 0.2s ease;
            margin-top: 1rem;
            cursor: pointer;
        }

        .btn-neon-block:hover {
            background-color: #16a34a;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 197, 94, 0.3);
        }

        .login-footer-text {
            color: #94a3b8;
            font-size: 0.9rem;
            margin-top: 1.75rem;
            border-top: 1px solid #1e293b;
            padding-top: 1.25rem;
        }

        .login-footer-text a {
            color: #22c55e;
            font-weight: 700;
            text-decoration: none;
        }

        .login-footer-text a:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-wrapper">
        <div class="login-card text-center">
            <!-- Delivery Truck Badge -->
            <div class="login-icon-badge">
                <i class="fa-solid fa-truck-fast"></i>
            </div>

            <h3 class="login-title">Delivery Management System</h3>
            <p class="login-subtitle">Sign in to your account</p>

            <!-- Error Message Alert -->
           <div id="pnlError" class="alert alert-danger py-2 px-3 small rounded-3 mb-3 text-start" style="display:none;" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i>
                <span id="lblMessage"></span>
           </div>

           <div class="text-start mb-3">
                <label class="form-label-custom">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" ClientIDMode="Static" CssClass="form-control-custom" placeholder="Enter your username"></asp:TextBox>
           </div>

           <div class="text-start mb-4">
                <label class="form-label-custom">Password</label>
    <asp:TextBox ID="txtPassword" runat="server" ClientIDMode="Static" TextMode="Password" CssClass="form-control-custom" placeholder="Enter your password"></asp:TextBox>
</div>

<button type="button" id="btnLogin" class="btn-neon-block">Sign In</button>
            <!-- Direct link to Register Page for new accounts -->
            <div class="login-footer-text text-center">
                Don't have an account? <a href="Register.aspx">Create One</a>
            </div>
        </div>
    </div>
    <script src="Scripts/auth.js"></script>
</asp:Content>