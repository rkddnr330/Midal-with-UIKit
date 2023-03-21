//
//  Post.swift
//  MidalWIthUIKit
//
//  Created by Park Kangwook on 2023/03/19.
//

import Foundation

struct Post: Identifiable, Hashable {
    let id = UUID().uuidString
    var title: String
    var url : URL?
    
    init(_ title: String, _ url: URL? = nil) {
        self.title = title
        self.url = url
    }
}
