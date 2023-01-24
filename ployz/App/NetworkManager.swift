//
//  NetworkManager.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static func getPopularGames(completionHandler: @escaping ([Result]?, Error?) -> Void) {
        let requestURL = "\(ProcessInfo.processInfo.environment["API_URL"]!)/lists/popular?page_size=25&page=1&key=\(ProcessInfo.processInfo.environment["API_KEY"]!)"
        NetworkManager.responseHandler(requestURL: requestURL, responseType: PopularGames.self) { responseModel, error in
            completionHandler(responseModel?.results, error)
        }
    }
    
    static func getGameDetails(gameId: Int, completionHandler: @escaping (GameDetailsModel?, Error?) -> Void) {
        let requestURL = "\(ProcessInfo.processInfo.environment["API_URL"]!)/\(String(gameId))?key=\(ProcessInfo.processInfo.environment["API_KEY"]!)"
        NetworkManager.responseHandler(requestURL: requestURL, responseType: GameDetailsModel.self, completionHandler: completionHandler)
    }
    
    static func searchGames(searchText: String, completionHandler: @escaping ([Result]?, Error?) -> Void) {
        let requestURL = "\(ProcessInfo.processInfo.environment["API_URL"]!)?&search=\(searchText)&page_size=25&page=1&key=\(ProcessInfo.processInfo.environment["API_KEY"]!)"
        NetworkManager.responseHandler(requestURL: requestURL, responseType: PopularGames.self) { responseModel, error in
            completionHandler(responseModel?.results, error)
        }
    }
    
    static private func responseHandler<T: Decodable>(requestURL: String, responseType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        AF.request(requestURL).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completionHandler(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let gamesObjectResponse = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completionHandler(gamesObjectResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
