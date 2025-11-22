import Combine
import MessageUI

final class AboutViewModel {
    enum ButtonAction: Equatable {
        case terms
        case privacy
        case none

        var title: String {
            switch self {
            case .terms: "Termos de Uso"
            case .privacy: "Política de Privacidade"
            case .none: ""
            }
        }

        var url: String {
            switch self {
            case .terms: URLs.terms
            case .privacy: URLs.privacy
            case .none: ""
            }
        }
    }

    let delegate = MailDelegate()
}

extension AboutViewModel {
    @MainActor
    func composeMessage() {
        let destination = "contato@macmagazine.com.br"
        let subject = "Relato de problema no app MacMagazine \(Bundle.version ?? "versão desconhecida")"
        let body = """
Olá MM, gostaria de reportar um problema no app.

- O que aconteceu:


- Passos para reproduzir o problema:


- Resultado esperado:


- Resultado atual:


- Anexos:
"""

        guard MFMailComposeViewController.canSendMail() else {
            if let url = URL(string: "mailto:\(destination)?subject=\(subject)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = delegate
        composeVC.setSubject(subject)
        composeVC.setToRecipients([destination])
        composeVC.setMessageBody(body, isHTML: false)

        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last?.rootViewController?.present(composeVC,
                                                                                                                  animated: true,
                                                                                                                  completion: nil)
    }
}

// MARK: - Mail Methods -

class MailDelegate: NSObject, @preconcurrency MFMailComposeViewControllerDelegate {
    @MainActor
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true)
    }
}
