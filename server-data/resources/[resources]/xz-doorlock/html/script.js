var showTypes = {
    "success": "#4BAF51",
    "error": "#F24234"
}

$(document).ready(function (){
    window.addEventListener('message', function (event) {
        var data = event.data;

        if(data.action === "show") {
            $("#text").css({"display": "block"})
            $("#text").css({"background-color": showTypes[data.showType]});
            $("#text").html(data.text);
        } else if(data.action === "hide") {
            $("#text").fadeOut(225)
        }

    });
});