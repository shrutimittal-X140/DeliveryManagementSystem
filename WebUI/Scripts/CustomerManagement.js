function loadCustomers() {
    $.ajax({
        type: "POST",
        url: "WebServices/CustomerService.asmx/GetAllCustomers",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var result = response.d;  
            if (result.success) renderCustomerTable(result.data);
            else alert(result.message);
        },
        error: function (err) {
            console.error(err);
        }
    });
}

function saveCustomer(customer) {
    $.ajax({
        type: "POST",
        url: "WebServices/CustomerService.asmx/SaveCustomer",
        data: JSON.stringify({
            customerId: customer.CustomerId,
            customerCode: customer.CustomerCode,
            customerName: customer.CustomerName,
            contactPerson: customer.ContactPerson,
            phoneNumber: customer.PhoneNumber,
            email: customer.Email,
            deliveryAddress: customer.DeliveryAddress
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d.success) loadCustomers();
            else alert(response.d.message);
        }
    });
}
function deleteCustomer(el) {
    var customerId = $(el).data("id");
    if (!confirm("Delete this customer?")) return;
    $.ajax({
        type: "POST",
        url: "WebServices/CustomerService.asmx/DeleteCustomer",
        data: JSON.stringify({ customerId: customerId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d.success) {
                location.reload();
            } else {
                alert(response.d.message);
            }
        }
    });
}
function renderCustomerTable(data) {
    var rows = "";
    if (!data || data.length === 0) {
        rows = "<tr><td colspan='7' class='p-5 text-center text-secondary'>No customer records found. Click 'Add Customer' to get started.</td></tr>";
    } else {
        $.each(data, function (i, c) {
            rows += "<tr>" +
                "<td><span class='code-badge'>" + c.CustomerCode + "</span></td>" +
                "<td class='fw-semibold text-white'>" + c.CustomerName + "</td>" +
                "<td class='text-secondary'>" + c.ContactPerson + "</td>" +
                "<td>" + c.PhoneNumber + "</td>" +
                "<td><a href='mailto:" + c.Email + "' class='text-decoration-none text-emerald'>" + c.Email + "</a></td>" +
                "<td class='text-secondary'>" + c.DeliveryAddress + "</td>" +
                "<td class='text-end'><div class='d-inline-flex gap-1'>" +
                "<span class='btn btn-action-edit' data-id='" + c.CustomerId + "' onclick='editCustomer(this)'><i class=\"fa-solid fa-pen-to-square me-1\"></i>Edit</span> " +
                "<span class='btn btn-action-delete' data-id='" + c.CustomerId + "' onclick='deleteCustomer(this)'><i class=\"fa-solid fa-trash me-1\"></i>Delete</span>" +
                "</div></td>" +
                "</tr>";
        });
    }
    $("#customerTableBody").html(rows);
}
function editCustomer(el) {
    var customerId = $(el).data("id");
    window.location.href = "CustomerManagement.aspx? edit=" + customerId;
}
$(document).ready(function () { loadCustomers(); });

