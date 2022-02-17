XZ.Phone.Settings = {};
XZ.Phone.Settings.Background = "default-qbus";
XZ.Phone.Settings.OpenedTab = null;
XZ.Phone.Settings.Backgrounds = {
    'default-qbus': {
        label: "Standard Qbus"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        XZ.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        XZ.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        XZ.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        XZ.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        XZ.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", XZ.Phone.Data.AnonymousCall);

        if (!XZ.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = XZ.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        XZ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", XZ.Phone.Settings.Backgrounds[XZ.Phone.Settings.Background].label+" is ingesteld!")
        XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+XZ.Phone.Settings.Background+".png')"})
    } else {
        XZ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal background set!")
        XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+XZ.Phone.Settings.Background+"')"});
    }

    $.post('https://xz-phone/SetBackground', JSON.stringify({
        background: XZ.Phone.Settings.Background,
    }))
});

XZ.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        XZ.Phone.Settings.Background = MetaData.background;
    } else {
        XZ.Phone.Settings.Background = "default-qbus";
    }

    var hasCustomBackground = XZ.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+XZ.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+XZ.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

XZ.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(XZ.Phone.Settings.Backgrounds, function(i, background){
        if (XZ.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            XZ.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            XZ.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    XZ.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    XZ.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    XZ.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = XZ.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        XZ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Standard avatar set!")
        XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        XZ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal avatar set!")
        XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        console.log(ProfilePicture)
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('https://xz-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    XZ.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    XZ.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            XZ.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            XZ.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    XZ.Phone.Animations.TopSlideUp(".settings-"+XZ.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    XZ.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});