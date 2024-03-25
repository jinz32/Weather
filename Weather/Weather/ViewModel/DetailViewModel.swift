//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/19/24.
//

import Foundation
import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    @Published var repository: FavoriteRepository
    @Published var isLoading = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: FavoriteRepository) {
        self.repository = repository
        repository.$favoriteList
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    
    func fetchWeatherData(for city : String){
        repository.getWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.isLoading = false
            case .failure(let error):
                print("An error occurred: \(error)")
                // Handle the error, e.g., show an error message to the user
            }
        }
    }
    
    func addFavoriteCity(_ city: WeatherModel) {
        if !repository.favoriteList.contains(city) {
            repository.favoriteList.append(city)
            city.isFavorited = true
            repository.saveFavoritesToFile(repository.favoriteList){[weak self] result in
                switch result{
                case.success(_):
                    self?.isLoading = false
                case .failure(let error):
                    print("An error occured: \(error)")
                }
            }
        }
    }
    
    func removeFavoriteCity(_ city: WeatherModel){
        if let index = repository.favoriteList.firstIndex(where: { $0 == city }) {
            repository.favoriteList.remove(at: index)
            city.isFavorited = false
            repository.removeFavoriteFromFile(city){[weak self] result in
                switch result{
                case.success(_):
                    self?.isLoading = false
                case.failure(let error):
                    print ("An error occured: \(error)")
                }
            }
        }
    }
}


