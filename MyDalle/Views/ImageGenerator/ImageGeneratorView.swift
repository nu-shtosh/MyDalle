//
//  ImageGeneratorView.swift
//  MyDalle
//
//  Created by Илья Дубенский on 14.02.2023.
//

import SwiftUI

struct ImageGeneratorView: View {

    @State private var generationPoints = 45

    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading = false

    @State private var saveImageAlert = false
    @State private var isImagePresented = false

    var body: some View {

        NavigationView {
            ScrollView {
                VStack {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                            .cornerRadius(10)
                    } else {
                        VStack {
                            Rectangle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: 256, height: 256)
                                .cornerRadius(8)
                                .overlay {
                                    VStack {
                                        if isLoading {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                            HStack {
                                                Image("open-ai-logo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 16, height: 16)
                                                    .foregroundColor(.white)
                                                Text("Generating Image...")
                                                    .foregroundColor(.black)
                                                    .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                                            }
                                        }
                                    }
                                }
                            if isLoading {
                                Text("This may take ~1-5 minutes, depending on the server load.")
                                    .foregroundColor(.orange.opacity(0.8))
                                    .font(Font.system(size: 12, weight: .medium, design: .serif))
                            }
                        }
                    }


                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Formulate your request (for the accuracy of the result, we recommend using English)")
                                .font(Font.system(size: 16, weight: .medium, design: .serif))
                            HStack {
                                Text("Example:")
                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
                                Text("The gray cat eats pizza with cheese in the restaurant watercolor")
                                    .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                                    .textSelection(.enabled)
                            }
                        }
                        .padding(10)
                        .background(.gray.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.8), lineWidth: 1))
                        .cornerRadius(10)
                        .padding(.vertical)


                        TextField("Enter a sample...", text: $prompt, axis: .vertical)
                            .padding(10)
                            .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                            .background(.blue.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.8), lineWidth: 1))
                            .cornerRadius(10)

                        HStack(spacing: 20) {
//                            HStack(spacing: 5) {
//                                Text("Generation Points:")
//                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
//                                Text("\(generationPoints)")
//                                    .foregroundColor(generationPoints > 3 ? .blue.opacity(0.8) : .red.opacity(0.8))
//                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
//                            }
                            Button(action: generateImage) {
                                Text("Generate Image")
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 30)
                                    .padding(10)
                                    .background(prompt == "" ? .gray.opacity(0.8) : .blue.opacity(0.8))
                                    .cornerRadius(10)
                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
                            }
                            .disabled(prompt == "")
                            .animation(.default, value: prompt == "")
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.8), lineWidth: 1))
                            .cornerRadius(10)
                        }
                        .padding(.vertical)
                    }
                }
                .navigationTitle("Image Generator")
                .toolbar {
                    if image != nil {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: saveImage) {
                                Text("Save Image").animation(.default)
                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
                            }
                            .animation(.default, value: image != nil)
                        }
                    }
                }
                .alert(isPresented: self.$saveImageAlert) {
                    Alert(title: Text("The Image Has Been Saved."), dismissButton: .default(Text("Ok")))
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .animation(.default, value: image != nil)
            .padding(.horizontal)
        }
    }

    private func generateImage() {
        print("Generate Image Button Did Tapped.")
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
                    generationPoints -= 1
                }
            } catch {
                print(error.localizedDescription)

            }
        }
    }

    private func saveImage() {
        print("Save Image Button Did Tapped.")
        self.saveImageAlert.toggle()
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
