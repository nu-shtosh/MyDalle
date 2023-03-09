//
//  ImageGeneratorView.swift
//  MyDalle
//
//  Created by Илья Дубенский on 14.02.2023.
//

import SwiftUI

struct ImageGeneratorView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading = false

    var body: some View {

        NavigationView {

            VStack(alignment: .center) {

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 256, height: 256)
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 256, height: 256)
                        .cornerRadius(8)
                        .padding(.vertical, 20)
                        .overlay {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .padding()
                                    Text("Loading...")
                                        .foregroundColor(.white)
                                }

                            }
                        }
                }

                VStack {
                    TextField("Enter prompt", text: $prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .border(.blue, width: 1)
                        .padding()
                    HStack {
                        Spacer()
                        Button(image == nil ? "Generate" : "Generate New Image", action: generateImage)
                            .buttonStyle(.borderedProminent)
                            .padding()
                    }
                }

                Spacer()

            }
            .navigationTitle("Image Generator")
            .toolbar {
                if image != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: saveImage) {
                            Text("Save Image")
                        }
                    }
                }
            }
        }
    }

    private func generateImage() {
        print("Generate Image Button Did Tapped")
        image = nil
        isLoading = true
        Task {
            do {
                let response = try await DalleImageGenerate.shared.generateImage(
                    withPrompt: prompt,
                    apiKey: Secrets.openAIApiKey.description
                )
                if let url = response.data.map(\.url).first {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    image = UIImage(data: data)
                    isLoading = false
                }
            } catch {
                print(error.localizedDescription)

            }
        }
    }

    private func saveImage() {
        print("Save Image Button Did Tapped")
        if let image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

struct ImageGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGeneratorView()
    }
}
