//
//  HomeView.swift
//  TextSummary
//
//  Created by Şule Kaptan on 10.02.2025.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isLightMode = false
    @State private var userInput: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var viewModel = TextSummaryViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(gradient: Gradient(colors: isLightMode ? [Color.white, Color.purple] : [Color.black, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    ScrollView{
                        TextEditor(text: $userInput)
                            .frame(height: 450)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            hideKeyboard()
                            if userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                alertMessage = "Please enter valid text!\n\nLütfen geçerli bir metin giriniz!"
                                showAlert = true
                                
                            } else {
                                viewModel.summarizeText(userInput)
                            }
                        }) {
                            Text("Summarize Texssssssst!")
                                .font(.title2)
                                .foregroundColor(isLightMode ? .black : .white)
                                .padding()
                                .frame(width: 200)
                                .background(isLightMode ? .white : .black)
                                .cornerRadius(50)
                                .shadow(radius: 5)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
//                        .alert(isPresented: $showAlert) {
//                            Alert(title: Text("Please enter valid text!\n\nLütfen geçerli bir metin giriniz!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                        }
                        .padding()
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        }
                        if !viewModel.summary.isEmpty {
                            Text(viewModel.summary)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                }
                .padding()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("TEXT SUMMARY")
                            .font(.custom("Liter", fixedSize:24))
                            .bold()
                            .foregroundColor(isLightMode ? .black : .white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isLightMode.toggle()
                    } label: {
                        Image(systemName: isLightMode ? "moon.fill" : "sun.max")
                            .foregroundColor(isLightMode ? .black : .white)
                    }
                }
            }
        }
    }
}

extension HomeView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
