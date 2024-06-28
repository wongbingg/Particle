//
//  SelectedPhotoCell.swift
//  Particle
//
//  Created by 이원빈 on 6/3/24.
//

import UIKit

import RxSwift
import Photos

final class MiniSelectedPhotoCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    private enum Metric {
        static let checkBoxSize: CGFloat = 20
        static let checkBoxTopTrailiingInset: CGFloat = 8
    }
    
    // MARK: - UIComponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        let xPath = UIBezierPath()
        let lineWidth: CGFloat = 1.2
        
        xPath.move(to: CGPoint(x: 6, y: 6))
        xPath.addLine(to: CGPoint(x: 14, y: 14))
        xPath.move(to: CGPoint(x: 14, y: 6))
        xPath.addLine(to: CGPoint(x: 6, y: 14))
        
        let xShapeLayer = CAShapeLayer()
        xShapeLayer.path = xPath.cgPath
        xShapeLayer.strokeColor = UIColor.white.cgColor
        xShapeLayer.lineWidth = lineWidth
        
        button.layer.addSublayer(xShapeLayer)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func setImage(with asset: PHAsset, manager: PHCachingImageManager) {

        fetchImage(
            asset: asset,
            contentMode: .default,
            targetSize: imageView.frame.size,
            manager: manager
        ).subscribe { [ weak self] image in
            self?.imageView.image = image
        }
        .disposed(by: disposeBag)
    }
    
    func bindDeleteButton(_ action: @escaping () -> Void) {
        deleteButton.rx.tap
            .bind { _ in
                action()
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchImage(asset: PHAsset,
                            contentMode: PHImageContentMode,
                            targetSize: CGSize,
                            manager: PHCachingImageManager) -> Observable<UIImage> {
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.version = .original
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true
        
        return Observable.create { emitter in
            
            let task = manager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options) { image, info in
                    
                    if let image = image {
                        emitter.onNext(image)
                    } else {
                        Console.error("\(#function) image 가 존재하지 않습니다.\(info)")
                    }
                }
            
            return Disposables.create {
                manager.cancelImageRequest(task)
            }
        }
    }
}

// MARK: - Layout Settting

private extension MiniSelectedPhotoCell {
    
    func addSubviews() {
        [imageView]
            .forEach {
                contentView.addSubview($0)
            }
        imageView.addSubview(deleteButton)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView)
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(2)
        }
    }
}
