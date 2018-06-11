//
//  HideFloatingWindowView.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

/*
 1、一个红色的圆弧View CAShapeLayer
 2、一个图片和文字 UIButton，自定义布局方式
 */

class HideFloatingWindowView: UIView {
    
    public func moreRedBackground(_ more: Bool){
        var radius = frame.width
        if more {
            radius += 5
        }
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width + 10, y: frame.height + 10), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        maskLayer.path = path.cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        moreRedBackground(false)
        
        addSubview(iconBtn)
        iconBtn.sizeToFit()
        iconBtn.frame.origin.x = self.frame.width * 0.5 - iconBtn.frame.width * 0.5
        iconBtn.frame.origin.y = self.frame.height * 0.5 - iconBtn.frame.height * 0.5
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconBtn: PQButton = {
        let btn = PQButton(.bottom)
        btn.setTitle("取消浮窗", for: .normal)
        btn.setImage(UIImage(named: "btn_hide_floating_window"), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return btn
    }()
    
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        self.layer.mask = layer
        return layer
    }()
}


//自定义按钮
class PQButton: UIButton {
    
    convenience init(_ textLayout: EIQMenuTextLayout){
        self.init(frame: .zero)
        self.textLayout = textLayout
    }
    
    enum EIQMenuTextLayout: Int {
        case top,left,bottom,right
    }
    public var spacing: CGFloat = 20
    public var textLayout: EIQMenuTextLayout = .right
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        guard let title = self.titleLabel?.text as NSString?, let titleFont = self.titleLabel?.font else { return }
        
        let imageSize = self.imageRect(forContentRect: self.frame)
        
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font : titleFont])
        
        var titleInsets: UIEdgeInsets = self.titleEdgeInsets
        var imageInsets: UIEdgeInsets = self.imageEdgeInsets
        switch textLayout {
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        default:
            break
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
