//
//  Weather.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import Foundation

class WeatherModel: Codable, Equatable, Identifiable{
    let id = UUID()
    var isFavorited:Bool? = false
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        lhs.name == rhs.name
    }
    
    let name: String
    let wind: Wind
    let main: Main
    let weather: [Weather]
}

class Wind: Codable {
    let speed: Double
    let deg: Int
}

class Weather: Codable {
    let description: String
    let icon: String
}

class Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}


struct GroupWeatherResponses: Codable{
    let list: [WeatherModel]
}
