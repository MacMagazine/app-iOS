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
    static var comments: WKUserScript {
        WKUserScript(
            source: """
            var comments = document.querySelectorAll('[data-disqus-identifier]');
            window.webkit.messageHandlers.gotCommentURLHandler.postMessage(comments[0].dataset.disqusIdentifier);
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
}
