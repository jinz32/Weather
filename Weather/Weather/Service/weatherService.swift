//
//  weatherService.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import Foundation
import SwiftUI
struct weatherService{
    func getWeather(city: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let apiKey = "f97fa5b8aa40a959b9d18c6f07e8c04f"
        let weather = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: weather) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            print("hi")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}

