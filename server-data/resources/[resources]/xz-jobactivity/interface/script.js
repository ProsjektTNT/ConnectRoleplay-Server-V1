let isOpen = false;
let resourceName = GetParentResourceName();
let opacityLevel = 0.7;
let personalSettings = {title : 1.35, players: 1, playerMe: 1.1, size: 0.6};
let doesActivesShown = false;
let isSettingsShown = false;
var titlesize = 1.35;
var playerSize = 1;
var playerSizeme = 1.1;

$(function() {

    function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById(elmnt.id + "header")) {
          document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
        } else {
          elmnt.onmousedown = dragMouseDown;
        }
      
        function dragMouseDown(e) {
          e = e || window.event;
          e.preventDefault();
          pos3 = e.clientX;
          pos4 = e.clientY;
          document.onmouseup = closeDragElement;
          document.onmousemove = elementDrag;
        }
      
        function elementDrag(e) {
          e = e || window.event;
          e.preventDefault();
          pos1 = pos3 - e.clientX;
          pos2 = pos4 - e.clientY;
          pos3 = e.clientX;
          pos4 = e.clientY;
          elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
          elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }
      
        function closeDragElement() {
          document.onmouseup = null;
          document.onmousemove = null;
        }
      }
      
    function addbits(s) {
        var total = 0,
            s = s.match(/[+\-]*(\.\d+|\d+(\.\d+)?)/g) || [];
            
        while (s.length) {
          total += parseFloat(s.shift());
        }
        return total;
    }

    function ChangeBackGround(val){
        $('.active-players').css('background-color', `rgba(0,0,0,${val})`);
        $('.title').css('background-color', `rgba(0,0,0,${addbits(val+0.05)})`);
    }

    window.addEventListener("message", (event) => {
        let data = event.data;

        if(data.action == "openSettings") {
            $(".settings-container").fadeIn(250);
            $(".warrper").fadeIn(250);
            dragElement(document.getElementById("polica"));
            isSettingsShown = true
        } else if(data.action == "update") {
            if($(".players-container").children().length != 0)
                $(".players-container").empty()
            $('.title span').text(`Active ${data.jobData.label} - (${Object.keys(data.jobData.players).length})`);
            for(let player in data.jobData.players) {
                $(".players-container").append(`
                <div class="player ${(data.jobData.players[player].me != undefined) ? "me" : ""}" style="${(data.jobData.players[player].me == undefined) ? `font-size: ${personalSettings.players}rem;` : `font-size: ${personalSettings.playerMe}rem;`}">
                    <span class="tag ${(data.jobData.players[player].isBoss != undefined && data.jobData.players[player].isBoss) ? "boss" : ""}" style="margin-right: 5px; padding-left: 3px; padding-right: 3px; text-align: center;">${data.jobData.players[player].callSign}</span><span>${data.jobData.players[player].playerName} | ${data.jobData.players[player].gradeName} - (${data.jobData.players[player].radioChannel})</span>
                </div>`)
            }

        } else if(data.action == "close") {
            $(".settings-container").fadeOut(250);
            $(".warrper").fadeOut(250);
            $(".active-players").fadeOut(250);
        }
    });

    $("#close-del").click( () => {
        $(".settings-container").fadeOut(250);
        $(".warrper").fadeOut(250);
        isSettingsShown = false
        $.post(`https://${resourceName}/closeSettings`, {});
    });

    $(".save-btn").click( () => {
        let rankValue = $("#rank").val()
        if(rankValue != "" && rankValue.length < 5) {
            $.post(`https://${resourceName}/setRank`, JSON.stringify({newRank: rankValue}));
        }
    });

    $(".restore-btn").click( () => {
        personalSettings = {title : 1.35, players: 1, playerMe: 1.1, size: 0.6};
    
        $('.player').css('font-size', `${personalSettings.players}rem`);
        $('.title').css('font-size', `${personalSettings.title}rem`);
        $('.range-inputes input').val("contrast");
        $('.player.me').css('font-size', `${personalSettings.playerMe}rem`);
        $("#increase-size").val("0.6")
    });

    $(".toggle-btn").click( () => {
        if(doesActivesShown) {
            $(".active-players").slideDown();
            doesActivesShown = false;
        } else {
            $(".active-players").slideUp();
            doesActivesShown = true;
        }
        
    });


    $(document).on('change', '#opacity', function() {
        ChangeBackGround($(this).val());
    });

    $(document).on('change', '#increase-size', function() {
        personalSettings.size =  $(this).val();
        personalSettings.playerMe = Math.abs(playerSizeme * $(this).val()).toFixed(4);
        personalSettings.title =  Math.abs(titlesize * $(this).val()).toFixed(4);
        personalSettings.players = Math.abs(playerSize * $(this).val()).toFixed(4);
        
        $('.title').css('font-size', `${personalSettings.title}rem`);
        $('.player me').css('font-size', `${personalSettings.playerMe}rem`);
        $('.player').css('font-size', `${personalSettings.players}rem`);
        $('.player me').css('font-weight','bold');
    });

    window.addEventListener('keydown', function(event) {
        if(event.keyCode == 27) {
            if(isSettingsShown) {
                $(".settings-container").fadeOut(250);
                $(".warrper").fadeOut(250);
            }
            $.post(`https://${resourceName}/closeSettings`, {});
        }
    })

});