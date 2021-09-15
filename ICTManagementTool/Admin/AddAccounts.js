$(document).ready(function () {

    multipleUserTypeChange();
});


function multipleUserTypeChange() {


    $(".divHeading").slideUp();
    $(".divStudent").slideUp();
    $(".divClient").slideUp();
    $(".divStaff").slideUp();
    $(".divControls").slideUp();

    switch ($(".userTypeSelect").val()) {
        case "":
            $(".divHeading").slideDown();
            break;

        case "student":
            $(".divStudent").slideDown();
            $(".divControls").slideDown();
            break;

        case "client":
            $(".divClient").slideDown();
            break;

        case "staff":
            $(".divStaff").slideDown();
            break;



    }
}