//
//  URL+ Ext.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import UIKit

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
