//
//  ImageGenerationResponse.swift
//  MyDalle
//
//  Created by Илья Дубенский on 10.03.2023.
//

import Foundation

/* Response Example
 {
   "created": 1589478378,
   "data": [
     {
       "url": "https://..."
     },
     {
       "url": "https://..."
     }
   ]
 }
 */


struct ImageResponse: Codable {
    let url: URL
}

struct ImageGenerationResponse: Codable {
    let created: Int
    let data: [ImageResponse]
}
