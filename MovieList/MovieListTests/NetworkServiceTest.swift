//
//  NetworkServiceTest.swift
//  MovieListTests
//
//  Created by Khoa Mai on 9/19/21.
//

import XCTest

class NetworkServiceTest: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    override func setUp() {
        super.setUp()
    }
}
