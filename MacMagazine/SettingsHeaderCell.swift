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

    var createDisclaimerAttributedString: NSAttributedString {
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

    func showDisclaimerFooter() {
        footerLabel?.attributedText = createDisclaimerAttributedString
        footerLabel?.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MMBlue") ?? UIColor.systemBlue]
    }

    func disclaimerHeight(width: CGFloat) -> CGFloat {
        let height = createDisclaimerAttributedString.string.height(withWidth: width,
                                                                    font: UIFont.preferredFont(forTextStyle: .caption1))
        return height + 36 + 24
    }
}
