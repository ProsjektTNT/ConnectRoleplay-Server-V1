local XZPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}
local TWData = {}
TWData.NewTweets = {}
TWData.TweetData = {}
Citizen.CreateThread(function()
    Wait(500)
    local LoadResource = json.decode(LoadResourceFile(GetCurrentResourceName(), 'tw.json'))
    local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "ad.json"))
    Adverts = LoadJson
   
    TWData.NewTweets = LoadResource.NewTweets
    TWData.TweetData = LoadResource.TweetData
    TriggerClientEvent('xz-phone:client:Adverts', -1, Adverts)
end)

XZCore.Commands.Add('hidemenu', 'Hide NUI Script.', {}, false, function(source, args)
    TriggerClientEvent("hidemenu", source)
end)

RegisterServerEvent('xz-phone:server:AddAdvert')
AddEventHandler('xz-phone:server:AddAdvert', function(msg)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
        }
    end

    SaveResourceFile(GetCurrentResourceName(), "ad.json", json.encode(Adverts), -1)
    TriggerClientEvent('xz-phone:client:UpdateAdverts', -1, Adverts, "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname)
end)

function GetOnlineStatus(number)
    local Target = XZCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

RegisterNetEvent("xz-phone:server:removeMoney", function(type, amount)
    local src    = source
    local Player = XZCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney(type, amount, "removeMoney-phone")
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            InstalledApps = Player.PlayerData.metadata["phonedata"].InstalledApps,
        }
        PhoneData.Adverts = Adverts

        local result = exports.oxmysql:fetchSync('SELECT * FROM `player_contacts` WHERE `citizenid` = ? ORDER BY `name` ASC', { Player.PlayerData.citizenid })
        local Contacts = {}
        if result[1] ~= nil then
            for k, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end
            
            PhoneData.PlayerContacts = result
        end

        local invoices = exports.oxmysql:fetchSync("SELECT * FROM `phone_invoices` WHERE `citizenid` = ?", { Player.PlayerData.citizenid })
        if(invoices[1] ~= nil) then
            PhoneData.Invoices = invoices
        end

        local vehicles = exports.oxmysql:fetchSync("SELECT * FROM `xzvehicles` WHERE `citizenid` = ?", { Player.PlayerData.citizenid })
        if vehicles[1] ~= nil then
            PhoneData.Garage = vehicles
        end
            
        local messages = exports.oxmysql:fetchSync('SELECT * FROM `phone_messages` WHERE `citizenid` = ?', { Player.PlayerData.citizenid })   
        if messages ~= nil and next(messages) ~= nil then 
            PhoneData.Chats = messages
        end

        if AppAlerts[Player.PlayerData.citizenid] ~= nil then 
            PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
        end

        if MentionedTweets[Player.PlayerData.citizenid] ~= nil then 
            PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
        end

        if TWData.NewTweets ~= nil and next(TWData.NewTweets) ~= nil then
            PhoneData.Tweets = TWData.NewTweets
        end

        if Hashtags ~= nil and next(Hashtags) ~= nil then
            PhoneData.Hashtags = Hashtags
        end

        if Tweets ~= nil and next(Tweets) ~= nil then
            PhoneData.Tweets = Tweets
        end

        local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid= @citizenid ORDER BY `date` ASC',  {['@citizenid'] = Player.PlayerData.citizenid })
        if mails[1] ~= nil then
            print("not nil")
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
            PhoneData.Mails = mails
        end

        local transactions = exports.oxmysql:fetchSync('SELECT * FROM crypto_transactions WHERE citizenid=@citizenid ORDER BY `date` ASC', {['@citizenid'] = Player.PlayerData.citizenid})
        if transactions[1] ~= nil then
            for _, v in pairs(transactions) do
                table.insert(PhoneData.CryptoTransactions, {
                    TransactionTitle = v.title,
                    TransactionMessage = v.message,
                })
            end
        end

        cb(PhoneData)
    end
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = XZCore.Functions.GetPlayerByPhone(ContactData.number)

    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('xz-phone:server:SetCallState')
AddEventHandler('xz-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)

    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterServerEvent('xz-phone:server:RemoveMail')
AddEventHandler('xz-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('DELETE FROM player_mails WHERE mailid=@mailid AND citizenid=@citizenid', {['@mailid'] = MailId, ['@citizenid'] = Player.PlayerData.citizenid})
    SetTimeout(100, function()
        local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid=@citizenid ORDER BY `date` ASC', {['@citizenid'] = Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('xz-phone:client:UpdateMails', src, mails)
    end)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('xz-phone:server:sendNewMail')
AddEventHandler('xz-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    if mailData.button == nil then
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read)', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@sender'] = mailData.sender,
            ['@subject'] = mailData.subject,
            ['@message'] = mailData.message,
            ['@mailid'] = GenerateMailId(),
            ['@read'] = 0
        })
    else
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read, @button)', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@sender'] = mailData.sender,
            ['@subject'] = mailData.subject,
            ['@message'] = mailData.message,
            ['@mailid'] = GenerateMailId(),
            ['@read'] = 0,
            ['@button'] = json.encode(mailData.button)
        })
    end
    TriggerClientEvent('xz-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid=@citizenid ORDER BY `date` DESC', {['@citizenid'] = Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('xz-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterServerEvent('xz-phone:server:sendNewMailToOffline')
AddEventHandler('xz-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = XZCore.Functions.GetPlayerByCitizenId(citizenid)

    if Player ~= nil then
        local src = Player.PlayerData.source

        if mailData.button == nil then
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@sender'] = mailData.sender,
                ['@subject'] = mailData.subject,
                ['@message'] = mailData.message,
                ['@mailid'] = GenerateMailId(),
                ['@read'] = 0
            })
            TriggerClientEvent('xz-phone:client:NewMailNotify', src, mailData)
        else
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read, @button)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@sender'] = mailData.sender,
                ['@subject'] = mailData.subject,
                ['@message'] = mailData.message,
                ['@mailid'] = GenerateMailId(),
                ['@read'] = 0,
                ['@button'] = json.encode(mailData.button)
            })
            TriggerClientEvent('xz-phone:client:NewMailNotify', src, mailData)
        end

        SetTimeout(200, function()
            local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid=@citizenid ORDER BY `date` ASC', {['@citizenid'] = Player.PlayerData.citizenid})
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('xz-phone:client:UpdateMails', src, mails)
        end)
    else
        if mailData.button == nil then
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@sender'] = mailData.sender,
                ['@subject'] = mailData.subject,
                ['@message'] = mailData.message,
                ['@mailid'] = GenerateMailId(),
                ['@read'] = 0
            })
        else
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read, @button)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@sender'] = mailData.sender,
                ['@subject'] = mailData.subject,
                ['@message'] = mailData.message,
                ['@mailid'] = GenerateMailId(),
                ['@read'] = 0,
                ['@button'] = json.encode(mailData.button)
            })
        end
    end
end)

RegisterServerEvent('xz-phone:server:sendNewEventMail')
AddEventHandler('xz-phone:server:sendNewEventMail', function(citizenid, mailData)
    local Player = XZCore.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read)', {
            ['@citizenid'] = citizenid,
            ['@sender'] = mailData.sender,
            ['@subject'] = mailData.subject,
            ['@message'] = mailData.message,
            ['@mailid'] = GenerateMailId(),
            ['@read'] = 0
        })
    else
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@citizenid, @sender, @subject, @message, @mailid, @read, @button)', {
            ['@citizenid'] = citizenid,
            ['@sender'] = mailData.sender,
            ['@subject'] = mailData.subject,
            ['@message'] = mailData.message,
            ['@mailid'] = GenerateMailId(),
            ['@read'] = 0,
            ['@button'] = json.encode(mailData.button)
        })
    end
    SetTimeout(200, function()
        local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid=@citizenid ORDER BY `date` ASC', {['@citizenid'] = citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('xz-phone:client:UpdateMails', Player.PlayerData.source, mails)
    end)
end)

RegisterServerEvent('xz-phone:server:ClearButtonData')
AddEventHandler('xz-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('UPDATE player_mails SET button=@button WHERE mailid=@mailid AND citizenid=@citizenid', {['@button'] = '', ['@mailid'] = mailId, ['@citizenid'] = Player.PlayerData.citizenid})
    SetTimeout(200, function()
        local mails = exports.oxmysql:fetchSync('SELECT * FROM player_mails WHERE citizenid=@citizenid ORDER BY `date` ASC', {['@citizenid'] = Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('xz-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterServerEvent('xz-phone:server:MentionedPlayer')
AddEventHandler('xz-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(XZCore.Functions.GetPlayers()) do
        local Player = XZCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                XZPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                XZPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('xz-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                local query1 = '%'..firstName..'%'
                local query2 = '%'..lastName..'%'
                local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query1 AND charinfo LIKE @query2', {['@query1'] = query1, ['@query2'] = query2})
                if result[1] ~= nil then
                    local MentionedTarget = result[1].citizenid
                    XZPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                    XZPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                end
            end
        end
	end
end)

RegisterServerEvent('xz-phone:server:CallContact')
AddEventHandler('xz-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)
    local Target = XZCore.Functions.GetPlayerByPhone(TargetData.number)

    if Target ~= nil then
        TriggerClientEvent('xz-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

RegisterServerEvent('xz-phone:server:BillingEmail')
AddEventHandler('xz-phone:server:BillingEmail', function(data, paid)
    for k,v in pairs(XZCore.Functions.GetPlayers()) do
        local target = XZCore.Functions.GetPlayer(v)
        if target.PlayerData.job.name == data.society then
            if paid then
                local name = ''..XZCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname..' '..XZCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname..''
                TriggerClientEvent('xz-phone:client:BillingEmail', target.PlayerData.source, data, true, name)
            else
                local name = ''..XZCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname..' '..XZCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname..''
                TriggerClientEvent('xz-phone:client:BillingEmail', target.PlayerData.source, data, false, name)
            end
        end
    end
end)

XZCore.Functions.CreateCallback('xz-phone:server:PayInvoice', function(source, cb, society, amount, invoiceId)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)
    local Invoices = {}

    Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
    TriggerEvent("xz-bossmenu:server:addAccountMoney", society, amount)
    exports.oxmysql.execute("DELETE FROM `phone_invoices` WHERE `invoiceid` = ?", { tonumber(invoiceId) })
    exports.oxmysql.scalar("SELECT * FROM `phone_invoices` WHERE `citizenid` = ?", { Ply.PlayerData.citizenid }, function(invoices)
        if invoices[1] ~= nil then
            Invoices = invoices
        end
        cb(true, Invoices)
    end)
end)

XZCore.Functions.CreateCallback('xz-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)
    local Trgt = XZCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    exports.oxmysql.execute("DELETE FROM `phone_invoices` WHERE `invoiceid` = ?", { tonumber(invoiceId) })
    exports.oxmysql.scalar("SELECT * FROM `phone_invoices` WHERE `citizenid` = ?", { Ply.PlayerData.citizenid }, function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Target = XZCore.Functions.GetPlayerByCitizenId(v.sender)
                if Target ~= nil then
                    v.number = Target.PlayerData.charinfo.phone
                else
                    exports.oxmysql.scalar("SELECT * FROM `players` WHERE `citizenid` = ?", { v.sender }, function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            Invoices = invoices
        end
        cb(true, invoices)
    end)
end)

RegisterServerEvent('xz-phone:server:UpdateHashtags')
AddEventHandler('xz-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('xz-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

XZPhone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

XZPhone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

XZCore.Functions.CreateCallback('xz-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = XZCore.Functions.GetPlayerByPhone(v.number)
        
        local query = '%'..v.number..'%'
        local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query', {['@query'] = query})
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].metadata)

            if MetaData.phone.profilepicture ~= nil then
                v.picture = MetaData.phone.profilepicture
            else
                v.picture = "default"
            end
        end
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetContactPicture', function(source, cb, Chat)
    local Player = XZCore.Functions.GetPlayerByPhone(Chat.number)

    local query = '%'..Chat.number..'%'
    local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query', {['@query'] = query})
    local MetaData = json.decode(result[1].metadata)

    if MetaData.phone.profilepicture ~= nil then
        Chat.picture = MetaData.phone.profilepicture
    else
        Chat.picture = "default"
    end
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetPicture', function(source, cb, number)
    local Player = XZCore.Functions.GetPlayerByPhone(number)
    local Picture = nil

    local query = '%'..number..'%'
    local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query', {['@query'] = query})
    if result[1] ~= nil then
        local MetaData = json.decode(result[1].metadata)

        if MetaData.phone.profilepicture ~= nil then
            Picture = MetaData.phone.profilepicture
        else
            Picture = "default"
        end
        cb(Picture)
    else
        cb(nil)
    end
end)

RegisterServerEvent('xz-phone:server:SetPhoneAlerts')
AddEventHandler('xz-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = XZCore.Functions.GetPlayer(src).citizenid
    XZPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterServerEvent('xz-phone:server:UpdateTweets')
AddEventHandler('xz-phone:server:UpdateTweets', function(NewTweets, TweetData)
    TWData.NewTweets = NewTweets
    TWData.TweetData = TweetData
    local src = source
    SaveResourceFile(GetCurrentResourceName(), 'tw.json', json.encode(TWData), -1)
    TriggerClientEvent('xz-phone:client:UpdateTweets', -1, src, TWData.NewTweets, TWData.TweetData)
end)


RegisterServerEvent('xz-phone:server:TransferMoney')
AddEventHandler('xz-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = XZCore.Functions.GetPlayer(src)

    local query = '%'..iban..'%'
    local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query', {['@query'] = query})
    if result[1] ~= nil then
        local reciever = XZCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

        if reciever ~= nil then
            local PhoneItem = reciever.Functions.GetItemByName("phone")
            reciever.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-"..reciever.PlayerData.citizenid)

            if PhoneItem ~= nil then
                TriggerClientEvent('xz-phone:client:TransferMoney', reciever.PlayerData.source, amount, reciever.PlayerData.money.bank)
            end
        else
            local moneyInfo = json.decode(result[1].money)
            moneyInfo.bank = round((moneyInfo.bank + amount))
            exports.oxmysql:execute('UPDATE players SET money=@money WHERE citizenid=@citizenid', {['@money'] = json.encode(moneyInfo), ['@citizenid'] = result[1].citizenid})
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
        end
    else
        TriggerClientEvent('XZCore:Notify', src, "This account number doesn't exist!", "error")
    end
end)

RegisterServerEvent('xz-phone:server:EditContact')
AddEventHandler('xz-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('UPDATE player_contacts SET name=@newname, number=@newnumber, iban=@newiban WHERE citizenid=@citizenid AND name=@oldname AND number=@oldnumber', {
        ['@newname'] = newName,
        ['@newnumber'] = newNumber,
        ['@newiban'] = newIban,
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@oldname'] = oldName,
        ['@oldnumber'] = oldNumber
    })
end)

RegisterServerEvent('xz-phone:server:RemoveContact')
AddEventHandler('xz-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('DELETE FROM player_contacts WHERE name=@name AND number=@number AND citizenid=@citizenid', {
        ['@name'] = Name,
        ['@number'] = Number,
        ['@citizenid'] = Player.PlayerData.citizenid
    })
end)

RegisterServerEvent('xz-phone:server:AddNewContact')
AddEventHandler('xz-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:insert('INSERT INTO player_contacts (citizenid, name, number, iban) VALUES (@citizenid, @name, @number, @iban)', {
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@name'] = tostring(name),
        ['@number'] = tostring(number),
        ['@iban'] = tostring(iban)
    })
end)

RegisterServerEvent('xz-phone:server:UpdateMessages')
AddEventHandler('xz-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = XZCore.Functions.GetPlayer(src)

    local query = '%'..ChatNumber..'%'
    local Player = exports.oxmysql:fetchSync('SELECT * FROM players WHERE charinfo LIKE @query', {['@query'] = query})
    if Player[1] ~= nil then
        local TargetData = XZCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)

        if TargetData ~= nil then
            local Chat = exports.oxmysql:fetchSync('SELECT * FROM phone_messages WHERE citizenid=@citizenid AND number=@number', {['@citizenid'] = SenderData.PlayerData.citizenid, ['@number'] = ChatNumber})
            if Chat[1] ~= nil then
                -- Update for target
                exports.oxmysql:execute('UPDATE phone_messages SET messages=@messages WHERE citizenid=@citizenid AND number=@number', {
                    ['@messages'] = json.encode(ChatMessages), 
                    ['@citizenid'] = TargetData.PlayerData.citizenid,
                    ['@number'] = SenderData.PlayerData.charinfo.phone
                })
                        
                -- Update for sender
                exports.oxmysql:execute('UPDATE phone_messages SET messages=@messages WHERE citizenid=@citizenid AND number=@number', {
                    ['@messages'] = json.encode(ChatMessages), 
                    ['@citizenid'] = SenderData.PlayerData.citizenid,
                    ['@number'] = TargetData.PlayerData.charinfo.phone
                })
            
                -- Send notification & Update messages for target
                TriggerClientEvent('xz-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
            else
                -- Insert for target
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (@citizenid, @number, @messages)', {
                    ['@citizenid'] = TargetData.PlayerData.citizenid, 
                    ['@number'] = SenderData.PlayerData.charinfo.phone,
                    ['@messages'] = json.encode(ChatMessages)
                })
                                    
                -- Insert for sender
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (@citizenid, @number, @messages)', {
                    ['@citizenid'] = SenderData.PlayerData.citizenid, 
                    ['@number'] = TargetData.PlayerData.charinfo.phone,
                    ['@messages'] = json.encode(ChatMessages)
                })

                -- Send notification & Update messages for target
                TriggerClientEvent('xz-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
            end
        else
            local Chat = exports.oxmysql:fetchSync('SELECT * FROM phone_messages WHERE citizenid=@citizenid AND number=@number', {['@citizenid'] = SenderData.PlayerData.citizenid, ['@number'] = ChatNumber})
            if Chat[1] ~= nil then
                -- Update for target
                exports.oxmysql:execute('UPDATE phone_messages SET messages=@messages WHERE citizenid=@citizenid AND number=@number', {
                    ['@messages'] = json.encode(ChatMessages), 
                    ['@citizenid'] = Player[1].citizenid,
                    ['@number'] = SenderData.PlayerData.charinfo.phone
                })
                -- Update for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                exports.oxmysql:execute('UPDATE phone_messages SET messages=@messages WHERE citizenid=@citizenid AND number=@number', {
                    ['@messages'] = json.encode(ChatMessages), 
                    ['@citizenid'] = SenderData.PlayerData.citizenid,
                    ['@number'] = Player[1].charinfo.phone
                })
            else
                -- Insert for target
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (@citizenid, @number, @messages)', {
                    ['@citizenid'] = Player[1].citizenid, 
                    ['@number'] = SenderData.PlayerData.charinfo.phone,
                    ['@messages'] = json.encode(ChatMessages)
                })
                
                -- Insert for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (@citizenid, @number, @messages)', {
                    ['@citizenid'] = SenderData.PlayerData.citizenid, 
                    ['@number'] = Player[1].charinfo.phone,
                    ['@messages'] = json.encode(ChatMessages)
                })
            end
        end
    end
end)

RegisterServerEvent('xz-phone:server:AddRecentCall')
AddEventHandler('xz-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = XZCore.Functions.GetPlayer(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('xz-phone:client:AddRecentCall', src, data, label, type)

    local Trgt = XZCore.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('xz-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " ..Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterServerEvent('xz-phone:server:CancelCall')
AddEventHandler('xz-phone:server:CancelCall', function(ContactData)
    local Ply = XZCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('xz-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('xz-phone:server:AnswerCall')
AddEventHandler('xz-phone:server:AnswerCall', function(CallData)
    local Ply = XZCore.Functions.GetPlayerByPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('xz-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('xz-phone:server:SaveMetaData')
AddEventHandler('xz-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    local MetaData = json.decode(result[1].metadata)
    MetaData.phone = MData
    exports.oxmysql:execute('UPDATE players SET metadata=@metadata WHERE citizenid=@citizenid', {['@metadata'] = json.encode(MetaData), ['@citizenid'] = Player.PlayerData.citizenid})
    Player.Functions.SetMetaData("phone", MData)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

XZCore.Functions.CreateCallback('xz-phone:server:FetchResult', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}

    local query = 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'"'
    -- Split on " " and check each var individual
    local searchParameters = SplitStringToArray(search)
    
    -- Construct query dynamicly for individual parm check
    if #searchParameters > 1 then
        query = query .. ' OR `charinfo` LIKE "%'..searchParameters[1]..'%"'
        for i = 2, #searchParameters do
            query = query .. ' AND `charinfo` LIKE  "%' .. searchParameters[i] ..'%"'
        end
    else
        query = query .. ' OR `charinfo` LIKE "%'..search..'%"'
    end
    
    local ApartmentData = exports.oxmysql:fetchSync('SELECT * FROM apartments')
    for k, v in pairs(ApartmentData) do
        ApaData[v.citizenid] = ApartmentData[k]
    end

    local result = exports.oxmysql:fetchSync(query)
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local charinfo = json.decode(v.charinfo)
            local metadata = json.decode(v.metadata)
            local appiepappie = {}
            if ApaData[v.citizenid] ~= nil and next(ApaData[v.citizenid]) ~= nil then
                appiepappie = ApaData[v.citizenid]
            end
            table.insert(searchData, {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                birthdate = charinfo.birthdate,
                phone = charinfo.phone,
                nationality = charinfo.nationality,
                gender = charinfo.gender,
                warrant = false,
                driverlicense = metadata["licences"]["driver"],
                appartmentdata = appiepappie,
            })
        end
        cb(searchData)
    else
        cb(nil)
    end
end)

function SplitStringToArray(string)
    local retval = {}
    for i in string.gmatch(string, "%S+") do
        table.insert(retval, i)
    end
    return retval
end

XZCore.Functions.CreateCallback('xz-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local query = '%'..search..'%'
    local result = exports.oxmysql:executeSync('SELECT * FROM player_vehicles WHERE plate LIKE @query OR citizenid=@citizenid', {['@query'] = query, ['@citizenid'] = search})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local player = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid=@citizenid', {['@citizenid'] = result[k].citizenid})
            if player[1] ~= nil then 
                local charinfo = json.decode(player[1].charinfo)
                local vehicleInfo = XZCore.Shared.Vehicles[result[k].vehicle]
                if vehicleInfo ~= nil then 
                    table.insert(searchData, {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = vehicleInfo["name"]
                    })
                else
                    table.insert(searchData, {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = "Name not found.."
                    })
                end
            end
        end
    else
        if GeneratedPlates[search] ~= nil then
            table.insert(searchData, {
                plate = GeneratedPlates[search].plate,
                status = GeneratedPlates[search].status,
                owner = GeneratedPlates[search].owner,
                citizenid = GeneratedPlates[search].citizenid,
                label = "Brand unknown.."
            })
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[search] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid,
            }
            table.insert(searchData, {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid,
                label = "Brand unknown.."
            })
        end
    end
    cb(searchData)
end)

XZCore.Functions.CreateCallback('xz-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then 
        exports.oxmysql.fetch('SELECT * FROM `xzvehicles` WHERE `plate` = ?', { plate }, function(result)
            if result[1] ~= nil then
                exports.oxmysql.fetch('SELECT * FROM `players` WHERE `citizenid` = ?', { result[1].citizenid }, function(player)
                    local charinfo = json.decode(player[1].charinfo)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[1].citizenid,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then 
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('XZCore:Notify', src, "No vehicle around..", "error")
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", citizenid = "DSH091G93" },
        [2] = { name = "Jay Dendam", citizenid = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", citizenid = "DVH091T93" },
        [4] = { name = "Karel Bakker", citizenid = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", citizenid = "DRH09Z193" },
        [6] = { name = "Nico Wolters", citizenid = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", citizenid = "ODF09S193" },
        [8] = { name = "Bert Johannes", citizenid = "KSD0919H3" },
        [9] = { name = "Karel de Grote", citizenid = "NDX091D93" },
        [10] = { name = "Jan Pieter", citizenid = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", citizenid = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", citizenid = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", citizenid = "TEW0J9193" },
        [14] = { name = "Bart Rielink", citizenid = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", citizenid = "XZC091H93" },
        [16] = { name = "Aad Keizer", citizenid = "YDN091H93" },
        [17] = { name = "Thijn Kiel", citizenid = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", citizenid = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", citizenid = "QWE091A93" },
        [20] = { name = "Dries Stielstra", citizenid = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", citizenid = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", citizenid = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", citizenid = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", citizenid = "IOP091O93" },
        [25] = { name = "Renske de Raaf", citizenid = "PIO091R93" },
        [26] = { name = "Elior Dlux", citizenid = "LEK091X93" },
        [27] = { name = "Mirre Steevens", citizenid = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", citizenid = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", citizenid = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", citizenid = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

XZCore.Functions.CreateCallback('xz-phone:server:GetGarageVehicles', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)
    local Vehicles = {}

    exports.oxmysql.fetch("SELECT * FROM `xzvehicles` WHERE `citizenid` = ?", { Player.PlayerData.citizenid }, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local VehicleData = XZCore.Shared.Vehicles[GetHashKey(v.model)]
 
                if(VehicleData == nil) then
                    VehicleData = {
                        name = v.model
                    }
                end

                local VehicleGarage = "Unknown"
                if v.state ~= 'unknown' then
                    if v.state == 'garage' then
                        local parking = json.decode(v.parking)
                        VehicleGarage = parking[2]
                    elseif v.state == 'impound' then
                        VehicleGarage = 'Impound'
                    end
                end

                local stats = json.decode(v.stats)
                local vehdata = {
                    fullname = VehicleData["name"],
                    brand = VehicleData["name"],
                    model = VehicleData["name"],
                    plate = v.plate,
                    garage = VehicleGarage,
                    fuel = stats['fuel'],
                }

                table.insert(Vehicles, vehdata)
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)

XZCore.Functions.CreateCallback('xz-phone:server:HasPhone', function(source, cb)
    local Player = XZCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        local retval = false

        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

XZCore.Functions.CreateCallback('xz-phone:server:CanTransferMoney', function(source, cb, amount, iban)
    local Player = XZCore.Functions.GetPlayer(source)

    if (Player.PlayerData.money.bank - amount) >= 0 then
        local query = '%'..iban..'%'
        local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', { "%" .. iban .. "%" })
        if result[1] ~= nil then
            local Reciever = XZCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

            Player.Functions.RemoveMoney('bank', amount, "transfermoney-sender")

            if Reciever ~= nil then
                Reciever.Functions.AddMoney('bank', amount, "transfermoney-reciver")
            else
                local RecieverMoney = json.decode(result[1].money)
                RecieverMoney.bank = (RecieverMoney.bank + amount)
                exports.oxmysql:execute('UPDATE players SET money = ? WHERE citizenid = ?', { json.encode(RecieverMoney), result[1].citizenid })
            end
            cb(true)
        else
            TriggerClientEvent('XZCore:Notify', source, "This account number does not exist!", "error")
            cb(false)
        end
    end
end)

RegisterServerEvent('xz-phone:server:GiveContactDetails')
AddEventHandler('xz-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)

    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }

    TriggerClientEvent('xz-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterServerEvent('xz-phone:server:AddTransaction')
AddEventHandler('xz-phone:server:AddTransaction', function(data)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    exports.oxmysql:insert('INSERT INTO crypto_transactions (citizenid, title, message) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid, 
        escape_sqli(data.TransactionTitle),
        escape_sqli(data.TransactionMessage)
    })
end)

XZCore.Functions.CreateCallback('xz-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(XZCore.Functions.GetPlayers()) do
        local Player = XZCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "taxi" or Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty then
                table.insert(Lawyers, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name,
                })
            end
        end
    end
    cb(Lawyers)
end)

RegisterServerEvent('xz-phone:server:InstallApplication')
AddEventHandler('xz-phone:server:InstallApplication', function(ApplicationData)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[ApplicationData.app] = ApplicationData
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])

    -- TriggerClientEvent('xz-phone:RefreshPhone', src)
end)

RegisterServerEvent('xz-phone:server:RemoveInstallation', function(App)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[App] = nil
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])

    -- TriggerClientEvent('xz-phone:RefreshPhone', src)
end)

XZCore.Commands.Add("setmetadata", "Set Player Metadata (God Only)", {}, false, function(source, args)
	local Player = XZCore.Functions.GetPlayer(source)
	
	if args[1] ~= nil then
		if args[1] == "trucker" then
			if args[2] ~= nil then
				local newrep = Player.PlayerData.metadata["jobrep"]
				newrep.trucker = tonumber(args[2])
				Player.Functions.SetMetaData("jobrep", newrep)
			end
		end
	end
end, "god")

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

local VehiclePlate = 0
RegisterServerEvent('xz-phone:server:spawnVehicle', function(data)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    VehiclePlate = VehiclePlate + 1

    if Config.RentelVehicles[data.model] and Player.PlayerData.money.cash >= data.price then
        data['plate'] = 'RENT' .. VehiclePlate
        
        exports.oxmysql:executeSync("DELETE FROM `gloveboxitemsnew` WHERE plate = ?", { data.plate })
        TriggerEvent("inventory:server:clearGloveboxItems",  data.plate)
        TriggerClientEvent('xz-phone:client:spawnVehicle', src, data)
        
    else
        TriggerClientEvent('XZCore:Notify', src, "You don't have enough money.", 'error')
    end
end)

local BoatPlate = 0
RegisterServerEvent('xz-phone:server:spawnBoat', function(data)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    BoatPlate = BoatPlate + 1

    if Config.RentelBoats[data.model] and Player.PlayerData.money.cash >= data.price then
        data['plate'] = 'RENT' .. BoatPlate
        
        exports.oxmysql:executeSync("DELETE FROM `gloveboxitemsnew` WHERE plate = ?", { data.plate })
        TriggerEvent("inventory:server:clearGloveboxItems",  data.plate)
        TriggerClientEvent('xz-phone:client:spawnBoat', src, data)
    
    else
        TriggerClientEvent('XZCore:Notify', src, "You don't have enough money.", 'error')
    end
end)

XZCore.Functions.CreateCallback("xz-phone:server:restoreRental", function(source, cb, model, plate)
    local Player = XZCore.Functions.GetPlayer(source)
    local Items = Player.Functions.GetItemsByName("rentalpapers")
    local rentalPaperSlot

    for _, item in pairs(Items) do
        if(item.info.plate == plate) then
            rentalPaperSlot = item.slot
            break
        end
    end

    if(rentalPaperSlot == nil and Config.RentelVehicles[model].papers == true) then
        cb(false)
        TriggerClientEvent("XZCore:Notify", source, "You don't have rental papers for this car!", "error")
    else
        cb(true)
        Player.Functions.RemoveItem("rentalpapers", 1, rentalPaperSlot)
        Player.Functions.AddMoney("cash", Config.RentelVehicles[model].price / 2, "xz-phone:server:restoreRental")
    end
end)

RegisterServerEvent('xz-rentel:rentelPapers')
AddEventHandler('xz-rentel:rentelPapers', function(plate)
    local src = source
    local Player = XZCore.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.birthdate = Player.PlayerData.charinfo.birthdate
    info.gender = Player.PlayerData.charinfo.gender
    info.plate = plate

    Player.Functions.AddItem('rentalpapers', 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, {label = 'Rentel Papers', image = "document.png"}, 'add')
end)
