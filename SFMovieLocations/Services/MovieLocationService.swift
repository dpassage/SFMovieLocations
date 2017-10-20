//
//  MovieLocationService.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import Foundation

enum Result<T> {
    case some(T)
    case error(Error)
}

typealias MovieLocationServiceClosure = (Result<MovieLocationAPIResult>) -> Void

fileprivate let endpointURL = URL(string: "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD")!

enum MovieLocationServiceError: Error {
    case httpError
    case noData
}

class MovieLocationService {

    /// Retrieves the latest set of movie locations from the API endpoint.
    /// Network operations are in the background; closure is called on the main thread
    ///
    /// - Parameter closure: callback for results
    func getMovieLocations(_ closure: @escaping MovieLocationServiceClosure) {
        let session = URLSession.shared

        let mainthreadClosure: MovieLocationServiceClosure = { result in
            DispatchQueue.main.async {
                closure(result)
            }
        }

        let task = session.dataTask(with: endpointURL) { (data, response, error) in
            guard let data = data else {
                let error = error ?? MovieLocationServiceError.noData
                mainthreadClosure(.error(error))
                return
            }

            guard let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode) else {
                    mainthreadClosure(.error(MovieLocationServiceError.httpError))
                    return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieLocationAPIResult.self, from: data)
                mainthreadClosure(.some(result))
            } catch {
                mainthreadClosure(.error(error))
            }
        }

        task.resume()
    }
}
