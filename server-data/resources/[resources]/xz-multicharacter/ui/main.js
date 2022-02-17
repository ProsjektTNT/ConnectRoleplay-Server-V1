let isInRegistering = false;
let isInSelecting = false;
$(document).on("mousedown", (e) => {
    if (e.button == 0 && !isInSelecting && !isInRegistering) {
        $.post("http://xz-multicharacter/click_event", JSON.stringify({
            primary: true
        }), (data) => {
            if (data != "register" && data != "none") {
                isInSelecting = true;
                var html = `
                    <div class="character-info-container">
                        <div class="character-info-delete">
                            <div onclick="ChooseChar()" data-action="play" class="char-info-btn" aria-label="Play now" data-balloon-pos="down"><i class="fas fa-play"></i></div>
                            <!-- <div onclick="DeleteChar()" data-action="delete" class="char-info-btn" aria-label="Delete your character" data-balloon-pos="down"><i class="fas fa-trash-alt"></i></div> -->
                        </div>
                        <div class="character-main-details">
                            <span class="character-info-title">${data.name}</span>
                            <span class="character-info-dob">${data.dob}</span>
                        </div>
                        <div class="character-details-container">
                            <div class="info-box nationality">
                                <span aria-label="Your nationality" data-balloon-pos="up"><i class="fas fa-globe-americas"></i> ${data.nationality}</span>
                            </div>
                            <div class="info-box bank">
                                <span aria-label="Bank account balance" data-balloon-pos="up"><i class="fas fa-university"></i> ${Number(data.bank).toLocaleString()}$</span>
                            </div>
                            <div class="info-box cash">
                                <span aria-label="Cash balance" data-balloon-pos="up"><i class="fas fa-wallet"></i> ${Number(data.cash).toLocaleString()}$</span>
                            </div>
                            <div class="info-box job">
                                <span aria-label="Your current job" data-balloon-pos="up"><i class="fas fa-briefcase"></i> ${data.job}</span>
                            </div>
                            <div class="info-box phone">
                                <span aria-label="Your phone number" data-balloon-pos="up"><i class="fas fa-phone-alt"></i> ${data.phone}</span>
                            </div>
                        </div>
                    </div>
                `
                $(".character-info-wrapper").html(html).fadeIn();
            } else if (data == "register") {
                isInRegistering = true;
                isInSelecting = false;
                $(".character-mainregister-wrapper").fadeIn();
            }
        });
    } else {
        if (e.button == 2 && !isInRegistering) {
            isInSelecting = false;
            $.post("http://xz-multicharacter/click_event", JSON.stringify({
                primary: false
            }), (data) => {
                if (data == "true") {
                    $(".character-info-wrapper").fadeOut(300, function () {
                        $(".character-info-wrapper").empty();
                    });
                }
            });
        }
    }
})

function ChooseChar() {
    isInSelecting = false;
    $(".character-info-wrapper").fadeOut(300, function () {
        $(".character-info-wrapper").empty();
    });
    $.post("http://xz-multicharacter/playChar", JSON.stringify({}))
}

function DeleteChar() {
    isInSelecting = false;
    $.post("http://xz-multicharacter/delete", JSON.stringify({}))
}
window.addEventListener("message", e => {
    if (e.data.action == "showDetails") {
        $(".character-wrapper").fadeIn();
        $(".char-name").text(e.data.data.name);
        $(".char-cid").text(e.data.data.cid);
    }
    if (e.data.action == "clearDetails") {
        $(".character-wrapper").fadeOut();
    }
    if (e.data.action == "clearscreen") {
        $(".character-info-wrapper").fadeOut(300, function () {
            $(".character-info-wrapper").empty();
        });
        $(".character-main-register-wrapper").hide()
        $(".character-wrapper").hide();
    }
    if (e.data.action == "reset") {
        $(".character-info-wrapper").fadeOut(300, function () {
            $(".character-info-wrapper").empty();
        });
    }

})

$(document).ready(() => {
    $(".character-info-delete").on("click", ".char-info-btn", function () {
        const action = $(this).data("action")
        if (action == "play") {
            isInSelecting = false;
            $(".character-info-wrapper").fadeOut(300, function () {
                console.log("faded")
                $(".character-info-wrapper").empty();
            });
            $.post("http://xz-multicharacter/playChar", JSON.stringify({}))

        }
        if (action == "delete") {
            isInSelecting = false;
            $.post("http://xz-multicharacter/delete", JSON.stringify({}))

        }
    })
    $(".character-register-button").click(function () {
        const action = $(this).data("action")
        if (action == "play") {
            CheckRegisterInputs();
        } else if (action == "goback") {
            isInRegistering = false;
            $.post("http://xz-multicharacter/click_event", JSON.stringify({
                primary: false
            }));
            $(".register-errorbox").fadeOut();
            $(".character-mainregister-wrapper").fadeOut(350, () => {
                $("#register_firstname").val("");
                $("#register_lastname").val("");
                $("#register_date").val("");
                $("#register_nationality").val("");
                $("#register_nationality").parent().css("border", "none");
                $("#register_date").parent().css("border", "none");
                $("#register_lastname").parent().css("border", "none");
                $("#register_firstname").parent().css("border", "none");
                $("#register_gender").parent().css("border", "none");
            });

        }
    })
})

function CheckRegisterInputs() {
    var data = {}
    var validdata = true;
    $(".character-register-input").each(function () {
        var val = $(this).val();
        if (val == "") {
            $(this).parent().css("border", "1px solid red");
            validdata = false;
        } else {
            let id = $(this).attr("id");
            data[id.substring(9, id.length)] = val;
            $(this).parent().css("border", "none");
        }
    });
    if (validdata) {
        data["gender"] = $("#register_gender").val();
        isInRegistering = false;
        $(".register-errorbox").fadeOut();
        $(".character-mainregister-wrapper").fadeOut();
        $(".character-register-input").each(function () {
            $(this).val("");
        });
        $.post("http://xz-multicharacter/register", JSON.stringify({
            r_data: data
        }));
    } else {
        $(".register-errorbox").fadeIn();
    }

}