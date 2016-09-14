
$(document).ready(function() {

    //init
    $("#installation-os-u").hide();
    $("#build-kvm").hide();
    $("#transfer-kvm").hide();
    $("#startup-os-u").hide();

    function btnAnimate(divToHide, divToShow, btnActive, btnInactive) {
        $(divToHide).hide(0);
        $(divToShow).addClass('animated fadeInUp');
        $(divToShow).show();
        $(btnActive).addClass('btn-press');
        $(btnInactive).removeClass('btn-press');
    }

    $("#installation-btn-l").click(function() {
        btnAnimate("#installation-os-u", "#installation-os-c", "#installation-btn-l", "#installation-btn-r");
        btnAnimate("#startup-os-u", "#startup-os-c", "#startup-btn-l", "#startup-btn-r");
    });

    $("#installation-btn-r").click(function() {
        btnAnimate("#installation-os-c", "#installation-os-u", "#installation-btn-r", "#installation-btn-l");
        btnAnimate("#startup-os-c", "#startup-os-u", "#startup-btn-r", "#startup-btn-l");
    });

    $("#build-btn-l").click(function() {
        btnAnimate("#build-openvz", "#build-kvm", "#build-btn-l", "#build-btn-r");
        btnAnimate("#transfer-openvz", "#transfer-kvm", "#transfer-btn-l", "#transfer-btn-r");
    });

    $("#build-btn-r").click(function() {
        btnAnimate("#build-kvm", "#build-openvz", "#build-btn-r", "#build-btn-l");
        btnAnimate("#transfer-kvm", "#transfer-openvz", "#transfer-btn-r", "#transfer-btn-l");
    });

    $("#transfer-btn-l").click(function() {
        btnAnimate("#transfer-openvz", "#transfer-kvm", "#transfer-btn-l", "#transfer-btn-r");
        btnAnimate("#build-openvz", "#build-kvm", "#build-btn-l", "#build-btn-r");
    });

    $("#transfer-btn-r").click(function() {
        btnAnimate("#transfer-kvm", "#transfer-openvz", "#transfer-btn-r", "#transfer-btn-l");
        btnAnimate("#build-kvm", "#build-openvz", "#build-btn-r", "#build-btn-l");
    });

    $("#startup-btn-l").click(function() {
        btnAnimate("#startup-os-u", "#startup-os-c", "#startup-btn-l", "#startup-btn-r");
        btnAnimate("#installation-os-u", "#installation-os-c", "#installation-btn-l", "#installation-btn-r");
    });

    $("#startup-btn-r").click(function() {
        btnAnimate("#startup-os-c", "#startup-os-u", "#startup-btn-r", "#startup-btn-l");
        btnAnimate("#installation-os-c", "#installation-os-u", "#installation-btn-r", "#installation-btn-l");
    });

    $("#nav-ins").click(function() {
        $("#nav-ins span").toggleClass("clockwise");
    });

    $("#nav-cer").click(function() {
        $("#nav-cer span").toggleClass("clockwise");
    });

    $("#nav-cfg").click(function() {
        $("#nav-cfg span").toggleClass("clockwise");
    });

    $("#nav-ipt").click(function() {
        $("#nav-ipt span").toggleClass("clockwise");
    });

});
