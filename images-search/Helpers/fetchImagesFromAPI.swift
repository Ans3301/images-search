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
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "IMAGES_API_KEY") as? String else {
        throw URLError(.badURL)
    }

    let baseURL = "https://pixabay.com/api/"
    guard var urlComponents = URLComponents(string: baseURL) else {
        throw URLError(.badURL)
    }

    urlComponents.queryItems = [
        URLQueryItem(name: "key", value: apiKey),
        URLQueryItem(name: "q", value: query),
        URLQueryItem(name: "image_type", value: "all"),
        URLQueryItem(name: "per_page", value: "50")
    ]

    guard let url = urlComponents.url else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode(PixabayResponse.self, from: data)

    return decoded
}
