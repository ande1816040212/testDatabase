

$('#DDLUserType').on('change', function () {
    //new 
    $('input:not([type="submit"]):not([type="hidden"])').val("");

    switch ($(this).val()) {
        case "":
            $('.client, .staff, .student').slideUp();
            break;

        case "student":
            $('.client:not(.student), .staff:not(.student)').stop().slideUp();
            $(".student").slideDown();
            a = new Date();
            break;

        case "client":
            $('.staff:not(.client), .student:not(.client)').stop().slideUp();
            $(".client").slideDown();
            break;

        case "staff":
            $('.client:not(.staff), .student:not(.staff)').stop().slideUp();
            $(".staff").slideDown();
            break;
    } // end case


});

$('#TBLastName').on('change keydown paste input', function () {
    var type = $('#DDLUserType').val();
   
    if (type == 'student') {
        $('#TBEmail').val($('#TBUsername').val() + "@mymail.unisa.edu.au");
    }
    else if (type == 'staff') {
        $('#TBEmail').val($('#TBFirstName').val() + "." + $('#TBLastName').val() + "@unisa.edu.au");
    }
});

