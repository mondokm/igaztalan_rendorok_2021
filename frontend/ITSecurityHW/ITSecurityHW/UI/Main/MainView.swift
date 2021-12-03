//
//  MainView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel
    private let galleryView = GalleryView(galleryViewModel: GalleryViewModel())
    private let searchView = SearchView(searchViewModel: SearchViewModel())
    private let uploadView = UploadView(uploadViewModel: UploadViewModel())
    private let administratorView = AdministratorView(administratorViewModel: AdministratorViewModel())

    var body: some View {
        TabView {
            galleryView
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                }

            searchView
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle")
                }

            uploadView
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up")
                }

            if AppData.shared.isAdmin == true {
                administratorView
                    .tabItem {
                        Label("Change", systemImage: "globe")
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel())
    }
}
