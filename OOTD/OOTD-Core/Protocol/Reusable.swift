//
//  Reusable.swift
//  OOTD-Core
//
//  Created by taekki on 2022/09/12.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UIViewController: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
