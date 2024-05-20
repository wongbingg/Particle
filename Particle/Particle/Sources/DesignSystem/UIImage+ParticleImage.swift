//
//  UIImage+ParticleImage.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import UIKit

extension UIImage {
    static let particleImage = ParticleImage()
}

struct ParticleImage {
    
    // MARK: - Button
    
    let backButton = UIImage(named: "backButtonIcon")
    let backButton2 = UIImage(named: "chevron-left")
    let xmarkButton = UIImage(named: "xmark")
    let plusButton = UIImage(named: "plus")
    let refreshButton = UIImage(named: "refresh")
    let arrowUp = UIImage(named: "chevron-up")
    let arrowUp_main = UIImage(named: "chevron-up-main")
    let arrowRight = UIImage(named: "chevron-right")
    let ellipsis = UIImage(named: "more-horizontal")
    let heart = UIImage(named: "heart")
    let info = UIImage(named: "info")
    let check = UIImage(named: "check")

    let kakaoLogo = UIImage(named: "kakaoLogo")
    let appleLogo = UIImage(named: "appleLogo")
    
    let keyboardDownButton = UIImage(
        systemName: "keyboard.chevron.compact.down"
    )?.applyingSymbolConfiguration(
        .init(weight: .semibold)
    )
    
    // MARK: - Tab Icon
    
    let homeTabIcon = UIImage(named: "home")
    let searchTabIcon = UIImage(named: "search")
    let exploreTabIcon = UIImage(named: "book-open")
    let mypageTabIcon = UIImage(named: "user")
    
    let bell = UIImage(named: "bell")
    let grid = UIImage(named: "grid")
    let tag = UIImage(named: "tag")
    let user2 = UIImage(named: "user2")
    
    // MARK: - Etc
    
    let checkBox = UIImage(named: "checkbox")
    let checkBox_checked = UIImage(named: "checkbox_checked")
    let loginBackground = UIImage(named: "loginBackground")
    
    let eyes = UIImage(named: "eyes")
    let tooltip1 = UIImage(named: "tooltip1")
    
    // MARK: - TextStyle Cell Background
    let background_main100 = UIImage(named: "background_textstyle_main100")
    let background_yellow = UIImage(named: "background_textstyle_yellow")
}
