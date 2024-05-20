//
//  PhotoCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

import UIKit

import RxSwift
import Photos

class CacheManager {
    static let shared = CacheManager()
    private let imageCache = NSCache<NSString, UIImage>()
    private let totalCostLimit = 1024*1024*400

    private init() {
        imageCache.totalCostLimit = totalCostLimit
    }

    func cacheImage(_ image: UIImage, forKey key: String) {
//        imageCache.setObject(image, forKey: key as NSString)
        imageCache.setObject(image, forKey: key as NSString, cost: totalCostLimit)
    }

    func image(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}

final class PhotoCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    private enum Metric {
        static let checkBoxSize: CGFloat = 20
        static let checkBoxTopTrailiingInset: CGFloat = 8
    }
    
    // MARK: - UIComponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.checkBox
        return imageView
    }()
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    private let checkBox_checked: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.checkBox_checked
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let number = UILabel()
        number.font = .systemFont(ofSize: 12)
        number.textColor = .white
        return number
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        contentView.clipsToBounds = true
        checkBox_checked.alpha = 0
        dimmingView.alpha = 0
        numberLabel.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        uncheck()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func setImage(with asset: PHAsset) {

        if let cachedImage = CacheManager.shared.image(forKey: asset.localIdentifier) {
            self.imageView.image = cachedImage
        } else {
            fetchImage(
                asset: asset,
                contentMode: .default,
                targetSize: imageView.frame.size
            ).subscribe { [ weak self] image in
                self?.imageView.image = image
            }
            .disposed(by: disposeBag)
        }
    }
    
    func check(number: Int) {
        dimmingView.alpha = 0.3
        checkBox_checked.alpha = 1
        numberLabel.alpha = 1
        numberLabel.text = "\(number)"
    }
    
    func uncheck() {
        dimmingView.alpha = .zero
        checkBox_checked.alpha = .zero
        numberLabel.alpha = .zero
    }
    
    private func fetchImage(asset: PHAsset,
                            contentMode: PHImageContentMode,
                            targetSize: CGSize) -> Observable<UIImage> {
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        return Observable.create { emitter in
        
            PHCachingImageManager().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options) { image, info in
                    
                    if let image = image {
                        CacheManager.shared.cacheImage(image, forKey: asset.localIdentifier)
                        emitter.onNext(image)
                    } else {
                        Console.error("\(#function) image 가 존재하지 않습니다.")
                    }
                }
            
            return Disposables.create()
        }
    }
}

// MARK: - Layout Settting

private extension PhotoCell {
    
    func addSubviews() {
        [
            imageView,
            dimmingView,
            checkBox,
            checkBox_checked,
            numberLabel
        ]
            .forEach {
                contentView.addSubview($0)
            }
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView)
        }
        dimmingView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView)
        }
        checkBox.snp.makeConstraints {
            $0.width.height.equalTo(Metric.checkBoxSize)
            $0.top.trailing.equalToSuperview().inset(Metric.checkBoxTopTrailiingInset)
        }
        checkBox_checked.snp.makeConstraints {
            $0.width.height.equalTo(Metric.checkBoxSize)
            $0.center.equalTo(checkBox)
        }
        numberLabel.snp.makeConstraints {
            $0.center.equalTo(checkBox_checked)
        }
    }
}
