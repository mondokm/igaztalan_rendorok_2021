//
//  DetailsView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var detailViewModel: DetailsViewModel
    var image: CaffWithoutComments
    @Environment(\.presentationMode) var presentationMode
    @State var isCommentActive: Bool = false
    @State var inputComment: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            AnimatedImage2(base64: $detailViewModel.image.base64Preview)
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3)
                .padding(.leading, 10)
                .padding(.trailing, 10)

            HStack {
                Button {
                    isCommentActive.toggle()
                } label: {
                    Image(systemName: "plus.message.fill")
                }
                if AppData.shared.isAdmin == true {
                    Button {
                        detailViewModel.delete(imageId: image._id) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                Button {
                    detailViewModel.getFullImage(imageId: detailViewModel.image._id)
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                }
            }
            .padding()

            if isCommentActive {
                HStack {
                    TextField("Comment", text: $inputComment)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)
                    Button {
                        detailViewModel.comment(imageId: detailViewModel.image._id, description: inputComment) {
                            detailViewModel.refreshImageDetails(imageId: detailViewModel.image._id) {
                                inputComment = ""
                                isCommentActive.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }.padding()
            }

            List(detailViewModel.image.comments ?? []) { comment in
                Text(comment.message)
            }
            .listStyle(.plain)
            .padding()
        }
        .animation(.linear(duration: 0.25), value: isCommentActive)
        .onAppear {
            detailViewModel.refreshImageDetails(imageId: image._id)
        }
        .navigationTitle(image.title)
        .overlay {
            if !$detailViewModel.isNotLoading.wrappedValue {
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

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(detailViewModel: DetailsViewModel(),
                    image: CaffWithoutComments(title: "Title",
                                               _id: 0,
                                               creatorId: 1,
                                               keywords: ["keyword1", "keyword2"],
                                               base64Preview: "",
                                               comments: [CommentResponse(_id: 2,
                                                                          caffId: 3,
                                                                          author: Author(name: "Author1", _id: 4),
                                                                          message: "Message1",
                                                                          timestamp: 5),
                                                          CommentResponse(_id: 6,
                                                                          caffId: 7,
                                                                          author: Author(name: "Author2", _id: 8),
                                                                          message: "Message2",
                                                                          timestamp: 9)]))
    }
}

extension CommentResponse: Identifiable {
    public var id: Int {
        _id
    }
}
