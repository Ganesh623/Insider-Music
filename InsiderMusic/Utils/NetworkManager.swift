//
//  NetworkManager.swift
//  InsiderMusic
//
//  Created by mac on 26/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import Foundation

internal class NetworkManager {
    
    static var shared = NetworkManager()
    
    func getMusicListData(_ urlString: String, completionHandler: @escaping(Result<Data, NetworkError>) -> Void) {
        ///
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badRequest))
            return
        }
        ///
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil, let er = error as? NetworkError {
                completionHandler(.failure(er))
                return
            }
            ///
            guard let userData = data, let urlResponse = response, (urlResponse as? HTTPURLResponse)?.statusCode == 200 else {
                completionHandler(.failure(.defaultError))
                return
            }
            ///
            completionHandler(.success(userData))
        }
        .resume()
    }
}

/**
 Network Error Enum with multiple cases of API Failures.
 */
enum NetworkError: Error {
    case badRequest
    case parsingError
    case defaultError
}

/**
 Localized Description for the Network Error.
 */
extension NetworkError: LocalizedError {
    ///
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Invalid request Passed", comment: "")
        case .parsingError:
            return NSLocalizedString("An error occured while parsing data Passed", comment: "")
        case .defaultError:
            return NSLocalizedString("An error occured while processing data", comment: "")
        }
    }
}
