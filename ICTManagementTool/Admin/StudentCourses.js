$(document).ready(function () {

    validateButton();
    typeChange();
});

function validateButton() {

    if ($(".allCourses").prop("selectedIndex") != 0 && $(".allStudents").prop("selectedIndex") != 0)
    {
        $(".submitButton").prop("disabled", false);
    }
    else
    {
        $(".submitButton").prop("disabled", true);
    }
}

function typeChange() {

    $(".manualDiv").slideUp();
    $(".excelDiv").slideUp();
   


    switch ($(".userTypeSelect").val()) {
            //manual
        case "manual":
            $(".manualDiv").slideDown();
            break;

            //excel
        case "excel":
            $(".excelDiv").slideDown();
            break;

    }
}


$(".markInput").on('change keydown paste input', function () {
    var markVal = $(".markInput").val();
    if (markVal == "") {
        //value is empty
        $(".gradeInput").val("");
    }
    else if (!Number.isNaN(markVal)) {
        //is a number
        if (markVal > 0 && markVal < 40)
            $(".gradeInput").val("F2");
        else if (markVal < 50)
            $(".gradeInput").val("F1");
        else if (markVal < 55)
            $(".gradeInput").val("P2");
        else if (markVal < 65)
            $(".gradeInput").val("P1");
        else if (markVal < 75) 
            $(".gradeInput").val("C");
        else if (markVal < 85)
            $(".gradeInput").val("D");
        else if (markVal <= 100) 
            $(".gradeInput").val("HD");
        else
            $(".gradeInput").val("");
    }
    else {
        //value is NaN
        $(".gradeInput").val("");
    }
});