//
//  UIImageView+Extensions.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, showLoadingIndicator: Bool = true) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL or nil urlString")
            return
        }

        let cache = URLCache.shared
        let request = URLRequest(url: url)

        // Check if the image is already cached
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
            return
        }

        // Optionally, add a loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        if showLoadingIndicator {
            DispatchQueue.main.async {
                self.addSubview(activityIndicator)
                activityIndicator.startAnimating()
            }
        }

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        if showLoadingIndicator {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        }
                    }
                    // Cache the downloaded data
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                } else {
                    print("Error: Data could not be converted to UIImage")
                }
            } catch {
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
