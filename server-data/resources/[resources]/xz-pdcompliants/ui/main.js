$(document).ready(()=>{
    $(".btn-grid").on("click", function(){
        let retval = false;
        $(".my-form input").each(function() {
            if (this.value == "") {
                retval = true;
                $(this).css({"border":"1px solid #e31b23"})
            }
        });

        if($(".my-form textarea").val() == "") {
            retval = true;
            $("#complaint").css({"border":"1px solid #e31b23"})
        }

        if(!retval && $(".my-form textarea").value != ""){
            $(".complaint-container").slideUp();
            let inputVal = {
                name : $("#name").val(),
                date : $("#date").val(),
                phone : $("#phone").val(),
                lastName : $("#lastName").val(),
                complaint : $("#complaint").val(),
            }
            $.post(`https://${GetParentResourceName()}/send`,JSON.stringify({
                data : inputVal
            }));
            restartInputs();
        }
    });

    $(".my-form input").on("click", function(){
        $(this).css({"border":"1px solid hsl(0, 0%, 10%)"})
    });

    $(".my-form textarea").on("click", function(){
        $(this).css({"border":"1px solid hsl(0, 0%, 10%)"})
    });
});


window.addEventListener("message",e => {
    if(e.data.action == "open-from"){
        $(".complaint-container").slideDown();
    }
});

$(document).keyup(function (e){
    if (e.keyCode == 27) {
        $(".complaint-container").slideUp();
        $.post(`https://${GetParentResourceName()}/close`,JSON.stringify({}))
    }
});

function restartInputs(){
    $("#name").val("")
    $("#date").val("")
    $("#phone").val("")
    $("#lastName").val("")
    $("#complaint").val("")
}