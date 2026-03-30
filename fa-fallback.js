(function () {
    var FALLBACK = 'https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css';
    var loaded = false;

    function check() {
        var el = document.createElement('span');
        el.className = 'fa-solid fa-check';
        el.style.cssText = 'position:absolute;left:-9999px;visibility:hidden;font-size:72px';
        document.body.appendChild(el);
        var family = getComputedStyle(el).fontFamily.toLowerCase();
        document.body.removeChild(el);
        return family.indexOf('awesome') !== -1;
    }

    function inject() {
        if (loaded) return;
        loaded = true;
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = FALLBACK;
        document.head.appendChild(link);
    }

    setTimeout(function () {
        if (!check()) inject();
    }, 2000);
})();
