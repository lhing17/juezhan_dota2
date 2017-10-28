"use strict";

function updateDenomination(data) {
    $.Msg("denomination data:", data);
    var denomination = data.denomination;
    var denominationLabel = $("#denominationValue");
    denominationLabel.text = $.Localize("#" + denomination);
}

(function () {
    GameEvents.Subscribe("denomination", updateDenomination);
})()
