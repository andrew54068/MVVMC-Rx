//
//  CollectionListModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation

struct CollectionContainerModel: Decodable {
    let assets: [CollectionModel]
}

struct CollectionModel: Decodable {
    let tokenId: String
    let imageUrl: URL? // 收藏品圖片
    let name: String // 收藏品名稱
    let description: String?
    let permalink: URL?
    let collectionName: String

    private enum DecodeKeys: String, CodingKey {
        case tokenId
        case imageUrl
        case name
        case description
        case permalink
        case collection
    }

    private enum CollectionDecodeKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: DecodeKeys.self)
        self.tokenId = try container.decode(String.self, forKey: .tokenId)
        self.imageUrl = try? container.decode(URL.self, forKey: .imageUrl)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try? container.decode(String.self, forKey: .description)
        self.permalink = try? container.decode(URL.self, forKey: .permalink)

        let collectionContainer: KeyedDecodingContainer = try container.nestedContainer(keyedBy: CollectionDecodeKeys.self, forKey: .collection)
        self.collectionName = try collectionContainer.decode(String.self, forKey: .name)
    }

}
