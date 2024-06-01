//
//  SystemEventHandler.swift
//  Particle
//
//  Created by 이원빈 on 6/1/24.
//

import Foundation

protocol SystemEventHandler: AnyObject {
    func sceneDidBecomeActive()
    func sceneWillResignActive()
}
