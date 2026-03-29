(function () {
    'use strict';
    var mount = document.getElementById('site-nav');
    if (!mount) return;

    function loadScript(src) {
        return new Promise(function (resolve, reject) {
            var s = document.createElement('script');
            s.src = src;
            s.async = false;
            s.onload = resolve;
            s.onerror = function () {
                reject(new Error('load failed'));
            };
            document.head.appendChild(s);
        });
    }

    function ensureSupabase() {
        if (typeof _supabase !== 'undefined') {
            return Promise.resolve();
        }
        var p =
            typeof supabase !== 'undefined'
                ? Promise.resolve()
                : loadScript('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2');
        return p
            .then(function () {
                return loadScript('supabase-config.js');
            })
            .then(function () {
                return new Promise(function (resolve, reject) {
                    var n = 0;
                    var t = setInterval(function () {
                        if (typeof _supabase !== 'undefined') {
                            clearInterval(t);
                            resolve();
                        } else if (++n > 150) {
                            clearInterval(t);
                            reject(new Error('supabase timeout'));
                        }
                    }, 20);
                });
            });
    }

    function updateNavAuthLink() {
        var link = document.querySelector('#site-nav .nav-auth-link');
        if (!link || typeof _supabase === 'undefined') {
            return Promise.resolve();
        }
        return _supabase.auth.getUser().then(function (result) {
            if (result.data && result.data.user) {
                link.href = 'account.html';
                link.textContent = '帐号';
            } else {
                link.href = 'login.html';
                link.textContent = '登录';
            }
        });
    }

    fetch('nav.html')
        .then(function (r) {
            if (!r.ok) throw new Error('nav fetch failed');
            return r.text();
        })
        .then(function (html) {
            mount.innerHTML = html;
            return ensureSupabase().catch(function () {});
        })
        .then(function () {
            return updateNavAuthLink().catch(function () {});
        })
        .catch(function () {
            mount.innerHTML = '';
        });
})();
