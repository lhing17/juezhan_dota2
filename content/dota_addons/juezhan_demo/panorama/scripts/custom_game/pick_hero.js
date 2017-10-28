var gold = [];
gold[0] = "fd29154c18f6e3dc094a21b56d8bc075";
gold[1] = "99a72195d9106f09c2d7701fad8136b8";
gold[2] = "a55cef978fe4168f7dd354477cb7206d";
gold[3] = "31502c089790c3bfa475044e18cf5a22";
gold[4] = "544c6f33b516edf9b9227fff2e26da11";
gold[5] = "c278690288c38a1ceed42542bf3f42eb";
gold[6] = "9ac4233ca17c5d4ee3bf1aff98f4b215";
gold[7] = "7479d7d32ead62cf48ca429f1b04e1ab";
gold[8] = "23388fc2c35179c18560ddacbc980070";
var potion = [];
potion[0] = "599473233c4f4721ccecffe1465978d5";
potion[1] = "1abe84b8218b34a256e996a2bbb42b74";
potion[2] = "20277f0361e2de46695b179ed6e9c1f5";
potion[3] = "3c99cea113475ad46c3c670c40f6ea5a";
potion[4] = "e7591771f1a97baf9febb0d8130bce39";
potion[5] = "e6d29d6863a7820ae06871d24dd09913";
potion[6] = "d57f089be99286616821f6de188a5eb4";
potion[7] = "ab613b54afc7c9f3001de4e47329c23a";
potion[8] = "ece6d041cce169ae98ccd2a0eb819035";
var password = [];
password[0] = "dc1dd5a214cf8c8b7a4bce4f7463819f";
password[1] = "2680114880839055905cc614d1f1a2d5";
password[2] = "b0a47480df945c8d7a78ae3af7d2fc1a";
password[3] = "cd1a126d09226ba9faa003d3f8c2128a";
password[4] = "7adcd18347f2f6a42e05ad08018a9ef7";
password[5] = "601f4a90e90e2b1ad8c2e90c065ee2ed";
password[6] = "ab320563f7b5912eb0c2b34df20e3a67";
password[7] = "e1f19f24ecfc205763f4f36b051a3e9a";
password[8] = "2aaafbb6d52f69ebfed8632f6b1ff1b8";
var revelater_pre = [];
revelater_pre[0] = "00557c4013a7c2d5e10a28f7f3740f2e";
revelater_pre[1] = "0a690e54758de6a5e17a29259a5e5f52";
revelater_pre[2] = "31281e284bdd72aafe63cc738f7ea7f6";
revelater_pre[3] = "cf275b7933c25ecb37a81663064e4dc8";
revelater_pre[4] = "af18f27e879b06ebc34dd3f08f3f908c";
revelater_pre[5] = "3ce497db001811ca4dbe9808c9f285dc";
revelater_pre[6] = "bd898faf6d7607fae0e40bf42fa901ab";
revelater_pre[7] = "307ce63229dde6801bb98632c5dc320d";
revelater_pre[8] = "e679c921d737b049c04715c0a8c27a78";
var revelater = [];
revelater[0] = "500f29c43d9963de2a46aaf401f77d31";
revelater[1] = "51cbf7549ff57c6025b7cee62b6b9cf4";
revelater[2] = "615b325e3e0fefd027d0e82bbcff15dc";
revelater[3] = "bd16d1d43708bdca3842c5c7855a41de";
revelater[4] = "9b538a4299b9c6b50dda664ff289259b";
revelater[5] = "de7e4b62a7f972ee58d22696e9918efe";
revelater[6] = "a0cd4d17763c9909fba2c6dc683e7d80";
revelater[7] = "06e809538af3c237a2ae4ed55f37bd3f";
revelater[8] = "fe69c4c928fbed16f78bfbe406728208";
var allHeroes = [];
allHeroes[0] = "npc_dota_hero_juggernaut";
allHeroes[1] = "npc_dota_hero_windrunner";
allHeroes[2] = "npc_dota_hero_sven";
allHeroes[3] = "npc_dota_hero_lina";
allHeroes[4] = "npc_dota_hero_kunkka";
allHeroes[5] = "npc_dota_hero_crystal_maiden";
allHeroes[6] = "npc_dota_hero_ancient_apparition";

var lockHeroes = [];
var unlockHeroes = [];
var lockImages = [];
lockHeroes[0] = "npc_dota_hero_crystal_maiden";
lockHeroes[1] = "npc_dota_hero_ancient_apparition";
var allDifficulty = [];
allDifficulty[0] = "EasyButton";
allDifficulty[1] = "NormalButton";
allDifficulty[2] = "HardButton";
allDifficulty[3] = "DemonButton";
allDifficulty[4] = "TeamButton";
allDifficulty[5] = "NightmareButton";
var activeDifficulty = null;
var heroPreviews = [];
var activePreview = null;
var activeHeroCard = null;
var HeroSelectionTime = 10;
var StartGameTime = null;
var HeroConfirm = false;
var currentHero = null;
var SelectedHeroName = "npc_dota_hero_wisp";

var denominations = [];
denominations[0] = "ShaoLin";
denominations[1] = "WuDang";
denominations[2] = "HuaShan";
denominations[3] = "GuMu";
denominations[4] = "XingXiu";
denominations[5] = "QuanZhen";
var activeDenomination = null;
var selectOver = false;

function OnDenominationCardMouseOver(denominationName) {
    var denominationCard = $("#" + denominationName);
    denominationCard.AddClass("FullColor");
}

function OnDenominationCardMouseOut(denominationName) {
    var denominationCard = $("#" + denominationName);
    denominationCard.RemoveClass("FullColor");
}

function OnDenominationCardActive(denominationName) {
    if (selectOver == false){
        activeDenomination.RemoveClass("SelectColor");
        var button = $("#" + denominationName);
        button.AddClass("SelectColor");
        activeDenomination = button;
    }
}


function OnHeroCardMouseOver(heroname) {
    var heroCardPlane = $("#" + heroname);
    heroCardPlane.AddClass("FullColor");
    var panel = $.CreatePanel("Label", heroCardPlane, "");
    panel.AddClass("HeroCardTip");
    panel.text = $.Localize("#" + heroname);
}

function OnHeroCardMouseOut(heroname) {
    var heroCardPlane = $("#" + heroname);
    heroCardPlane.RemoveClass("FullColor");
    DeleteChildrenWithClass(heroCardPlane, "HeroCardTip");
}

function OnHeroCardActive(heroname) {
    for (var lockHero of lockHeroes) {
        if (lockHero == heroname) {
            return;
        }
    }
    if (HeroConfirm == false) {
        GameEvents.SendCustomGameEventToServer("selection_hero_click", {"hero": heroname});
        activeHeroCard.RemoveClass("SelectColor");
        activePreview.style.visibility = "collapse";
        heroPreviews[heroname].style.visibility = "visible";
        activePreview = heroPreviews[heroname];
        $("#HeroName").text = $.Localize("#" + heroname);
        $("#" + heroname).AddClass("SelectColor");
        activeHeroCard = $("#" + heroname);
        currentHero = heroname;
    }
}

function OnButtonMouseOver(buttonname) {
    var button = $("#" + buttonname);
    button.AddClass("FullColor");
}

function OnButtonMouseOut(buttonname) {
    var button = $("#" + buttonname);
    button.RemoveClass("FullColor");
}

function OnButtonActive(buttonname) {
    /*$.Msg(buttonname);*/
    if (selectOver == false){
        activeDifficulty.RemoveClass("SelectColor");
        var button = $("#" + buttonname);
        button.AddClass("SelectColor");
        activeDifficulty = button;
    }
}


// 为英雄卡添加鼠标点击、悬停、离开事件
function AddHeroCardEvents(heroname) {
    var panel = $("#" + heroname);
    panel.SetPanelEvent("onactivate", function () {
        OnHeroCardActive(heroname);
    });
    panel.SetPanelEvent("onmouseover", function () {
        OnHeroCardMouseOver(heroname);
        GameEvents.SendCustomGameEventToServer("selection_hero_hover", {"hero": heroname});
    });
    panel.SetPanelEvent("onmouseout", function () {
        OnHeroCardMouseOut(heroname);
        GameEvents.SendCustomGameEventToServer("selection_hero_hover", {"hero": "null"});
    });
}

// 为难度按钮添加标点击、悬停、离开事件
function AddButtonEvents(buttonname) {
    var panel = $("#" + buttonname);
    panel.SetPanelEvent("onactivate", function () {
        OnButtonActive(buttonname);
        GameEvents.SendCustomGameEventToServer("selection_difficulty_click", {"difficulty": buttonname});
    });
    panel.SetPanelEvent("onmouseover", function () {
        OnButtonMouseOver(buttonname);
    });
    panel.SetPanelEvent("onmouseout", function () {
        OnButtonMouseOut(buttonname);
    });
}

function AddDenominationEvents(denomination) {
    $.Msg(denomination);
    var panel = $("#" + denomination);
    panel.SetPanelEvent("onactivate", function () {
        OnDenominationCardActive(denomination);
        GameEvents.SendCustomGameEventToServer("selection_denomination_click", {"denomination": denomination});
    });
    panel.SetPanelEvent("onmouseover", function () {
        OnDenominationCardMouseOver(denomination);
    });
    panel.SetPanelEvent("onmouseout", function () {
        OnDenominationCardMouseOut(denomination);
    });
}


// 开始选择英雄
function PickHeroInit() {
    $.Msg("starting pick hero");
    //预载入所有英雄卡牌与预览
    for (var hero of allHeroes) {
        AddHeroCardEvents(hero);
        var preview = $.CreatePanel("Panel", $("#HeroesScene"), "");
        preview.BCreateChildren('<DOTAScenePanel style="width: 1060px; height: 1060px;" unit="' + hero + '"/>', false, false);
        preview.AddClass("HeroScene");
        preview.style.visibility = "collapse";
        heroPreviews[hero] = preview;
    }
    //添加难度按钮事件
    for (var button of allDifficulty) {
        AddButtonEvents(button);
    }
    //锁定隐藏英雄
    for (var lockHero of lockHeroes) {
        var lock = $("#" + lockHero);
        var preview = $.CreatePanel("Image", lock, "");
        preview.SetImage("file://{images}/custom_game/lock.png");
        lockImages[lockHero] = preview;
    }

    $.Msg("starting select denomination");
    for (var denomination of denominations) {
        AddDenominationEvents(denomination);
    }
    //初始英雄
    heroPreviews["npc_dota_hero_juggernaut"].style.visibility = "visible";
    activePreview = heroPreviews["npc_dota_hero_juggernaut"];
    currentHero = "npc_dota_hero_juggernaut";
    activeDifficulty = $("#NormalButton");
    activeDenomination = $("#ShaoLin");
    activeDenomination.AddClass("SelectColor");
    activeHeroCard = $("#npc_dota_hero_juggernaut");
    activeHeroCard.AddClass("SelectColor");
    activeDifficulty.AddClass("SelectColor");
    $("#HeroName").text = $.Localize("#npc_dota_hero_juggernaut");
}

function DeleteChildrenWithClass(panel, elClass) {
    var elements = panel.FindChildrenWithClassTraverse(elClass);
    for (var i = 0; i < elements.length; i++) {
        elements[i].DeleteAsync(0);
    }
}

function OnHeroConfirmClick() {
    if (selectOver == false){
        HeroConfirm = true;
        SelectedHeroName = currentHero;
        selectOver = true;
        GameEvents.SendCustomGameEventToServer("selection_difficulty_click", {"difficulty": activeDifficulty.id});
        GameEvents.SendCustomGameEventToServer("selection_denomination_click", {"denomination": activeDenomination.id});
        GameEvents.SendCustomGameEventToServer("hero_selected", {"hero": SelectedHeroName});
        $("#HeroSelect").text = $.Localize("#SelectOver");
        $("#HeroConfirmButton").enabled(false);
    }
}

function OnHeroConfirmOver() {
    Game.EmitSound("ui_friends_slide_in");
}

function OnHeroConfirmOut() {
    Game.EmitSound("ui_friends_slide_in");
}

function TimeRemaining() {
    if (HeroSelectionTime >= 0) { //剩余时间大于0，刷新剩余时间
        $("#TimerText").text = HeroSelectionTime;
        var game_time = Math.floor(Game.GetGameTime());
        var time = game_time - StartGameTime;
        HeroSelectionTime = 10 - time;
        //$.Msg("time:" + game_time);
        $.Schedule(0.1, TimeRemaining);
    } else {
        if (selectOver == false) {
            HeroConfirm = true;
            SelectedHeroName = currentHero;
            selectOver = true;
            GameEvents.SendCustomGameEventToServer("selection_difficulty_click", {"difficulty": activeDifficulty.id});
            GameEvents.SendCustomGameEventToServer("selection_denomination_click", {"denomination": activeDenomination.id});
            GameEvents.SendCustomGameEventToServer("hero_selected", {"hero": SelectedHeroName});
        }
        $("#HeroSelectionBackground").style.visibility = "collapse";
    }
}

function OnSubmitted() {
    var inputword = $('#password').text;
    var inputwordmd5 = hex_md5(hex_md5(inputword));
    for (var i = 0; i < 9; i++) {
        if (password[i] == inputwordmd5) {
            $('#password').text = "";
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_crystal_maiden"].style.visibility = "collapse";
            unlockHeroes[0] = "npc_dota_hero_crystal_maiden";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for (var i = 0; i < 9; i++) {
        if (revelater_pre[i] == inputwordmd5) {
            $('#password').text = "";
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_ancient_apparition"].style.visibility = "collapse";
            unlockHeroes[1] = "npc_dota_hero_ancient_apparition";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for (var i = 0; i < 9; i++) {
        //$.Msg(inputword);
        if (revelater[i] == inputwordmd5) {
            $('#password').text = "";
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_templar_assassin"].style.visibility = "collapse";
            unlockHeroes[1] = "npc_dota_hero_templar_assassin";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for (var i = 0; i < 9; i++) {
        if (gold[i] == inputwordmd5) {
            GameEvents.SendCustomGameEventToServer("gold_gift", {index: i});
            $('#password').text = "";
            Game.EmitSound("ui_chat_msg_send");
            break;
        }
    }
    for (var i = 0; i < 9; i++) {
        if (potion[i] == inputwordmd5) {
            GameEvents.SendCustomGameEventToServer("gift_potion", {index: i});
            $('#password').text = "";
            Game.EmitSound("ui_chat_msg_send");
            break;
        }
    }
    //$.Msg(password);
}

function VIPUnlock() {
    lockImages["npc_dota_hero_crystal_maiden"].style.visibility = "collapse";
    lockHeroes[0] = null;
    unlockHeroes[0] = "npc_dota_hero_crystal_maiden";
    lockImages["npc_dota_hero_ancient_apparition"].style.visibility = "collapse";
    lockHeroes[1] = null;
    unlockHeroes[1] = "npc_dota_hero_ancient_apparition";
}

// 立即执行的部分
(function () {
    GameEvents.Subscribe("vip", VIPUnlock); // 登记事件，并由对应函数处理

    // if (Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME ))
    // {
    //     $("#HeroSelectionBackground").style.visibility = "show";
    // }
    // else {
    StartGameTime = Math.floor(Game.GetGameTime());
    TimeRemaining(); //显示剩余时间
    PickHeroInit();
    //}
})();