
$(document).ready(function() {
    $("#installation-btn-l").click(function() {
        $("#installation-os-c").fadeIn();
        $("#installation-os-u").hide(0);
    });

    $("#installation-btn-r").click(function() {
        $("#installation-os-c").hide(0);
        $("#installation-os-u").fadeIn();
    });

});
