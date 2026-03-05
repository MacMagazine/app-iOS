import Foundation
import WebKit

enum MMWebViewUserScripts {
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
    static var tapToZoom: WKUserScript {
        WKUserScript(
            source: """
            var images = document.querySelectorAll('[data-full-url]');
            for(var i = 0; i < images.length; i++) {
                images[i].addEventListener("click", function() {
                    window.webkit.messageHandlers.imageTappedHandler.postMessage(this.dataset.fullUrl);
                }, false);
            }
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
    static var removeBackToBlog: WKUserScript {
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
