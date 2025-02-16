//
//  TextSummaryViewModel.swift
//  TextSummary
//
//  Created by Şule Kaptan on 11.02.2025.
//

import Foundation

class TextSummaryViewModel: ObservableObject {
    @Published var summary: String = ""
    @Published var isLoading: Bool = false
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["API_KEY"] as? String else {
                fatalError("API_KEY bulunamadı! Config.plist dosyasını kontrol et.")
            }
        return key
    }
    
    func summarizeText(_ text: String) {
        guard !text.isEmpty else { return }
        self.isLoading = true
        self.summary = ""
        
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": text + "\nBu metni özetle."]
                    ]
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                guard let data = data, error == nil else {
                    self.summary = "Özetleme başarısız oldu."
                    return
                }
                
                if let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = responseJSON["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let summaryText = parts.first?["text"] as? String {
                    self.summary = summaryText
                } else {
                    self.summary = "Geçerli bir özet bulunamadı."
                }
            }
        }
        .resume()
    }

}
