<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebUI.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Account - Delivery System</title>
    <!-- Bootstrap 5 CSS & FontAwesome Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <style>
        body {
            background-color: #080a14;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 3rem 1.5rem;
        }

        .register-wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
        }

        /* Increased max-width to 680px for a wide, spacious card layout */
        .register-card {
            background-color: #0b0e1b;
            border: 1px solid #1e293b;
            border-radius: 24px;
            padding: 3.5rem 4rem;
            width: 100%;
            max-width: 680px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.75);
        }

        .register-icon-badge {
            width: 80px;
            height: 80px;
            background: rgba(34, 197, 94, 0.12);
            border: 2px solid #22c55e;
            border-radius: 22px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #22c55e;
            font-size: 2.2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0 25px rgba(34, 197, 94, 0.25);
        }

        .register-title {
            color: #ffffff;
            font-weight: 800;
            font-size: 2.25rem;
            letter-spacing: -0.025em;
            margin-bottom: 0.35rem;
        }

        .register-subtitle {
            color: #94a3b8;
            font-size: 1rem;
            margin-bottom: 2.5rem;
        }

        .form-label-custom {
            color: #cbd5e1;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            margin-bottom: 0.55rem;
            display: block;
        }

        .form-control-custom, .form-select-custom {
            background-color: #13192e;
            border: 1px solid #1e293b;
            color: #ffffff;
            border-radius: 12px;
            padding: 0.95rem 1.25rem;
            font-size: 1rem;
            transition: all 0.2s ease;
            width: 100%;
        }

        .form-control-custom:focus, .form-select-custom:focus {
            background-color: #13192e;
            border-color: #22c55e;
            color: #ffffff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.25);
        }

        /* Custom dropdown arrow for dark theme */
        .form-select-custom {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2394a3b8' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1.25rem center;
            background-size: 16px 12px;
            appearance: none;
        }

        .btn-neon-block {
            background-color: #22c55e;
            color: #0b0e1b;
            font-weight: 700;
            font-size: 1.1rem;
            padding: 1rem;
            border-radius: 12px;
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
            box-shadow: 0 10px 25px rgba(34, 197, 94, 0.35);
        }

        .register-footer-text {
            color: #94a3b8;
            font-size: 0.95rem;
            margin-top: 2.25rem;
            border-top: 1px solid #1e293b;
            padding-top: 1.5rem;
        }

        .register-footer-text a {
            color: #22c55e;
            font-weight: 700;
            text-decoration: none;
        }

        .register-footer-text a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-wrapper">
            <div class="register-card text-center">
                <!-- Header Icon Badge -->
                <div class="register-icon-badge">
                    <i class="fa-solid fa-user-plus"></i>
                </div>

                <h3 class="register-title">Create Account</h3>
                <p class="register-subtitle">Sign up to access the delivery management system</p>

                <!-- Status Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 text-start small fw-bold"></asp:Label>

                <div class="text-start mb-3">
                    <label class="form-label-custom">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control-custom" placeholder="e.g. John Doe" Required="true"></asp:TextBox>
                </div>

                <div class="text-start mb-3">
                    <label class="form-label-custom">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control-custom" placeholder="Choose a username" Required="true"></asp:TextBox>
                </div>

                <div class="text-start mb-3">
                    <label class="form-label-custom">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control-custom" placeholder="Enter password" Required="true"></asp:TextBox>
                </div>

                <div class="text-start mb-4">
                    <label class="form-label-custom">Account Role</label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
    <asp:ListItem Value="1">Admin</asp:ListItem>
    <asp:ListItem Value="2">Super Admin</asp:ListItem>
</asp:DropDownList>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Register Account" CssClass="btn-neon-block" OnClick="btnRegister_Click" />

                <div class="register-footer-text text-center">
                    Already have an account? <a href="Login.aspx">Sign In</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>