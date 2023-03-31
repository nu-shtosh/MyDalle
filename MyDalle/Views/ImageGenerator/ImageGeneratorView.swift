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

    @State private var loadingText = ""

    @State private var isZoomed = false


    var body: some View {

        NavigationView {
            ScrollView {
                VStack {
                    if let image {
//                        ScrollView(.vertical) {
//                            ScrollView(.horizontal) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)

//                                    .ignoresSafeArea(.all)
                                    .cornerRadius(10)
//                                    .onTapGesture {
//                                        withAnimation {
//                                            isZoomed.toggle()
//                                        }
//                                    }
//                            }
//                        }
                    } else {
                        VStack {
                            Rectangle()
                                .fill(Color.clear)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                                .overlay {
                                    VStack {
                                        if isLoading {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                            Text(loadingText)
                                                .foregroundColor(Color("deepBlue"))
                                                .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                                                .onAppear {
                                                    self.loadingText = "Generating Image..."
                                                }
                                                .animation(Animation.easeInOut(duration: 0.5), value: loadingText)
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
                        VStack(alignment: .leading, spacing: 5) {
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
                        .padding(12)
                        .background(.gray.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("deepBlue"), lineWidth: 2))
                        .cornerRadius(10)
                        .padding(.vertical, 5)


                        TextField("Enter a sample...", text: $prompt, axis: .vertical)
                            .padding(10)
                            .font(Font.system(size: 16, weight: .medium, design: .monospaced))
                            .background(.blue.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("deepBlue"), lineWidth: 2))
                            .cornerRadius(10)

                        HStack(spacing: 20) {
                            Button(action: generateImage) {
                                Text("Generate Image")
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 30)
                                    .padding(10)
                                    .background(prompt == "" ? .gray.opacity(0.8) : Color("deepBlue"))
                                    .cornerRadius(10)
                                    .font(Font.system(size: 16, weight: .medium, design: .serif))
                            }
                            .disabled(prompt == "")
                            .animation(.default, value: prompt == "")
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("deepBlue"), lineWidth: 2))
                            .cornerRadius(10)
                        }
                        .padding(.vertical, 5)
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
        loadingText = ""
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
