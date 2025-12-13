import SwiftUI

struct InstagramContainerView: View {
    let url: URL
    let userAgent: String
    let shouldUseSidebar: Bool
    
    @State private var status: Status = .checking
    
    enum Status: Equatable {
        case checking
        case available
        case unavailable
    }
    
    var body: some View {
        Group {
            switch status {
            case .checking:
                ProgressView()
                    .task { await checkAvailability() }
                
            case .available:
                InstagramPostsWebView(
                    url: url,
                    userAgent: userAgent,
                    shouldUseSidebar: shouldUseSidebar
                )
                
            case .unavailable:
                ContentUnavailableView(
                    "Estamos com um problema",
                    systemImage: "square.and.arrow.down.badge.xmark",
                    description: Text(
                        "No momento estamos com um problema técnico. Tente novamente mais tarde."
                    )
                )
            }
        }
    }
    
    private func checkAvailability() async {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            request.timeoutInterval = 8
            
            let (_, response) = try await URLSession.shared.data(for: request)
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if (200...399).contains(code) {
                status = .available
            } else {
                status = .unavailable
            }
        } catch {
            status = .unavailable
        }
    }
}
