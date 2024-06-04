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
        
        deleteButton.rx.tap
            .bind { _ in
                Console.debug("delteButton Tapped!!")
            }
            .disposed(by: disposeBag)
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
    
    private func addWhiteX() {
        let xPath = UIBezierPath()
        let lineWidth: CGFloat = 1.0
        
        // X의 시작점과 끝점을 계산
        xPath.move(to: CGPoint(x: 2, y: 2))
        xPath.addLine(to: CGPoint(x: 8, y: 8))
        xPath.move(to: CGPoint(x: 8, y: 2))
        xPath.addLine(to: CGPoint(x: 2, y: 8))
        
        // X를 그리기 위한 레이어
        let xShapeLayer = CAShapeLayer()
        xShapeLayer.path = xPath.cgPath
        xShapeLayer.strokeColor = UIColor.white.cgColor
        xShapeLayer.lineWidth = lineWidth
        
        // 버튼에 X 레이어 추가
        self.layer.addSublayer(xShapeLayer)
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
