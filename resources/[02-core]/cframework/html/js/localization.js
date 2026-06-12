let translations = {};

function T(key) {
    return translations[key] ?? key
}

$(document).ready(function () {
    $.post("http://cframework/getTranslations", JSON.stringify({}), function(rTranslations) {
        translations = rTranslations;

        window.dispatchEvent(new Event('translationsReady'));
    });
});