//
//  MyPageViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit
import Kingfisher

protocol MyPagePresentableListener: AnyObject {
    func setAccountButtonTapped()
    func setAlarmButtonTapped()
    func setInterestedTagsButtonTapped()
}

final class MyPageViewController: UIViewController, MyPagePresentable, MyPageViewControllable {
    
    weak var listener: MyPagePresentableListener?
    private var disposeBag = DisposeBag()
    private var data: BehaviorRelay<UserReadDTO> = .init(value: .init(id: "", nickname: "", profileImageUrl: "", interestedTags: []))
    
    // MARK: - UIComponents
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "profileImage")
        imageView.image = UIImage(systemName: "person.crop.circle")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.gray05, text: "사용자")
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray03, text: "@OfflineUser")
        return label
    }()
    
    private let showMyArticleButton: UIView = {

        let backgroundView = UIView()
        backgroundView.backgroundColor = .particleColor.gray01
        backgroundView.layer.cornerRadius = 16

        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        label.textColor = .particleColor.white
        label.text = "내가 저장한 아티클"

        let icon = UIImageView()
        icon.image = .particleImage.arrowRight
        
        [label, icon].forEach {
            backgroundView.addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }

        icon.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        return backgroundView
    }()
    
    private let sectionTitle: UILabel = {
        let label = UILabel()
//        label.setParticleFont(.p_txtbutton, color: .particleColor.gray03, text: "설정")
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        label.textColor = .particleColor.gray03
        label.text = "설정"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = .particleImage.mypageTabIcon
        tabBarItem.title = "마이"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
        
        addSubviews()
        setConstraints()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMyArticleButtonTapped))
//        showMyArticleButton.addGestureRecognizer(tapGesture)
        
//        addRows(
//            icon: .particleImage.bell,
//            title: "알림 설정",
//            selector: #selector(setAlarmButtonTapped)
//        )
        addRows(
            icon: .particleImage.tag,
            title: "관심 태그 설정",
            selector: #selector(setInterestedTagButtonTapped)
        )
//        addRows(
//            icon: .particleImage.grid,
//            title: "위젯 설정",
//            selector: #selector(setWidgetButtonTapped)
//        )
        addRows(
            icon: .particleImage.user2,
            title: "계정 설정",
            selector: #selector(setAccountButtonTapped)
        )
        
//        bind()
    }
    
    private func bind() {
        data.subscribe { [weak self] dto in
            guard let item = dto.element else { return }
            self?.idLabel.text = "@\(item.id)"
            self?.nickNameLabel.text = item.nickname
//            self?.profileImageView.image = dto.element?.profileImageUrl
            self?.profileImageView.kf.setImage(with: URL(string: item.profileImageUrl))
        }
        .disposed(by: disposeBag)

    }
    
    private func addRows(icon: UIImage?, title: String, selector: Selector?) {
        let row = UIView()
        row.snp.makeConstraints {
            $0.width.equalTo(DeviceSize.width)
            $0.height.equalTo(54)
        }

        let iconImage = UIImageView()
        iconImage.image = icon

        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        label.textColor = .particleColor.white
        label.text = title

        [iconImage, label].forEach {
            row.addSubview($0)
        }

        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(iconImage.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }

        stackView.addArrangedSubview(row)
        
        let tabAction = UITapGestureRecognizer(target: self, action: selector)
        row.addGestureRecognizer(tabAction)
    }
    
    func setData(data: UserReadDTO) {
        self.data.accept(data)
    }
    
    @objc private func setAlarmButtonTapped(){
        listener?.setAlarmButtonTapped()
    }
    
    @objc private func setInterestedTagButtonTapped(){
        listener?.setInterestedTagsButtonTapped()
    }
    
    @objc private func setWidgetButtonTapped(){
        Console.debug("\(#function)")
    }
    
    @objc private func setAccountButtonTapped(){
        Console.debug("\(#function)")
        listener?.setAccountButtonTapped()
    }
    
    @objc private func showMyArticleButtonTapped(){
        Console.debug("\(#function)")
    }
    
}

// MARK: - Layout Settting

private extension MyPageViewController {
    
    func addSubviews() {
        [
            profileImageView,
            nickNameLabel,
            idLabel,
//            showMyArticleButton,
            sectionTitle,
            stackView
        ]
            .forEach {
                view.addSubview($0)
            }
    }
    
    func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(4)
        }
        
//        showMyArticleButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(59)
//            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
//        }
        
        sectionTitle.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(sectionTitle.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(216)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewController().showPreview()
    }
}
#endif
