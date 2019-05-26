//
//  PostsTests.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 19/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import XCTest
@testable import MacMagazine

// Tests to be performed:
// 1) Create a mock test
// 2) Test for the content of the mock data, adding to the XMLPost class
// 3) Save mock data to database
// 4) Validate content of the database

class PostTests: XCTestCase {

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
		super.tearDown()
	}

	func testGetPost() {
		XCTAssertNotNil(postExample, "Example post should exist")
	}
	
	func testParseAndSaveExample() {
		guard let post = postExample else {
			XCTFail("Example post should exist")
			return
		}
		
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 2
		
		let onCompletion = { (post: XMLPost?) in
			guard let post = post else {
				let link = "https://macmagazine.uol.com.br/2019/05/23/novo-app-garante-que-todos-os-seus-contatos-do-iphone-tenham-fotos-atualizadas/"
				CoreDataStack.shared.get(post: link) { posts in

					if posts.isEmpty {
						XCTFail("Database is empty")
					} else {
						XCTAssertEqual(posts.count, 1, "Should retrieve only 1 post")

						XCTAssertEqual(posts[0].title, "Novo app garante que todos os seus contatos do iPhone tenham fotos atualizadas", "API response title must match")
						XCTAssertEqual(posts[0].link, "https://macmagazine.uol.com.br/2019/05/23/novo-app-garante-que-todos-os-seus-contatos-do-iphone-tenham-fotos-atualizadas/", "API response link must match")
						
						let pubDate = "Thu, 23 May 2019 13:37:02 +0000".toDate()
						XCTAssertEqual(posts[0].pubDate, pubDate, "API response date should must match")
						
						XCTAssertEqual(posts[0].artworkURL, "https://macmagazine.uol.com.br/wp-content/uploads/2019/05/23-vignette-300x600.png", "API response artworkURL must match")
						XCTAssertEqual(posts[0].podcastURL, "", "API response podcastURL must match")
						XCTAssertEqual(posts[0].podcast, "", "API response podcast must match")
						XCTAssertEqual(posts[0].duration, "", "API response duration must match")
						XCTAssertEqual(posts[0].podcastFrame, "", "API response podcastFrame must match")
						
						let excerpt = "Por padrão, se você não adicionar fotos aos seus contatos manualmente, o iPhone preenche o espaço do avatar com um círculo cinza com as iniciais da pessoa. Mas e se houvesse uma forma de colocar fotos em todos eles com poucos toques? Foi nesse projeto que o desenvolvedor Casey Liss trabalhou nos últimos três meses, [&#8230;]".toHtmlDecoded()
						XCTAssertEqual(posts[0].excerpt, excerpt, "API response excerpt must match")
						
						let categorias = ["Dicas", "Gadgets", "Internet", "Software", "agenda", "app", "App Store", "avatares", "Casey Liss", "contatos", "fotos", "Gravatar", "iPhone", "Limitliss", "pessoas", "privacidade", "redes sociais", "social", "usuários", "Vignette"].joined(separator: ",")
						XCTAssertEqual(posts[0].categorias, categorias, "API response categories must match")
					}

					expectation.fulfill()
				}
				return
			}

			CoreDataStack.shared.save(post: post)
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
