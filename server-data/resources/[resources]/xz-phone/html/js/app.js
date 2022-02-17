XZ = {}
XZ.Phone = {}
XZ.Screen = {}
XZ.Phone.Functions = {}
XZ.Phone.Animations = {}
XZ.Phone.Notifications = {}
XZ.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

XZ.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

XZ.Phone.Data.MaxSlots = 16;

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && XZ.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

XZ.Phone.Functions.SetupApplications = function(data) {
    XZ.Phone.Data.Applications = data.applications;

    var i;
    for (i = 1; i <= XZ.Phone.Data.MaxSlots; i++) {
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
        $(applicationSlot).html("");
        $(applicationSlot).css({
            "background-color":"transparent"
        });
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        $(applicationSlot).removeData('placement')
    }

    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, XZ.Phone.Data.PlayerJob.name)

        if ((!app.job || app.job === XZ.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

XZ.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

XZ.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (XZ.Phone.Data.currentApplication == null) {
                XZ.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                XZ.Phone.Functions.ToggleApp(PressedApplication, "block");
                
                if (XZ.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    XZ.Phone.Functions.HeaderTextColor("black", 300);
                }
    
                XZ.Phone.Data.currentApplication = PressedApplication;
    
                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(XZ.Phone.Data.PlayerData.charinfo.phone);
                    $("#mySerialNumber").text("xz-" + XZ.Phone.Data.PlayerData.metadata["phonedata"].SerialNumber);
                } else if (PressedApplication == "twitter") {
                    $.post('https://xz-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        XZ.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('https://xz-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        XZ.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    if (XZ.Phone.Data.IsOpen) {
                        $.post('https://xz-phone/GetTweets', JSON.stringify({}), function(Tweets){
                            XZ.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "bank") {
                    XZ.Phone.Functions.DoBankOpen();
                    $.post('https://xz-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        XZ.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('https://xz-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        XZ.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('https://xz-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        XZ.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('https://xz-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        XZ.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('https://xz-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        XZ.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('https://xz-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('https://xz-phone/GetMails', JSON.stringify({}), function(mails){
                        XZ.Phone.Functions.SetupMails(mails);
                    });
                    $.post('https://xz-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('https://xz-phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        XZ.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('https://xz-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('https://xz-phone/GetCryptoData', JSON.stringify({
                        crypto: "qbit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('https://xz-phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('https://xz-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('https://xz-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('https://xz-phone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"> <span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Click to set GPS</span> </div>';

                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "lawyers") {
                    $.post('https://xz-phone/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "rentel") {
                    $.post('https://xz-phone/SetupRentel', JSON.stringify({}), function(data){
                        SetupRentel(data); 
                    });
                } else if (PressedApplication == "store") {
                    $.post('https://xz-phone/SetupStoreApps', JSON.stringify({}), function(data){
                        SetupAppstore(data); 
                    });
                } else if (PressedApplication == "trucker") {
                    $.post('https://xz-phone/GetTruckerData', JSON.stringify({}), function(data){
                        SetupTruckerInfo(data);
                    });
                }
            }
        }
    } else {
        XZ.Phone.Notifications.Add("fas fa-exclamation-circle", "System", XZ.Phone.Data.Applications[PressedApplication].tooltipText+" is not available!")
    }
});

$(document).on('click', '.mykeys-key', function(e){
    e.preventDefault();

    var KeyData = $(this).data('KeyData');

    $.post('https://xz-phone/SetHouseLocation', JSON.stringify({
        HouseData: KeyData
    }))
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (XZ.Phone.Data.currentApplication === null) {
        XZ.Phone.Functions.Close();
    } else {
        XZ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        XZ.Phone.Animations.TopSlideUp('.'+XZ.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            XZ.Phone.Functions.ToggleApp(XZ.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        XZ.Phone.Functions.HeaderTextColor("white", 300);

        if (XZ.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (XZ.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});
    
                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');
    
                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');
    
                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (XZ.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"}); 
            }, 400)
        }

        XZ.Phone.Data.currentApplication = null;
    }
});

XZ.Phone.Functions.Open = function(data) {
    XZ.Phone.Animations.BottomSlideUp('.container', 300, 0);
    XZ.Phone.Notifications.LoadTweets(data.Tweets);
    XZ.Phone.Data.IsOpen = true;
}

XZ.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

XZ.Phone.Functions.Close = function() {

    if (XZ.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            XZ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            XZ.Phone.Animations.TopSlideUp('.'+XZ.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            XZ.Phone.Functions.HeaderTextColor("white", 300);
    
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            XZ.Phone.Data.currentApplication = null;
        }, 500)
    } else if (XZ.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"}); 
    }

    XZ.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('https://xz-phone/Close');
    XZ.Phone.Data.IsOpen = false;
}

XZ.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

XZ.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

XZ.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

XZ.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

XZ.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

XZ.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    $.post('https://xz-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (XZ.Phone.Notifications.Timeout == undefined || XZ.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!XZ.Phone.Data.IsOpen) {
                    XZ.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                XZ.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (XZ.Phone.Notifications.Timeout !== undefined || XZ.Phone.Notifications.Timeout !== null) {
                    clearTimeout(XZ.Phone.Notifications.Timeout);
                }
                XZ.Phone.Notifications.Timeout = setTimeout(function(){
                    XZ.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!XZ.Phone.Data.IsOpen) {
                        XZ.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    XZ.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!XZ.Phone.Data.IsOpen) {
                    XZ.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (XZ.Phone.Notifications.Timeout !== undefined || XZ.Phone.Notifications.Timeout !== null) {
                    clearTimeout(XZ.Phone.Notifications.Timeout);
                }
                XZ.Phone.Notifications.Timeout = setTimeout(function(){
                    XZ.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!XZ.Phone.Data.IsOpen) {
                        XZ.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    XZ.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

XZ.Phone.Functions.LoadPhoneData = function(data) {
    XZ.Phone.Data.PlayerData = data.PlayerData;
    XZ.Phone.Data.PlayerJob = data.PlayerJob;
    XZ.Phone.Data.MetaData = data.PhoneData.MetaData;
    XZ.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    XZ.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    XZ.Phone.Functions.SetupApplications(data);
    $("#phone-serverid").html("<span style='font-size: 1.2vh; font-weight:bold;'>" + data.serverid + "</span>");
    console.log("Phone succesfully loaded!");
}

XZ.Phone.Functions.UpdateTime = function(data) {    
    $("#phone-time").html("<span style='font-size: 1.2vh;'>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

var NotificationTimeout = null;

XZ.Screen.Notification = function(title, content, icon, timeout, color) {
    $.post('https://xz-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);
        
            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }
        
            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}

// XZ.Screen.Notification("Nieuwe Tweet", "Dit is een test tweet like #YOLO", "fab fa-twitter", 4000);

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                XZ.Phone.Functions.Open(event.data);
                XZ.Phone.Functions.SetupAppWarnings(event.data.AppData);
                XZ.Phone.Functions.SetupCurrentCall(event.data.CallData);
                XZ.Phone.Data.IsOpen = true;
                XZ.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            // case "LoadPhoneApplications":
            //     XZ.Phone.Functions.SetupApplications(event.data);
            //     break;
            case "LoadPhoneData":
                XZ.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                XZ.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                XZ.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                XZ.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                XZ.Phone.Functions.SetupAppWarnings(event.data.AppData);                
                break;
            case "UpdateMentionedTweets":
                XZ.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);                
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&#36; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (XZ.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        console.log('Chat reloaded')
                        XZ.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        console.log('Chats reloaded')
                        XZ.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                XZ.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                XZ.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('https://xz-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('https://xz-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                XZ.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                XZ.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                if (!XZ.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("In conversation ("+timeString+")");
                    $(".call-notifications-content").html("Calling with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In conversation ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                XZ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    XZ.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                XZ.Phone.Functions.HeaderTextColor("white", 300);
    
                XZ.Phone.Data.CallActive = false;
                XZ.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                XZ.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                XZ.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (XZ.Phone.Data.currentApplication == "advert") {
                    XZ.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                XZ.Phone.Data.PlayerJob = event.data.JobData;
                XZ.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('https://xz-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "RefreshAlerts":
                XZ.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
        }
    })
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            XZ.Phone.Functions.Close();
            break;
    }
});
