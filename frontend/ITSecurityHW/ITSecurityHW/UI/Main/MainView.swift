//
//  MainView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel

    var body: some View {
        TabView {
            GalleryView(galleryViewModel: GalleryViewModel())
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                }

            SearchView(searchViewModel: SearchViewModel())
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle")
                }

            UploadView(uploadViewModel: UploadViewModel())
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel())
    }
}
