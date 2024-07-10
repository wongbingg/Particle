//
//  UIImage+.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/21.
//

import UIKit
import Photos

extension UIImageView {
    
    func fetchImage(
        asset: PHAsset,
        contentMode: PHImageContentMode,
        targetSize: CGSize,
        _ completion: ((CGFloat) -> Void)? = nil) {
        
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        PHCachingImageManager().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: options) { image, info in
                
                if let image = image {
                    self.image = image
                    completion?(image.size.height / image.size.width)
                } else {
                    Console.error("\(#function) image 가 존재하지 않습니다.")
                }
            }
    }
}

extension PHAsset {
    
    func toImage(
        contentMode: PHImageContentMode,
        targetSize: CGSize,
        _ completion: @escaping (UIImage?) -> Void) {
        
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        PHCachingImageManager().requestImage(
            for: self,
            targetSize: targetSize,
            contentMode: contentMode,
            options: options
        ) { image, info in
            
            guard let image = image else {
                Console.error(#function)
                print(info ?? #function)
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
