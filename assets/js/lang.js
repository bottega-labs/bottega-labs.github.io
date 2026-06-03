(function () {
  var STORAGE_KEY = 'bl-lang';
  var SUPPORTED = ['ko', 'en'];

  function getLang() {
    var stored = localStorage.getItem(STORAGE_KEY);
    if (stored && SUPPORTED.indexOf(stored) !== -1) return stored;
    var browser = (navigator.language || 'ko').split('-')[0];
    return SUPPORTED.indexOf(browser) !== -1 ? browser : SUPPORTED[0];
  }

  function applyLang(lang) {
    document.querySelectorAll('[data-lang]').forEach(function (el) {
      el.style.display = el.getAttribute('data-lang') === lang ? '' : 'none';
    });
    document.querySelectorAll('[data-lang-btn]').forEach(function (btn) {
      btn.classList.toggle('active', btn.getAttribute('data-lang-btn') === lang);
    });
    document.documentElement.lang = lang;
  }

  window.setLang = function (lang) {
    if (SUPPORTED.indexOf(lang) === -1) return;
    localStorage.setItem(STORAGE_KEY, lang);
    applyLang(lang);
  };

  document.addEventListener('DOMContentLoaded', function () {
    applyLang(getLang());
  });
})();
