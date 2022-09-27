//
//  UIImage+.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/12.
//

import UIKit

extension UIImage {
    
    fileprivate static func load(named name: String) -> UIImage {
        guard let image = UIImage(named: name, in: ODSBundle.bundle, compatibleWith: nil) else {
            assert(false, "\(name) 이미지 로드 실패")
            return UIImage()
        }
        return image
    }
    
    public func resized(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    public func resized(side: CGFloat) -> UIImage {
        return self.resized(width: side, height: side)
    }
}

extension UIImage {
    
    public static var icnAdd: UIImage? { .load(named: "icn.add") }
    public static var icnBack: UIImage? { .load(named: "icn.back") }
    public static var icnCamera: UIImage? { .load(named: "icn.camera") }
    public static var icnCheck: UIImage? { .load(named: "icn.check") }
    public static var icnCheckBoxFill: UIImage? { .load(named: "icn.checkbox.fill") }
    public static var icnCheckBox: UIImage? { .load(named: "icn.checkbox") }
    public static var icnClose: UIImage? { .load(named: "icn.close") }
    public static var icnDelete: UIImage? { .load(named: "icn.delete") }
    public static var icnGithub: UIImage? { .load(named: "icn.github") }
    public static var icnLink: UIImage? { .load(named: "icn.link") }
    public static var icnMenu: UIImage? { .load(named: "icn.menu") }
    public static var icnOption: UIImage? { .load(named: "icn.option") }
    public static var icnPause: UIImage? { .load(named: "icn.pause") }
    public static var icnPlay: UIImage? { .load(named: "icn.play") }
    public static var icnPlusCircle: UIImage? { .load(named: "icn.plus.circle") }
    public static var icnRefresh: UIImage? { .load(named: "icn.refresh") }
    public static var icnTabCheckList: UIImage? { .load(named: "icn.tab.check.list") }
    public static var icnTabProfile: UIImage? { .load(named: "icn.tab.profile") }
    public static var icnTabProjectList: UIImage? { .load(named: "icn.tab.project.list") }
    public static var icnTimer: UIImage? { .load(named: "icn.timer") }
    
    public static var imgGitHubReg: UIImage? { .load(named: "img.github.registration")}
    public static var imgProjectEmpty: UIImage? { .load(named: "img.project.empty")}
    public static var imgSplash: UIImage? { .load(named: "img.splash")}
}
