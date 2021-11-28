//
//  GalleryView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct GalleryView: View {
    @ObservedObject var galleryViewModel: GalleryViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach($galleryViewModel.images) { image in
                        NavigationLink {
                            DetailsView(detailViewModel: DetailsViewModel(), image: image.wrappedValue)
                        } label: {
                            VStack {
                                AnimatedImage2(base64: image.base64Preview)
                                    .cornerRadius(10)
                                    .frame(width: UIScreen.main.bounds.width * 0.9,
                                           height: UIScreen.main.bounds.height * 0.3)
                                Text(image.wrappedValue.title)
                                    .padding(.bottom, 10)
                            }
                        }
                    }.disabled(!$galleryViewModel.isNotLoading.wrappedValue)
                }
            }
            .onAppear {
                galleryViewModel.refreshImages()
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete user") {
                        galleryViewModel.delete {
                            galleryViewModel.logOut()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log out") {
                        galleryViewModel.logOut()
                    }
                }
            }
            .overlay {
                if !$galleryViewModel.isNotLoading.wrappedValue {
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

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(galleryViewModel: GalleryViewModel())
    }
}

extension CaffWithoutComments: Identifiable {
    public var id: Int {
        _id
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
