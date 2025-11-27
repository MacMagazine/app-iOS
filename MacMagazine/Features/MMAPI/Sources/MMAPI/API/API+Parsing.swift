//
//  API+Parsing.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

internal extension API {
    
    func parseXMLPosts(from data: Data) throws -> [XMLPost] {
        var posts: [XMLPost] = []
        let parser = XMLParser(data: data)
        let xmlParser = APIXMLParser(onCompletion: { post in
            if let post = post {
                posts.append(post)
            }
        }, numberOfPosts: 0)
        parser.delegate = xmlParser
        if parser.parse() == false {
            throw APIError.xmlParsing
        }
        return posts
    }
}
