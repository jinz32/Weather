//
//  Weather.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let wind: Wind
    let main: Main
    let weather: [Weather]
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
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
