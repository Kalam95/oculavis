//
//  UIImageView+Download.swift
//  Task2
//
//  Created by mehboob Alam.
//

import UIKit

extension UIImageView {
    
    /// Methdo to download the image using URLSessionDownloadTask, It also check if image is chached or not
    /// - Parameter url: url from where its is supposed to be downloaded
    private func downloadImageIfRequired(from url: URL) {
        // check if imaged is already in cache or not
        if let image = CacheManager.shared.getImage(for: url.absoluteString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            return
        }
        URLSession.shared.downloadTask(with: url) { responseURL, response, error in
            guard let responseURL = responseURL,
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = try? Data(contentsOf: responseURL), error == nil,
                let responseImage = UIImage(data: data)
                else { return }
            //set image to cahche
            CacheManager.shared.set(image: responseImage, for: url.absoluteString as NSString)
            DispatchQueue.main.async { [weak self] in
                self?.image = responseImage
            }
        }.resume()
    }

    /// Methdo to download the image using URLSessionDownloadTask, It also check if image is chached or not
    /// - Parameter url: url from where its is supposed to be downloaded
    func setImage(from string: String) {
        guard let url = URL(string: string) else { return }
        downloadImageIfRequired(from: url)
    }
}
