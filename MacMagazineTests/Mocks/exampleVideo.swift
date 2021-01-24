//
//  exampleVideo.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 26/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

struct ExampleVideo {

    let exampleVideo = """
{\n \"kind\": \"youtube#playlistItemListResponse\",\n \"etag\": \"\\\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/CtDNaH4poeYOWkfYMdtl_wJLCCk\\\"\",\n \"nextPageToken\": \"CAEQAA\",\n \"pageInfo\": {\n  \"totalResults\": 327,\n  \"resultsPerPage\": 1\n },\n \"items\": [\n  {\n   \"kind\": \"youtube#playlistItem\",\n   \"etag\": \"\\\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/Q6CpPElh9ugqHBbHHAyx86ow7Fk\\\"\",\n   \"id\": \"VVU2WkltTHdpSWFWUllJR3ljcWg1aUxBLlN4Mzk5cHE2OVNB\",\n   \"snippet\": {\n    \"publishedAt\": \"2019-04-01T22:35:57.000Z\",\n    \"channelId\": \"UC6ZImLwiIaVRYIGycqh5iLA\",\n    \"title\": \"AirPods de segunda geração\",\n    \"description\": \"Post no MacMagazine: https://macmagazine.uol.com.br/2019/04/01/video-airpods-de-2a-geracao-com-estojo-de-recarga-sem-fio-unboxing-e-primeiras-impressoes/\\n\\nSIGA A GENTE!\\nhttps://twitter.com/MacMagazine\\nhttps://www.facebook.com/MacMagazine\\nhttps://instagram.com/MacMagazine/\\n\\nNOSSO PODCAST\\nhttps://soundcloud.com/MacMagazine\\n\\nTORNE-SE UM PATRÃO!\\nhttps://www.patreon.com/MacMagazine\\nhttps://www.catarse.me/macmagazine\\n\\nECONOMIZE EM COMPRAS ONLINE!\\nhttps://ofertas.macmagazine.com.br/\\n\\nTrilha sonora: https://www.bensound.com/\\n\\nASSINE O NOSSO CANAL! E não esqueça de ativar as notificações para ser informado quando novos vídeos forem ao ar. ;-)\",\n    \"thumbnails\": {\n     \"default\": {\n      \"url\": \"https://i.ytimg.com/vi/Sx399pq69SA/default.jpg\",\n      \"width\": 120,\n      \"height\": 90\n     },\n     \"medium\": {\n      \"url\": \"https://i.ytimg.com/vi/Sx399pq69SA/mqdefault.jpg\",\n      \"width\": 320,\n      \"height\": 180\n     },\n     \"high\": {\n      \"url\": \"https://i.ytimg.com/vi/Sx399pq69SA/hqdefault.jpg\",\n      \"width\": 480,\n      \"height\": 360\n     },\n     \"standard\": {\n      \"url\": \"https://i.ytimg.com/vi/Sx399pq69SA/sddefault.jpg\",\n      \"width\": 640,\n      \"height\": 480\n     },\n     \"maxres\": {\n      \"url\": \"https://i.ytimg.com/vi/Sx399pq69SA/maxresdefault.jpg\",\n      \"width\": 1280,\n      \"height\": 720\n     }\n    },\n    \"channelTitle\": \"MacMagazine\",\n    \"playlistId\": \"UU6ZImLwiIaVRYIGycqh5iLA\",\n    \"position\": 0,\n    \"resourceId\": {\n     \"kind\": \"youtube#video\",\n     \"videoId\": \"Sx399pq69SA\"\n    }\n   }\n  }\n ]\n}
"""

	let exampleStats = """
{\n \"kind\": \"youtube#videoListResponse\",\n \"etag\": \"\\\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/1b4zTodUDjMlrRJbEk41TPG3R-A\\\"\",\n \"pageInfo\": {\n  \"totalResults\": 1,\n  \"resultsPerPage\": 1\n },\n \"items\": [\n  {\n   \"kind\": \"youtube#video\",\n   \"etag\": \"\\\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/Y_w0tkO7fwYlW7w9kssvXEHILog\\\"\",\n   \"id\": \"Sx399pq69SA\",\n   \"statistics\": {\n    \"viewCount\": \"7905\",\n    \"likeCount\": \"755\",\n    \"dislikeCount\": \"5\",\n    \"favoriteCount\": \"0\",\n    \"commentCount\": \"29\"\n   }\n  }\n ]\n}
"""

	func getExampleVideo() -> Data? {
		return Data(exampleVideo.utf8)
	}

	func getExampleVideoId() -> String {
		return "Sx399pq69SA"
	}
	func getExampleKind() -> String {
		return "youtube#playlistItemListResponse"
	}
	func getExampleNextPageToken() -> String {
		return "CAEQAA"
	}
	func getExamplePageInfoTotalResults() -> Int {
		return 327
	}
	func getExampleItemsId() -> String {
		return "VVU2WkltTHdpSWFWUllJR3ljcWg1aUxBLlN4Mzk5cHE2OVNB"
	}

	func getExampleStats() -> Data? {
		return Data(exampleStats.utf8)
	}

	func getExampleStatKind() -> String {
		return "youtube#videoListResponse"
	}
	func getExampleStatsPageInfoTotalResults() -> Int {
		return 1
	}
	func getExampleStatsItemsId() -> String {
		return "Sx399pq69SA"
	}
	func getExampleStatsStatisticsViewCount() -> String {
		return "7905"
	}
	func getExampleStatsStatisticsLikeCount() -> String {
		return "755"
	}

}
