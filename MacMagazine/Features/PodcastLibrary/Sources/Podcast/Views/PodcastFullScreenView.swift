//
//  PodcastFullScreenView.swift
//  PodcastLibrary
//
//  Created by Renato Ferraz on 11/12/25.
//

import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct PodcastFullScreenView: View {
    @Environment(\.theme) private var theme: ThemeColor

    let manager: PodcastPlayerManager
    let animation: Namespace.ID
    let onDismiss: () -> Void

    public init(
        manager: PodcastPlayerManager,
        animation: Namespace.ID,
        onDismiss: @escaping () -> Void
    ) {
        self.manager = manager
        self.animation = animation
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            PodcastPlayerView(playerManager: manager)
                .ignoresSafeArea()
                .navigationTransition(.zoom(sourceID: "MINIPLAYER", in: animation))

            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.secondary.opacity(0.6))
                    .frame(width: 60, height: 4)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                Spacer()
            }
        }
    }
}
