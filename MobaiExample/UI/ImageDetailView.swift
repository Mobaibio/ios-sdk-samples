//
//  ImageDetailView.swift
//  MobaiExample

import SwiftUI

struct ImageModel {
    let imageData: Data
    let title: String = "Test"
    let description: String = "First image that was captured from the pad"
}

struct ImageDetailView: View {
    let imageModel: ImageModel

    var body: some View {
        VStack(spacing: 16) {
            if let image = UIImage(data: imageModel.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            } else {
                Text("Something went wrong!!.")
                    .font(.headline)
                    .padding(.top)
            }
            Text(imageModel.title)
                .font(.headline)
                .padding(.top)

            Text(imageModel.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("Image Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
