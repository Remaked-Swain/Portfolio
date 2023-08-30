//
//  Typealias.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/30.
//

import SwiftUI

struct MovieModel {
    let title: String
    let director: String
    let rating: Double
}

typealias DramaModel = MovieModel

struct TypealiasBootcamp: View {
//    @State private var item: MovieModel = MovieModel(title: "Title", director: "Joe", rating: 5)
    @State private var item: DramaModel = DramaModel(title: "Drama", director: "Emily", rating: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("영화 제목: \(item.title)")
            Text("감독 이름: \(item.director)")
            Text("평점: \(item.rating)")
        }
        .frame(width: 200, height: 200)
        .background(.thickMaterial)
        .cornerRadius(24)
    }
}

struct TypealiasBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TypealiasBootcamp()
    }
}
