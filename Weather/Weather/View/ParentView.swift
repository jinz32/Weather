//
//  ParentView.swift
//  Weather
//
//  Created by Jonathan Zheng on 3/20/24.
//

import SwiftUI

struct ParentView: View {
    
    @State var selectedTab = 1
    var body: some View{
        tabs()
    }
}

func tabs() -> some View{
    let favoriteRepository = FavoriteRepository()
    let viewModel = FavoritesListViewModel(repository: favoriteRepository)
    let detailViewModel = DetailViewModel(repository: favoriteRepository)
    
    return TabView(){
        FavoritesListView(viewModel: viewModel)
            .tabItem{
                Image(systemName: "heart.fill")
            }
            .tag(0)
        DetailView(viewModel: detailViewModel)
            .tabItem {
                Image(systemName: "magnifyingglass")
            }
            .tag(1)
    }
}

//#Preview {
//    ParentView()
//}
