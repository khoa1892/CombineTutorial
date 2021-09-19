//
//  ServiceProvider.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation

class ServiceProvider {
    
    let network: NetworkServiceType
    
    static func defaultProvider() -> ServiceProvider {
        let network = NetworkService()
        return ServiceProvider(network: network)
    }
    
    init(network: NetworkServiceType) {
        self.network = network
    }
}
