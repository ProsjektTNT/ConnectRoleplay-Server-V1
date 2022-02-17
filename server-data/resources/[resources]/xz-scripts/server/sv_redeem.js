var XZCore = undefined

emit("XZCore:GetObject", (obj) => XZCore = obj);

XZCore.Commands.Add("redeem", "Redeem A Token!", [{name: "Token", help: "Enter a token"}], true, function(source, args) {

    exports["oxmysql"].fetch(`SELECT type, amount FROM tokens WHERE token = "${args[0]}"`, function(res) {
        if(res[0] == null) return emitNet("XZCore:Notify", source, "Unknown Token.", "error")

        let type = res[0].type;
        let amount = res[0].amount;

        exports["oxmysql"].executeSync(`DELETE FROM tokens WHERE token = '${args[0]}'`);

        if(type === "cash" || type === "bank") {

            let QPlayer = XZCore.Functions.GetPlayer(source);
            QPlayer.Functions.AddMoney(type, amount, `Redeemed A Token!. Token: ${args[0]}`)

            emitNet("XZCore:Notify", source, `Success!, You received ${amount}$ to your ${(type === "cash") ? "wallet" : "bank account"}`, "success");
            QPlayer.Functions.Save();
        } else if(type == "item") {
            emitNet("XZCore:Notify", source, `You got 1x ${amount} to your inventory!`, "success")
            XZCore.Functions.GetPlayer(source).Functions.AddItem(amount, 1, undefined);
        } 
        
    });

}, "user");