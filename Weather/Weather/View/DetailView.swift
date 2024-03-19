//
//  ContentView.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @State var cityName = ""
    
    var body: some View {
        TextField("Enter city name", text: $cityName)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onAppear{
                
            }
            .onSubmit{
                viewModel.getWeather(for: cityName)
                
            }
        output()
    }
    
    func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func output() -> some View {
        return VStack {
            Text(viewModel.weatherData?.name ?? "Unknown")
            Text("Temperature: \(String(format: "%.2f°C", viewModel.weatherData?.main.temp ?? 0))")
            Text("Humidity: \(viewModel.weatherData?.main.humidity ?? 0)%")
            Text("Wind Speed: \(String(format: "%.2f", viewModel.weatherData?.wind.speed ?? 0)) mph")
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherData?.weather.last?.icon ?? "No Icon").png"))
        }
    }
    
    var searchButton: some View {
        Button("search"){
            viewModel.getWeather(for: cityName)
        }
        .frame(maxWidth: 90)
        .background(Color.white)
        .foregroundColor(.gray)
        .cornerRadius(5)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.gray, lineWidth: 2)
        )
    }
}

#Preview {
    DetailView()
}

