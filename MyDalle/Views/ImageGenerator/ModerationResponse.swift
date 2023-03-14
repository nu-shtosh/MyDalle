//
//  ModerationResponse.swift
//  MyDalle
//
//  Created by Илья Дубенский on 09.03.2023.
//

/* Response Example
{
  "id": "modr-XXXXX",
  "model": "text-moderation-001",
  "results": [
    {
      "categories": {
        "hate": false,
        "hate/threatening": false,
        "self-harm": false,
        "sexual": false,
        "sexual/minors": false,
        "violence": false,
        "violence/graphic": false
      },
      "category_scores": {
        "hate": 0.18805529177188873,
        "hate/threatening": 0.0001250059431185946,
        "self-harm": 0.0003706029092427343,
        "sexual": 0.0008735615410842001,
        "sexual/minors": 0.0007470346172340214,
        "violence": 0.0041268812492489815,
        "violence/graphic": 0.00023186142789199948
      },
      "flagged": false
    }
  ]
}
*/

import Foundation

struct ModerationResponse: Codable {
    let id: String
    let model: String
    let results: [ModerationResult]

    var hasIssues: Bool {
        return results.map(\.flagged).contains(true)
    }
}

struct ModerationResult: Codable {
    let categories: Category
    let categoryScores: CategoryScore
    let flagged: Bool

    private enum CodingKeys: String, CodingKey {
        case categories
        case categoryScores = "category_scores"
        case flagged
    }
}

struct Category: Codable {
    let hate: Bool
    let hateThreatening: Bool
    let selfHarm: Bool
    let sexual: Bool
    let sexualMinors: Bool
    let violence: Bool
    let violenceGraphic: Bool

    private enum CodingKeys: String, CodingKey {
        case hate
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual
        case sexualMinors = "sexual/minors"
        case violence
        case violenceGraphic = "violence/graphic"
    }
}

struct CategoryScore: Codable {
    let hate: Double
    let hateThreatening: Double
    let selfHarm: Double
    let sexual: Double
    let sexualMinors: Double
    let violence: Double
    let violenceGraphic: Double

    private enum CodingKeys: String, CodingKey {
        case hate
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual
        case sexualMinors = "sexual/minors"
        case violence
        case violenceGraphic = "violence/graphic"
    }
}



