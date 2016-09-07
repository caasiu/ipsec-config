
$(document).ready(function() {

    //init
    $("#installation-os-u").hide();
    $("#build-kvm").hide();
    $("#transfer-kvm").hide();
    $("#startup-os-u").hide();

    $("#installation-btn-l").click(function() {
        $("#installation-os-u").hide(0);
        $("#installation-os-c").addClass('animated fadeInUp');
        $("#installation-os-c").show();
        $(this).addClass('btn-press');
        $("#installation-btn-r").removeClass('btn-press');
    });

    $("#installation-btn-r").click(function() {
        $("#installation-os-c").hide(0);
        $("#installation-os-u").addClass('animated fadeInUp');
        $("#installation-os-u").show();
        $(this).addClass('btn-press');
        $("#installation-btn-l").removeClass('btn-press');
    });

    $("#build-btn-l").click(function() {
        $("#build-openvz").hide(0);
        $("#build-kvm").addClass('animated fadeInUp');
        $("#build-kvm").show();
        $(this).addClass('btn-press');
        $("#build-btn-r").removeClass('btn-press');
    });

    $("#build-btn-r").click(function() {
        $("#build-kvm").hide(0);
        $("#build-openvz").addClass('animated fadeInUp');
        $("#build-openvz").show();
        $(this).addClass('btn-press');
        $("#build-btn-l").removeClass('btn-press');
    });

    $("#transfer-btn-l").click(function() {
        $("#transfer-openvz").hide(0);
        $("#transfer-kvm").addClass('animated fadeInUp');
        $("#transfer-kvm").show();
        $(this).addClass('btn-press');
        $("#transfer-btn-r").removeClass('btn-press');
    });

    $("#transfer-btn-r").click(function() {
        $("#transfer-kvm").hide(0);
        $("#transfer-openvz").addClass('animated fadeInUp');
        $("#transfer-openvz").show();
        $(this).addClass('btn-press');
        $("#transfer-btn-l").removeClass('btn-press');
    });

    $("#startup-btn-l").click(function() {
        $("#startup-os-u").hide(0);
        $("#startup-os-c").addClass('animated fadeInUp');
        $("#startup-os-c").show();
        $(this).addClass('btn-press');
        $("#startup-btn-r").removeClass('btn-press');
    });

    $("#startup-btn-r").click(function() {
        $("#startup-os-c").hide(0);
        $("#startup-os-u").addClass('animated fadeInUp');
        $("#startup-os-u").show();
        $(this).addClass('btn-press');
        $("#startup-btn-l").removeClass('btn-press');
    });

});
