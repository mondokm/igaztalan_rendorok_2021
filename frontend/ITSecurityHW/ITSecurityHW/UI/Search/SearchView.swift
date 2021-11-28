//
//  SearchView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State var inputString: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Enter a keyword")
                HStack {
                    TextField("Keyword", text: $inputString)
                    Button {
                        searchViewModel.search(searchTerm: inputString)
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                    }
                    .padding(.trailing, 10)
                }

                ScrollView {
                    VStack {
                        ForEach($searchViewModel.images) { image in
                            NavigationLink {
                                DetailsView(detailViewModel: DetailsViewModel(),
                                            image: CaffWithoutComments(title: image.wrappedValue.title,
                                                                       _id: image.wrappedValue._id,
                                                                       creatorId: image.wrappedValue.creatorId,
                                                                       keywords: image.wrappedValue.keywords,
                                                                       base64Preview: image.wrappedValue.base64Preview,
                                                                       comments: image.wrappedValue.comments))
                            } label: {
                                VStack {
                                    AnimatedImage2(base64: image.base64Preview)
                                        .cornerRadius(10)
                                        .frame(width: UIScreen.main.bounds.width * 0.9,
                                               height: UIScreen.main.bounds.height * 0.3)
                                        .padding()
                                    Text(image.wrappedValue.title)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                    }.disabled(!$searchViewModel.isNotLoading.wrappedValue)
                }
            }
            .padding(.leading, 10)
            .navigationTitle("Search for photos")
            .onAppear {
                searchViewModel.search(searchTerm: inputString)
            }
            .overlay {
                if !$searchViewModel.isNotLoading.wrappedValue {
                    VStack {
                        Text("Loading...")
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

extension Caff: Identifiable {
    public var id: Int {
        _id
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchViewModel: SearchViewModel())
    }
}
