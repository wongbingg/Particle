//
//  ReusableCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import UIKit

public protocol ReusableView: AnyObject {
    /// Get identifier from class
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        // Set the Identifier from class name
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView { }

extension UITableView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionViewCell: ReusableView { }
extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    public func register<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind elementKind: String) {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusableSupplementaryView: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        return view
    }
}

