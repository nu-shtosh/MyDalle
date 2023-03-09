//
//  ContentView.swift
//  MyDalle
//
//  Created by Илья Дубенский on 14.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                    .cornerRadius(8)
                Button("Save Image") {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                .buttonStyle(.borderedProminent)

            } else {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 256, height: 256)
                    .cornerRadius(8)
                    .padding(.vertical, 30)
                    .overlay {
                        VStack {
                            if isLoading {
                                ProgressView()
                                    .padding()
                                Text("Loading...")
                                    .foregroundColor(.white)
                            }

                        }
                    }
            }
            TextField("Enter prompt", text: $prompt, axis: .vertical)
                .padding(8)
                .font(.title3)
                .border(.gray, width: 2)
                .cornerRadius(4)
            Button("Generate", action: generateImage)
                .buttonStyle(.borderedProminent)
                .padding()

            Spacer()

        }
        .padding()

    }

    private func generateImage() {
        isLoading = true
        print("Generate Image Button Did Tapped")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
