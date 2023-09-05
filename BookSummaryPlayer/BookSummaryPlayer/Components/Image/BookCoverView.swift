//
//  BookCoverView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI
import Kingfisher

struct BookCoverView: View {
    
    let url: URL?
    var placeholder: String = "bookPlaceholder"
    
    var body: some View {
        KFImage(url)
            .resizable()
            .placeholder {
                Image(placeholder)
                    .resizable()
            }
            .scaledToFit()
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
    }
}

struct BookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        BookCoverView(
            url: URL(
                string: "https://almabooks.com/wp-content/uploads/2016/10/9781847493767.jpg"
            )!
        )
    }
}
