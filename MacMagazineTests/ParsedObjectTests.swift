//
//  ParsedObjectTests.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 26/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import XCTest

// Tests to be performed:
// 1) Create a mock test
// 2) Test for the content of the mock data, adding to the XMLPost class

class ParsedObjectTests: XCTestCase {

	var postExample: Data?

	override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		guard let post = getExamplePost() else {
			return
		}
		postExample = post
    }

	override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testGetPost() {
		XCTAssertNotNil(postExample, "Example post should exist")
	}

	func testParseExample() {
		guard let post = postExample else {
			XCTFail("Example post should exist")
			return
		}

		let expectation = self.expectation(description: "Testing API for a valid XML...")
		expectation.expectedFulfillmentCount = 2

		let onCompletion = { (post: XMLPost?) in
			guard let post = post else {
				expectation.fulfill()
				return
			}

			XCTAssertEqual(post.title, "Novo app garante que todos os seus contatos do iPhone tenham fotos atualizadas", "API response title must match")
			XCTAssertEqual(post.link, "https://macmagazine.uol.com.br/2019/05/23/novo-app-garante-que-todos-os-seus-contatos-do-iphone-tenham-fotos-atualizadas/", "API response link should must match")
			XCTAssertEqual(post.pubDate, "Thu, 23 May 2019 13:37:02 +0000", "API response date should must match")
			XCTAssertEqual(post.artworkURL, "https://macmagazine.uol.com.br/wp-content/uploads/2019/05/23-vignette-300x600.png", "API response artworkURL should must match")
			XCTAssertEqual(post.podcastURL, "", "API response podcastURL should must match")
			XCTAssertEqual(post.podcast, "", "API response podcast should must match")
			XCTAssertEqual(post.duration, "", "API response duration should must match")
			XCTAssertEqual(post.podcastFrame, "", "API response podcastFrame should must match")
			XCTAssertEqual(post.excerpt, "Por padrão, se você não adicionar fotos aos seus contatos manualmente, o iPhone preenche o espaço do avatar com um círculo cinza com as iniciais da pessoa. Mas e se houvesse uma forma de colocar fotos em todos eles com poucos toques? Foi nesse projeto que o desenvolvedor Casey Liss trabalhou nos últimos três meses, [&#8230;]", "API response excerpt should must match")
			XCTAssertEqual(post.categories, ["Dicas", "Gadgets", "Internet", "Software", "agenda", "app", "App Store", "avatares", "Casey Liss", "contatos", "fotos", "Gravatar", "iPhone", "Limitliss", "pessoas", "privacidade", "redes sociais", "social", "usuários", "Vignette"], "API response categories should must match")

			expectation.fulfill()
		}

		let parser = XMLParser(data: post)
		let apiParser = APIXMLParser(onCompletion: onCompletion, isComplication: false)
		parser.delegate = apiParser
		parser.parse()

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}
}

extension ParsedObjectTests {
	func getExamplePost() -> Data? {
		return Data(examplePost.utf8)
	}
}
