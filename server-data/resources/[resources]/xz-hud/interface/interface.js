let settings = {
  hunger: 100,
  thirst: 100,
  armor: 100,
  health: 100,
};

let showSettings = {
  hunger: true,
  thirst: true,
  armor: true,
  health: true,
  oxygen: true,
  stamina: true
};

window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.display === true) {
    $(".hud-settings-container").slideDown();
  } else if (data.display === false) {
    $(".hud-settings-container").slideUp();
  }

  if (data.action == "radio") {
    if (data.radioState === true) {
      $("#imageV").attr('href', "imgs/headset.svg");
      $("#imageV").attr('width', "18.5");
      $("#imageV").attr('x', "12.5");
      $("#imageV").attr('y', "12.5");
    } else if (data.radioState === false) {
      $("#imageV").attr('href', "imgs/voice.svg");
      $("#imageV").attr('width', "11.5");
      $("#imageV").attr('x', "16.6");
      $("#imageV").attr('y', "13.5");

    }
  }

  if (data.action == "fuckingDebug") {
    if (data.modeDebug == true) {
      $(".debug").fadeIn();
    } else {
      $(".debug").fadeOut();
    }
  }

  if (data.data != undefined) {
    if (data.data.InPauseMenu) {
      $(".hud-container").fadeOut();
    } else {
      $(".hud-container").fadeIn();
    }
  }

  if (data.action == "updatePreferences") {
    console.log(data)
    settings = data.data.settings;

    console.log(settings)


    $("#hunger-val").val(settings.hunger);
    $("#thirst-val").val(settings.thirst);
    $("#armor-val").val(settings.armor);
    $("#health-val").val(settings.health);

    showSettings = data.data.show;
    console.log(showSettings)

    $("#hunger")[0].checked = showSettings.hunger;
    $("#thirst")[0].checked = showSettings.thirst;
    $("#armor")[0].checked = showSettings.armor;
    $("#health")[0].checked = showSettings.health;

    showSettings.oxygen = showSettings.oxygen;
    showSettings.stamina = showSettings.stamina;

    $("#lungs")[0].checked = showSettings.oxygen;
    $("#stamina")[0].checked = showSettings.stamina;
  }

  if (data.action == "update") {
    for (let _ in data.data) {
      if(data.data[_] == undefined) {
        continue;
      } 
      if (data.data[_] > settings[_] || !showSettings[_]) {
        $(`.${_}`).fadeOut();
      } else {
        $(`.${_}`).fadeIn();
      }
    }

    setMetaData("health", data.data.health)
    setMetaData("armor", data.data.armor)
    setMetaData("hunger", data.data.hunger)
    setMetaData("thirst", data.data.thirst)
    // setMetaData("stress", data.data.stress)
    setMetaData("nitro", data.data.nitrous)
    setMetaData("debug", data.data.debug)
    if (data.data.nitrous == 0 || !data.data.inVehicle) {
      $(".nitro").fadeOut();
    } else {
      $(".nitro").fadeIn();
    }

    if (data.data.armor == 0) {
      $(".complete.armor").css("fill", "#e02a2a", "opacity", "0.35")
    } else {
      $(".complete.armor").css("fill", "#2a7ae0", "opacity", "0.35")
    }
    if (data.data.oxygen <= 0) data.data.oxygen = 0;
    setMetaData("lungs", data.data.oxygen);
    if (showSettings.oxygen) {
      if (data.data.oxygen < 100) {
        $(".lungs").fadeIn();
      } else {
        $(".lungs").fadeOut();
      }
    } else {
      $(".lungs").fadeOut();
    }
    if (data.data.run <= 0) data.data.run = 0;
    setMetaData("stamina", data.data.run);
    if (showSettings.stamina) {
      if (data.data.run < 100) {
        $(".stamina").fadeIn();
      } else {
        $(".stamina").fadeOut();
      }
    } else {
      $(".stamina").fadeOut();
    }
  } else if (data.action == "talkingstate") {
    if (data.talkingState == 1) {
      $("#voice").animate({ 'stroke-dashoffset': "66.98666666666667" }, 500)
    } else if (data.talkingState == 2) {
      $("#voice").animate({ 'stroke-dashoffset': "33.49333333333333" }, 500)
    } else {
      $("#voice").animate({ 'stroke-dashoffset': "0" }, 500)
    }

  } else if (data.action == "talking") {
    if (data.voiceState == 1) {
      if (data.radioState == 1) {
        $("#voice").css("stroke", "#D65158")
        $(".complete.voice").css("fill", "#D65158", "opacity", "0.35")
      } else {
        $("#voice").css("stroke", "yellow")
        $(".complete.voice").css("fill", "yellow", "opacity", "0.35")
      }
    } else {
      $(".complete.voice").css("fill", "white", "opacity", "0.35")
      $("#voice").css("stroke", "white")
    }
  } else if (data.action == "death") {
    $(".complete.health").css("fill", "#ffffff")

  } else if (data.action == "displayCircleUI") {
    $(".mapbordersquare").hide();
    $(".outline").show();
    $(".mapbordercircle").show();
  } else if (data.action == "hideCircleUI") {
    $(".mapbordersquare").hide();
    $(".outline").hide();
    $(".mapbordercircle").hide();
  } else if(data.action == "vehicleGoBrrrrrrrr") {
    if (data.speed > 0) {
      $(".Speed_Meter").text(data.speed);
      let multiplier = data.maxspeed * 0.1;
      let SpeedoLimit = data.maxspeed + multiplier;
      setProgressSpeed(data.speed, '.Speed_Meter');
    } else if (data.speed == 0) {
      $(".Speed_Meter").text("0");
    }
  }

  else if (data.action == "seatbeltOn") {
    $('.seatbelt img').fadeOut();
  }
  else if (data.action == "seatbeltOff") {
    $('.seatbelt img').fadeIn();
  }

  if (data.showcompass == true) {
    $(".direction").find(".image").attr('style', 'transform: translate3d(' + event.data.direction + 'px, 0px, 0px)');
    $('.direction').fadeIn();
    $('.topcompass').fadeIn();
  }

  if (data.VehicleUI == true) {
    $(".vehicle-container").fadeIn(250);
  } else if (data.VehicleUI == false) {
    $(".vehicle-container").fadeOut(250);
  }

  if (data.action == "update_fuel") {
    setProgressFuel(data.value, '.Gas_gauge');
    if (data.value < 15) {
      $('#fuel-shit').css('stroke', '#f03232');
    } else if (data.value > 15) {
      $('#fuel-shit').css('stroke', '#ffffff');
    }
  }
})

$(document).ready(() => {

  $(".debug").fadeOut();

  $("#hunger-val").val(settings.hunger);
  $("#thirst-val").val(settings.thirst);
  $("#armor-val").val(settings.armor);
  $("#health-val").val(settings.health);

  $("#hunger").checked = showSettings.hunger;
  $("#thirst").checked = showSettings.thirst;
  $("#armor").checked = showSettings.armor;
  $("#health").checked = showSettings.health;

});

$(".save-btn").on("click", () => {
  showSettings.oxygen = $("#lungs").is(":checked");
  showSettings.stamina = $("#stamina").is(":checked");

  let tempSettings = {
    hunger: $("#hunger-val").val(),
    thirst: $("#thirst-val").val(),
    armor: $("#armor-val").val(),
    health: $("#health-val").val(),
  };
  let tempShowSettings = {
    hunger: $("#hunger").is(":checked"),
    thirst: $("#thirst").is(":checked"),
    armor: $("#armor").is(":checked"),
    health: $("#health").is(":checked"),
  };
  for (let set in tempSettings) {
    if (tempSettings[set] != "") {
      settings[set] = parseInt(tempSettings[set]);
    }
  }
  for (let showSet in tempShowSettings) {
    showSettings[showSet] = tempShowSettings[showSet];
  }

  for (let showSet in showSettings) {
    if (showSettings[showSet]) {
      $(`.${showSet}`).fadeIn();
    } else {
      $(`.${showSet}`).fadeOut();
    }
  }
  $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ settings: settings, show: showSettings }));
});

document.onkeyup = function (e) {
  if (e.keyCode == 27) {
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ settings: settings, show: showSettings }));
  }
};


function setMetaData(type, percent) {
  let radius = $(`.radial-progress.${type}`).find($('circle.incomplete')).attr('r');
  let circumference = 2 * Math.PI * radius;
  let strokeDashOffset = circumference - ((percent * circumference) / 100);
  $(`.radial-progress.${type}`).find($('circle.incomplete')).animate({ 'stroke-dashoffset': strokeDashOffset }, 400);
}

function setProgressSpeed(value, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');

  var percent = value * 100 / 220;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  var predkosc = Math.floor(value * 1.8)
  if (predkosc == 81 || predkosc == 131) {
    predkosc = predkosc - 1
  }

  //html.text(predkosc);
}

function setProgressFuel(percent, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;
  const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}