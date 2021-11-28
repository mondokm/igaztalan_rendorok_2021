//
//  UploadView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct UploadView: View {
    @ObservedObject var uploadViewModel: UploadViewModel
    @State var base64Content = ""
    @State var isFilePickerShowing = false
    @State var title = ""
    @State var keyWords = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Title", text: $title)
                    .padding(.leading, 10)
                TextField("Add keywords separeted with a comma and a space", text: $keyWords)
                    .padding(.leading, 10)

                HStack {
                    Text(base64Content)
                    Spacer()
                    Button {
                        isFilePickerShowing.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                .padding()

                HStack {
                    Spacer()
                    Button {
                        let array = keyWords.components(separatedBy: ", ")
                        uploadViewModel.upload(name: title, keywords: array, image: base64Content)
                    } label: {
                        Text("Upload photo")
                    }
                    Spacer()
                }
                Spacer()
            }
            .sheet(isPresented: $isFilePickerShowing, content: {
                DocumentPicker(base64Content: $base64Content)
        })
            .navigationTitle("Upload an image")
        }
        .overlay {
            if !$uploadViewModel.isNotLoading.wrappedValue {
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

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(uploadViewModel: UploadViewModel())
    }
}
