//
//  fetchImagesFromAPI.swift
//  images-search
//
//  Created by Мария Анисович on 11.11.2024.
//

import Foundation

struct PixabayResponse: Codable {
    let total: Int
    let hits: [PixabayImage]
}

struct PixabayImage: Codable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let views: Int
    let downloads: Int
    let likes: Int
}

func fetchImagesFromAPI(query: String) async throws -> PixabayResponse {
    let apiKey = "46954861-3947e7fef4f190fa1bbb73c6a"
    let baseURL = "https://pixabay.com/api/"
    var urlComponents = URLComponents(string: baseURL)!

    urlComponents.queryItems = [
        URLQueryItem(name: "key", value: apiKey),
        URLQueryItem(name: "q", value: query),
        URLQueryItem(name: "image_type", value: "all"),
        URLQueryItem(name: "per_page", value: "50")
    ]

    let url = urlComponents.url!

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode(PixabayResponse.self, from: data)

    return decoded
}
