function showNUI(text, type)
    SendNUIMessage({
        action = "show",
        showType = type,
        text = text
    })
end

function closeNUI()
    SendNUIMessage({
        action = "hide"
    })
end