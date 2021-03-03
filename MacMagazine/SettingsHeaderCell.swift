//
//  SettingsHeaderCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/09/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import UIKit

class SettingsHeaderCell: UITableViewHeaderFooterView {

    // MARK: - Properties -

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var subHeaderLabel: UILabel!
    @IBOutlet private weak var footerLabel: UITextView!

    // MARK: - Methods -

    func setHeader(_ text: String?) {
        headerLabel?.font = Settings().getMetricBoldFont(forTextStyle: .title2)

        headerLabel?.text = text
        subHeaderLabel?.text = "VERSÃO \(Settings().appVersion)"
    }

    var disclaimerAttributedString: NSAttributedString {
        guard let github = URL(string: "https://github.com/MacMagazine/app-iOS"),
              let kazzio = URL(string: "http://kazziosoftware.com") else {
            return NSMutableAttributedString()
        }

        let font = UIFont.preferredFont(forTextStyle: .caption1)

        let prefix = "MacMagazine é um "
        let prefixAttributedString = NSMutableAttributedString(string: prefix, attributes: [.font: font,
                                                                                            .foregroundColor: UIColor.label])

        let linkGithub = "projeto de código aberto no GitHub"
        let linkGithubAttributedString = NSMutableAttributedString(string: linkGithub,
                                                                   attributes: [.font: font,
                                                                                .link: github])

        let suffix = " liderado por Cassio Rossi, da "
        let suffixAttributedString = NSMutableAttributedString(string: suffix, attributes: [.font: font,
                                                                                            .foregroundColor: UIColor.label])

        let linkKazzio = "KazzioSoftware"
        let linkKazzioAttributedString = NSMutableAttributedString(string: linkKazzio,
                                                                   attributes: [.font: font,
                                                                                .link: kazzio])

        let endText = "."
        let endTextAttributedString = NSMutableAttributedString(string: endText, attributes: [.font: font,
                                                                                              .foregroundColor: UIColor.label])

        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(prefixAttributedString)
        fullAttributedString.append(linkGithubAttributedString)
        fullAttributedString.append(suffixAttributedString)
        fullAttributedString.append(linkKazzioAttributedString)
        fullAttributedString.append(endTextAttributedString)

        return fullAttributedString
    }

    var subscriptionAttributedString: NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .caption1)

        let text = "Assine o app para navegar por ele sem ver propagandas — ou, alternativamente, use o seu login de patrão (do Patreon ou do Catarse) para usufruir do mesmo benefício."
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: font,
                                                                                    .foregroundColor: UIColor.label])

        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(attributedString)
        return fullAttributedString
    }

    func showFooter(type: FooterType) {
        if type == .disclaimer {
            footerLabel?.attributedText = disclaimerAttributedString
        } else {
            footerLabel?.attributedText = subscriptionAttributedString
        }
        footerLabel?.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MMBlue") ?? UIColor.systemBlue]
    }

    func footerHeight(width: CGFloat, type: FooterType) -> CGFloat {
        var height: CGFloat = 0

        switch type {
            case .disclaimer:
                height = disclaimerAttributedString.string.height(withWidth: width,
                                                                  font: UIFont.preferredFont(forTextStyle: .caption1))

            default:
                height = subscriptionAttributedString.string.height(withWidth: width,
                                                                    font: UIFont.preferredFont(forTextStyle: .caption1))
        }

        return height + 36 + 24
    }

}

enum FooterType {
    case disclaimer
    case subscription
}
