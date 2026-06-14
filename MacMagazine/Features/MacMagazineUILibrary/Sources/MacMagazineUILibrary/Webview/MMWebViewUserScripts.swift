import Foundation
import WebKit

public enum MMWebViewUserScripts {
    @MainActor
    static var topPadding: WKUserScript {
        WKUserScript(
            source: """
                (function() {
                  var style = document.createElement('style');
                  style.innerHTML = `
                    html, body {
                      padding-top: 50px !important;
                    }
                  `;
                  document.head.appendChild(style);
                })();
                """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    static var disableGallery: WKUserScript {
        WKUserScript(
            source: """
            var links = document.getElementsByClassName('fancybox');
            for(var i = 0; i < links.length; i++) {
                links[i].href = 'javascript:void(0);return false;';
            }
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    static var disableNewGallery: WKUserScript {
        WKUserScript(
            source: """
            var links = document.getElementsByClassName('pk-image-popup');
            for(var i = 0; i < links.length; i++) {
                links[i].href = 'javascript:void(0);return false;';
            }
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    static var galleryStateObserver: WKUserScript {
        WKUserScript(
            source: """
            (function() {
                if (window.__mmGalleryObserver) { return; }
                var selectors = '.pswp--open, .fancybox-container, #fancybox-overlay, .mfp-wrap';
                var lastState = null;
                function check() {
                    var open = !!document.querySelector(selectors);
                    if (open !== lastState) {
                        lastState = open;
                        window.webkit.messageHandlers.mmGalleryState.postMessage(open);
                    }
                }
                var observer = new MutationObserver(check);
                observer.observe(document.documentElement, {
                    attributes: true,
                    childList: true,
                    subtree: true,
                    attributeFilter: ['class', 'style']
                });
                window.__mmGalleryObserver = observer;
                check();
            })();
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    public static var hideSiteHeader: WKUserScript {
        WKUserScript(
            source: """
                (function() {
                  var style = document.createElement('style');
                  style.innerHTML = `
                    header, .pk-navbar, .pk-header {
                      display: none !important;
                    }
                    body {
                      margin-top: 0 !important;
                      padding-top: 0 !important;
                    }
                  `;
                  document.head.appendChild(style);
                })();
                """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    public static var removeBackToBlog: WKUserScript {
        WKUserScript(
            source: """
            document.getElementById('backtoblog').outerHTML = '';
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    @MainActor
    static var interceptNewWindows: WKUserScript {
        WKUserScript(
            source: """
                (function() {
                    window.open = function(url, target, features) {
                        if (url && url.length > 0) {
                            window.webkit.messageHandlers.newWindowHandler.postMessage(url);
                        }
                        return null;
                    };
                    document.addEventListener('click', function(e) {
                        var anchor = e.target.closest('a[target="_blank"]');
                        if (anchor && anchor.href) {
                            e.preventDefault();
                            e.stopPropagation();
                            window.webkit.messageHandlers.newWindowHandler.postMessage(anchor.href);
                        }
                    }, true);
                })();
                """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
    }
}
