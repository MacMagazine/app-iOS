//
//  API.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

@MainActor
public final class API {
    public static let shared = API()
    private init() {}
    
    internal let base = "https://macmagazine.com.br"
    internal let json = "https://macmagazine.com.br/?json="
    internal let feed = "https://macmagazine.com.br/feed/"
    internal let podcastFeed = "https://macmagazine.com.br/podcast/feed/"
}
