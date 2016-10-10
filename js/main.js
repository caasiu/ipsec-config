
$(document).ready(function() {

    $(window).on('resize', function(){location.reload();})

    //init
    $("#installation-os-u").hide();
    $("#build-kvm").hide();
    $("#transfer-kvm").hide();
    $("#startup-os-u").hide();
    $(".content").find('a').addClass('navInactive');

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

    //make the content menu stick according to the scroll
    var menuPosTop = $(".content").offset().top;
    var contentMenuStick = function(elementPosTop){
        let docscrollTop = $(document).scrollTop();

        if (elementPosTop < docscrollTop){
            $(".content").addClass('stick');
        }

        if (elementPosTop > docscrollTop){
            $(".content").removeClass('stick');
        }
    }

    var setNavActive = function(){
        var hTarget = $("#container").find('h2');
        var winScrollTop = $(window).scrollTop();
        hTarget.each(function(index, H){
            (index < hTarget.length - 1) ? next_H_Top = hTarget.eq(index + 1).offset().top : next_H_Top = hTarget.last().offset().top;

            e = $(".content").find("[href='#" + $(this).parent().attr("id") + "']"); 

            if (winScrollTop < hTarget.eq(0).offset().top){
                $(".content").find('a').removeClass("navActive");
            }

            if (winScrollTop >= $(document).height() - $(window).height()){
                $(".content").find('a').removeClass("navActive");
                $(".content").find("[href='#ipsec-start']").addClass('navActive');
                return false;
            }

            if ($(H).offset().top < winScrollTop + 100 && winScrollTop + 100 < next_H_Top){
                $(".content").find('a').removeClass("navActive");
                e.addClass("navActive");
                return false;
            }
        })

    }

    $(window).scroll(function(){
        contentMenuStick(menuPosTop);
        setNavActive();
    });
});
