window.addEventListener('DOMContentLoaded', (event) => {
    const elxsPopupAdmin = {
        initialized: false,
        popupSelectors: {
            commonWrap: "[data-popup]",
            activeClass: "popup-show",
        },
        navigationList: {
            ENABLE_BOOKSTACK: {
                url: '/bookstack',
                title: 'Praxishandbuch',
            },
            ENABLE_ROCKETCHAT: {
                url: '/chat',
                title: 'Chat',
            },
            ENABLE_NEXTCLOUD: {
                url: '/cloud',
                title: 'Dateien',
            },
            ENABLE_ELEXIS_RAP: {
                url: '/rap',
                title: 'RAP',
            },
            ENABLE_SOLR: {
                url: '/solr',
                title: 'SOLR',
            },
            ENABLE_OCRMYPDF: {
                url: '/ocrmypdf',
                title: 'OCRmyPDF',
            },
        },
        loadPopupNodeList() {
            return document.querySelectorAll(this.popupSelectors.commonWrap);
        },
        run() {
            if (this.initialized) {
                return false;
            }
            for (const [key, item] of Object.entries(this.navigationList)) {
                const popupNodeList = this.loadPopupNodeList();
                if (item.url === window.location.pathname) {
                    popupNodeList.forEach((el) => {
                        if (el.dataset.popup === key) {
                            el.classList.add(this.popupSelectors.activeClass);
                        }
                    })
                }
                this.initialized = true;
            }
        },
    };
    elxsPopupAdmin.run();

});
