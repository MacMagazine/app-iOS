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
}
