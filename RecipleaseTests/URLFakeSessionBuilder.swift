//
//  URLFakeSessionBuilder.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 10/07/2023.
//

import Foundation
import Alamofire

class URLFakeSessionBuilder {
    
    static func make() -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        
        return Session(configuration: configuration)
    }
}
