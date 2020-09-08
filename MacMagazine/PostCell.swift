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

class PostCell: AppTableViewCell {

    // MARK: - Properties -

    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var subheadlineLabel: UILabel!
    @IBOutlet private weak var lengthlineLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var favoriteImageView: FavoriteImageView!

    // MARK: - Methods -

    func configurePost(_ object: Post) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title ?? "Não especificado")."

        var defaultImage = "image_logo_feature\(Settings().darkModeimage)"
        if object.categorias?.contains("Destaques") == false {
            defaultImage = "image_logo\(Settings().darkModeimage)"
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
                subheadlineLabel?.accessibilityLabel = "Descrição: \(object.excerpt ?? "Não especificado")"
            }
        }

        favoriteImageView.alpha = (object.favorite ? 1 : 0)
        setFavoriteImageViewAccessibility(isEnabled: object.favorite)

        guard let artworkURL = object.artworkURL else {
            return
        }
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: defaultImage))

        headlineLabel?.alpha = (object.read ? 0.5 : 1)
        subheadlineLabel?.alpha = (object.read ? 0.5 : 1)
        thumbnailImageView.alpha = (object.read ? 0.5 : 1)
    }

    func configureSearchPost(_ object: XMLPost) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title)."

        var defaultImage = "image_logo_feature\(Settings().darkModeimage)"
        if object.categories.contains("Destaques") == false {
            defaultImage = "image_logo\(Settings().darkModeimage)"
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
                subheadlineLabel?.accessibilityLabel = "Descrição: \(object.excerpt)"
            }
        }

        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: defaultImage))

        favoriteImageView.isHidden = !object.favorite
        setFavoriteImageViewAccessibility(isEnabled: !object.favorite)
    }

    func configurePodcast(_ object: Post) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title ?? "Não especificado")."
        subheadlineLabel?.text = object.pubDate?.cellDate()
        // Expected date format: "01/01/2020"
        subheadlineLabel?.accessibilityLabel = "Postado: \(object.pubDate?.cellDate().toHeaderDate(with: "dd/MM/yyyy") ?? "Não especificado")."

        guard let duration = object.duration else {
            lengthlineLabel?.text = nil
            lengthlineLabel?.accessibilityLabel = ""
            return
        }

        lengthlineLabel?.text = "duração: \(duration)"
        lengthlineLabel?.accessibilityLabel = "Duração: \(duration.setTimeAccessibility())"

        favoriteImageView.alpha = (object.favorite ? 1 : 0)
        setFavoriteImageViewAccessibility(isEnabled: object.favorite)

        guard let artworkURL = object.artworkURL else {
            return
        }
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().darkModeimage)"))

        headlineLabel?.alpha = (object.read ? 0.5 : 1)
        subheadlineLabel?.alpha = (object.read ? 0.5 : 1)
        thumbnailImageView.alpha = (object.read ? 0.5 : 1)
        lengthlineLabel.alpha = (object.read ? 0.5 : 1)
    }

    func configureSearchPodcast(_ object: XMLPost) {
        headlineLabel?.text = object.title
        headlineLabel?.accessibilityLabel = "Título: \(object.title)."
        subheadlineLabel?.text = object.pubDate.toDate().cellDate()
        // Expected date format: "01/01/2020"
        subheadlineLabel?.accessibilityLabel = "Postado: \(object.pubDate.toDate().cellDate().toHeaderDate(with: "dd/MM/yyyy"))."
        lengthlineLabel?.text = object.duration.isEmpty ? nil : "duração: \(object.duration)"
        lengthlineLabel?.accessibilityLabel = object.duration.isEmpty ? "" : "Duração: \(object.duration.setTimeAccessibility())"

        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().darkModeimage)"))

        favoriteImageView.isHidden = true
        setFavoriteImageViewAccessibility(isEnabled: false)
    }

    private func setFavoriteImageViewAccessibility(isEnabled: Bool) {
        if isEnabled {
            favoriteImageView.isAccessibilityElement = true
            favoriteImageView.accessibilityLabel = "Post favoritado."
        } else {
            favoriteImageView.isAccessibilityElement = false
        }
    }
}
