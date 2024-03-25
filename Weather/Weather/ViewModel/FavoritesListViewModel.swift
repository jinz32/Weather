//
//  FavoriteViewModel.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/21/24.
//

import Foundation
import Combine  

class FavoritesListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var repository: FavoriteRepository
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: FavoriteRepository) {
        self.repository = repository
        repository.$favoriteList
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables) 
    }
    
    func removeFavoriteCity(_ city: WeatherModel){
        if let index = repository.favoriteList.firstIndex(where: { $0 == city }) {
            city.isFavorited = false
            repository.favoriteList.remove(at: index)
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
    
    func getList() -> [WeatherModel]{
        repository.getFavorites()
    }
    
}



