//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherModel?
    @Published var iconImage: UIImage?
    private let weatherservice = weatherService()
    
    func getWeather(for city: String) {
        weatherservice.getWeather(city: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherdata):
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: weatherdata)
                        self.weatherData = decodedData
                    } catch {
                        print("Failed to decode weather data:", error)
                    }
                case .failure(let error):
                    print("Failed to fetch weather data:", error)
                }
            }
        }
    }
}
