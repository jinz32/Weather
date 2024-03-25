//
//  FavoriteView.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/20/24.
//

import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var viewModel: FavoritesListViewModel
    
    var body: some View {
        getFavoriteStack()
            .onAppear {
                viewModel.repository.loadFavoritesFromFile { result in
                    switch result {
                    case .success(let favorites):
                        // Handle the loaded favorites
                        viewModel.repository.favoriteList = favorites
                    case .failure(let error):
                        // Handle the error
                        print("Failed to load favorites: \(error)")
                    }
                }
            }
    }
    
    func getFavoriteStack() -> some View {
        return VStack(alignment: .trailing){
            List{
                ForEach(viewModel.getList(), id: \.id) { weather in
                    HStack{
                        Text(weather.name)
                        Text(String(format: "%.2f°C",weather.main.temp))
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.last?.icon ?? "No Icon").png"))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            viewModel.removeFavoriteCity(weather)
                        }
                    label: {
                        Label("Delete", systemImage: "trash")
                        
                    }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle()) // Ensure swipe action works on the entire row
                }
            }
        }
    }
}

//
//
//#Preview {
//    FavoriteView()
//}

