//
//  ContentView.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var cityName = ""
    
    var body: some View {
        VStack{
            TextField("Enter city name", text: $cityName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit{
                    viewModel.fetchWeatherData(for: cityName)
                }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }else{
                weatherDetailStack()
            }
            Spacer()
                .onAppear {
                    if viewModel.repository.weatherData == nil {
                        guard let cityName = viewModel.repository.loadPriorSearchData() else{
                            viewModel.isLoading = false
                            return
                        }
                        viewModel.fetchWeatherData(for: cityName)
                    }
                }
        }
    }
    
    private func weatherDetailStack() -> some View {
        guard let weatherData = viewModel.repository.weatherData else { return AnyView(Text("no data"))}
        
        return AnyView(VStack {
            Text(weatherData.name)
            Text("Temperature: \(String(format: "%.2f°C", weatherData.main.temp))")
            Text("Humidity: \(weatherData.main.humidity)%")
            Text("Wind Speed: \(String(format: "%.2f", weatherData.wind.speed)) mph")
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.last?.icon ?? "No Icon").png"))
                .frame(width: 75, height: 75)
            Button (action:{
                if weatherData.isFavorited == true {
                    viewModel.removeFavoriteCity(weatherData)
                }else{
                    viewModel.addFavoriteCity(weatherData)
                }
            }){
                if weatherData.isFavorited == true {
                    Image(systemName: "heart.fill")
                }else{
                    Image(systemName: "suit.heart")
                }
            }
        })
    }
}

