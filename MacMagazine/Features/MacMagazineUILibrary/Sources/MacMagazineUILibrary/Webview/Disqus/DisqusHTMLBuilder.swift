import SwiftUI

enum DisqusHTMLBuilder {
    static func makeHTML(commentsURL: String, colorScheme: ColorScheme) -> String {
        let backgroundColor = colorScheme == .dark ? "black" : "none"
        let linkColor = colorScheme == .dark ? "white" : "#0096D3"

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                body {
                    margin: 0;
                    padding: 16px;
                    font-family: -apple-system, system-ui, sans-serif;
                    background-color: \(backgroundColor);
                }
                a { color: \(linkColor); }
            </style>
        </head>
        <body>
            <div id="disqus_thread"></div>
            <script>
                var disqus_identifier = '\(commentsURL)';
                var disqus_shortname = 'macmagazinecombr';
                (function() {
                    var dsq = document.createElement('script');
                    dsq.type = 'text/javascript';
                    dsq.async = true;
                    dsq.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
                    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
                })();
            </script>
        </body>
        </html>
        """
    }
}
