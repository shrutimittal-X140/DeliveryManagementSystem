$(document).ready(function () {

    // ---------- LOGIN ----------
    $("#btnLogin").on("click", function () {
        var username = $("#txtUsername").val().trim();
        var password = $("#txtPassword").val().trim();

        hideError();

        if (!username || !password) {
            showError("Please enter both Username and Password.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "WebServices/AuthService.asmx/Login",
            data: JSON.stringify({ username: username, password: password }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var result = response.d;
                if (result.success) {
                    window.location.href = result.redirect;
                } else {
                    showError(result.message);
                }
            },
            error: function () {
                showError("Something went wrong. Please try again.");
            }
        });
    });

    function showError(msg) {
        $("#lblMessage").text(msg);
        $("#pnlError").show();
    }

    function hideError() {
        $("#pnlError").hide();
    }


    $("#btnRegister").on("click", function () {
        var fullName = $("#txtFullName").val().trim();
        var username = $("#txtUsername").val().trim();
        var password = $("#txtPassword").val().trim();
        var roleId = parseInt($("#ddlRole").val());

        $("#lblMessage").text("");

        if (!fullName || !username || !password || !roleId) {
            $("#lblMessage").css("color", "#ef4444").text("Please fill in all mandatory fields including Role.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "WebServices/AuthService.asmx/Register",
            data: JSON.stringify({
                fullName: fullName,
                username: username,
                password: password,
                roleId: roleId
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var result = response.d;
                if (result.success) {
                    $("#lblMessage").css("color", "#22c55e").text(result.message);
                    setTimeout(function () {
                        window.location.href = "Login.aspx";
                    }, 1200);
                } else {
                    $("#lblMessage").css("color", "#ef4444").text(result.message);
                }
            },
            error: function () {
                $("#lblMessage").css("color", "#ef4444").text("Something went wrong. Please try again.");
            }
        });
    });

});