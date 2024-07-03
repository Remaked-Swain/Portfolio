//
//  TaskBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 7/3/24.
//

import SwiftUI

final class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage?
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run { self.image = UIImage(data: data) }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
//        .onAppear {
//            fetchImageTask = Task { await viewModel.fetchImage() }
//        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        .task {
            await viewModel.fetchImage()
        }
    }
}

#Preview {
    TaskBootcamp()
}
