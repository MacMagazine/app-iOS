//
//  PostCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Kingfisher
import UIKit

class HeaderCell: UITableViewHeaderFooterView {

    // MARK: - Properties -

    @IBOutlet private weak var headerLabel: UILabel!

    // MARK: - Methods -

    func setHeader(_ text: String?) {
        headerLabel?.text = text
        headerLabel?.accessibilityLabel = text?.setHeaderDateAccessibility()
    }
}

class PostCell: UITableViewCell {

    // MARK: - Properties -

    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var subheadlineLabel: UILabel!
    @IBOutlet private weak var durationLabel: PaddingLabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var favoriteImageView: UIImageView!

    // MARK: - Methods -

    func configurePost(_ object: Post) {
        setContent(object)
    }

    func configurePodcast(_ object: Post) {
        setContent(object, isPodcast: true)
    }

    func configureSearchPost(_ object: XMLPost) {
        setContent(object)
    }

    func configureSearchPodcast(_ object: XMLPost) {
        setContent(object, isPodcast: true)
    }
}

extension PostCell {
    fileprivate func setContent(_ object: Post, isPodcast: Bool = false) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title ?? "Não especificado")."

        favoriteImageView.alpha = (object.favorite ? 1 : 0)

        headlineLabel?.alpha = (object.read ? Settings().transparency : 1)
        subheadlineLabel?.alpha = (object.read ? Settings().transparency : 1)
        thumbnailImageView?.alpha = (object.read ? Settings().transparency : 1)
        durationLabel?.alpha = (object.read ? Settings().transparency : 0.90)

        guard let artworkURL = object.artworkURL else {
            return
        }
        thumbnailImageView.kf.indicatorType = .activity

        var defaultImage = "image_logo_feature"
        if object.categorias?.contains("Destaques") == false &&
            !isPodcast {
            defaultImage = "image_logo"
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
                subheadlineLabel?.accessibilityLabel = "Descrição: \(object.excerpt ?? "Não especificado")"
            }
        } else if isPodcast {
            subheadlineLabel?.text = object.pubDate?.cellDate()
            subheadlineLabel?.accessibilityLabel = "Postado em: \(object.pubDate?.cellDate().toHeaderDate(with: "dd/MM/yyyy") ?? "Não especificado")."
        }

        thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: defaultImage))

        guard let duration = object.duration else {
            durationLabel?.text = nil
            durationLabel?.accessibilityLabel = ""
            return
        }

        durationLabel?.text = "\(duration)"
        durationLabel?.accessibilityLabel = "Duração do podcast: \(duration.toAccessibilityTime())"
    }

    fileprivate func setContent(_ object: XMLPost, isPodcast: Bool = false) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title)."

        var defaultImage = "image_logo_feature"
        if object.categories.contains("Destaques") == false &&
            !isPodcast {
            defaultImage = "image_logo"
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
                subheadlineLabel?.accessibilityLabel = "Descrição: \(object.excerpt)"
            }
        } else if isPodcast {
            subheadlineLabel?.text = object.pubDate.toDate().cellDate()
            subheadlineLabel?.accessibilityLabel = "Postado em: \(object.pubDate.toDate().cellDate().toHeaderDate(with: "dd/MM/yyyy"))."
        }

        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: defaultImage))

        durationLabel?.text = object.duration.isEmpty ? nil : "\(object.duration)"
        durationLabel?.accessibilityLabel = object.duration.isEmpty ? "" : "Duração do podcast: \(object.duration.toAccessibilityTime())"

        favoriteImageView.isHidden = !object.favorite
    }
}
