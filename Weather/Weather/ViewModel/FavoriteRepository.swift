//
//  ParentViewModel.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/21/24.
//

import Foundation

class FavoriteRepository {
    
    @Published var weatherData: WeatherModel?
    
    @Published var favoriteList: [WeatherModel] = []
    private let weatherservice = weatherService()
    
    
    func getWeather(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        weatherservice.getWeather(city: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: weatherData)
                        // Check if the weather data is already favorited
                        if self?.favoriteList.contains(where: { $0.name == decodedData.name }) == true {
                            decodedData.isFavorited = true
                        }
                        self?.weatherData = decodedData
                        self?.saveDataToUserDefaults(data: city)
                        completion(.success(decodedData)) // Call completion with success
                    } catch {
                        print("Failed to decode weather data:", error)
                        completion(.failure(error)) // Call completion with error
                    }
                case .failure(let error):
                    print("Failed to fetch weather data:", error)
                    completion(.failure(error)) // Pass the error to he completion handler
                }
            }
        }
    }
    
    //FOR DETAIL VIEWMODEL
    private func saveDataToUserDefaults(data: String) {
        if (try? JSONEncoder().encode(data)) != nil {
            UserDefaults.standard.set("\(data)", forKey: "stringenum")
        }
    }
    
    //FOR DETAIL VIEWMODEL
    func loadPriorSearchData()-> String? {
        return UserDefaults.standard.string(forKey: "stringenum")
    }
 
    //FOR DETAIL VIEWMODEL
    func addFavoriteCity(_ city: WeatherModel) {
        if !favoriteList.contains(city) {
            favoriteList.append(city)
        }
    }
    
    //FOR DETAIL VIEWMODEL
    func removeFavoriteCity(_ city: WeatherModel){
        if let index = favoriteList.firstIndex(where: { $0 == city }) {
            favoriteList.remove(at: index)
        }
    }
    
    //FOR FAVORITELIST VIEW MODEL
    func saveFavoritesToFile(_ favorites: [WeatherModel], completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("favorites.json")
            try data.write(to: fileURL)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
    
    //FOR FAVORITELIST VIEW MODEL
    func loadFavoritesFromFile(completion: @escaping (Result<[WeatherModel], Error>) -> Void) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("favorites.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([WeatherModel].self, from: data)
            completion(.success(favorites))
        } catch {
            print("Failed to load favorites: \(error)")
            completion(.failure(error))
        }
    }
    func removeFavoriteFromFile(_ favoriteToRemove: WeatherModel, completion: @escaping (Result<Void, Error>) -> Void) {
        // Load the existing favorites from the file
        loadFavoritesFromFile { result in
            switch result {
            case .success(var favorites):
                // Remove the specified favorite from the array
                if let index = favorites.firstIndex(where: { $0 == favoriteToRemove }) {
                    let removedFavorite = favorites.remove(at: index)
                    self.updateFavoritesInUserDefaults(favorites)
                    removedFavorite.isFavorited = false
                }
                self.saveFavoritesToFile(favorites) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                // Handle the error if loading favorites fails
                completion(.failure(error))
            }
        }
    }
    func updateFavoritesInUserDefaults(_ favorites: [WeatherModel]) {
        // Assuming you're storing city names as an array of strings in UserDefaults
        let favoriteCityNames = favorites.map { $0.isFavorited } // Replace `cityName` with the actual property name
        UserDefaults.standard.set(favoriteCityNames, forKey: "favoriteCities")
    }
    
    //FOR FAVORITELIST VIEW MODEL
    func getFavorites() -> [WeatherModel] {
        return favoriteList
    }
}
