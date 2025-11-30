class Translator {
    constructor() {
        this.currentLang = localStorage.getItem('lang') || 'es';
        this.translations = {};
        this.init();
    }

    async init() {
        try {
            const path = window.location.pathname.includes('/admin/') ? '../../js/translations.json' : 'js/translations.json';
            const response = await fetch(path);
            this.translations = await response.json();
            this.translatePage();
            this.updateButtonState();
        } catch (error) {
            console.error('Error loading translations:', error);
        }
    }

    toggleLanguage() {
        this.currentLang = this.currentLang === 'es' ? 'en' : 'es';
        localStorage.setItem('lang', this.currentLang);
        this.translatePage();
        this.updateButtonState();
    }

    translatePage() {
        const elements = document.querySelectorAll('[data-i18n]');
        elements.forEach(element => {
            const key = element.getAttribute('data-i18n');
            const translation = this.getTranslation(key);
            
            if (translation) {
                if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                    if (element.placeholder) {
                        element.placeholder = translation;
                    }
                } else {
                    if (element.children.length > 0) {

                        let textNode = null;
                        for (let node of element.childNodes) {
                            if (node.nodeType === Node.TEXT_NODE && node.textContent.trim().length > 0) {
                                textNode = node;
                                break;
                            }
                        }
                        
                        if (textNode) {
                            textNode.textContent = ' ' + translation + ' '; 
                        } else {

                        }
                    } else {
                        element.innerHTML = translation;
                    }
                }
            }
        });
    }

    getTranslation(key) {
        if (this.translations[this.currentLang] && this.translations[this.currentLang][key]) {
            return this.translations[this.currentLang][key];
        }
        return null;
    }

    updateButtonState() {
        const btn = document.getElementById('langToggle');
        if (btn) {
            const flag = this.currentLang === 'es' ? '🇺🇸' : '🇪🇸';
            btn.innerHTML = `<span style="font-size: 1.5rem;">${flag}</span>`;
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    window.translator = new Translator();

    const btn = document.getElementById('langToggle');
    if (btn) {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            window.translator.toggleLanguage();
        });
    }
});
