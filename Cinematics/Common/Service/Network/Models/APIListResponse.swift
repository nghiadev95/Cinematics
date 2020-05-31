//
//  APIListResponse.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

struct APIListResponse<D: Codable>: Codable {
    let page: Int?
    let results: [D]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        results = try values.decodeIfPresent([D].self, forKey: .results)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
    }
}
