//
//  WCLSegmentedView.swift
//  WCLSegmentedView
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/631106979
//  HomePage:https://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class WCLSegmentedView
// @abstract 自定义的SegmentedView
// @discussion 自定义的SegmentedView
//

import UIKit

class WCLSegmentedView: UIView {
    
    //滑动的进度
    var progress: Double = 0 {
        willSet {
            if allowProgress {
                let width = self.frame.width - (self.labelMask?.frame.width)!
                self.labelMask?.frame.origin = CGPoint.init(x: Double(width)*newValue, y: 0)
            }
        }
    }
    //弧度
    var cornerRadius:CGFloat = 0 {
        willSet {
            layer.cornerRadius  = newValue
        }
    }
    //选中的颜色
    var selectColor: UIColor = UIColor.blue {
        didSet {
            refreshView()
        }
    }
    //默认的颜色
    var defaultColor: UIColor = UIColor.white {
        didSet {
            refreshView()
        }
    }
    //字体
    var textFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            refreshView()
        }
    }
    //文字的数组
    private(set) var textArr:[String] = Array<String>()
    //segment的数量
    var numberOfSegments: Int {
        return textArr.count
    }
    //上面的一层labelView
    private var labelView: UIView?
    //labelView上的遮罩
    private var labelMask: UIView?
    //所有的button
    private var buttons = [UIButton]()
    //搜有的label
    private var labels  = [UILabel]()
    //点击的回调
    private var selectBlock: ((_ index: Int) -> Void)?
    //允许Progress调整
    private var allowProgress: Bool = true
    
    //MARK: Public Methods
    
    
    //MARK: Override
    override func layoutSubviews() {
        super.layoutSubviews()
        configItem(textArr)
    }
    
    //MARK: Initial Methods
    init(frame: CGRect, textArr: [String] ,select:((_ index: Int) -> Void)?) {
        assert(textArr.count > 1)
        super.init(frame: frame)
        selectBlock = select
        layer.masksToBounds = true
        layer.cornerRadius  = 4
        layer.borderWidth   = 1
        self.textArr        = textArr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setter Getter Methods
    
    
    //MARK: Privater Methods
    private func configItem(_ textArr: [String]) {
        guard textArr.count > 0 else {
            return
        }
        layer.borderColor = defaultColor.cgColor
        backgroundColor   = defaultColor
        labelView = UIView.init(frame: bounds)
        labelView?.isUserInteractionEnabled = false
        labelView?.backgroundColor          = defaultColor
        let eachWidth                       = (frame.width - CGFloat(textArr.count-1))/CGFloat(textArr.count)
        let eachHeight                      = frame.height
        var index:CGFloat                   = 0
        for text in textArr {
            let fram = CGRect.init(x: index*eachWidth+index, y: 0, width: eachWidth, height: eachHeight)
            let button              = UIButton.init(frame: fram)
            button.tag              = 100+Int(index)
            button.titleLabel?.font = textFont
            button.backgroundColor  = selectColor
            if index == 0 {
                button.isSelected = true
            }
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitle(text, for: .normal)
            button.setTitleColor(defaultColor, for: .normal)
            addSubview(button)
            buttons.append(button)
            
            let label             = UILabel.init(frame: fram)
            label.text            = text
            label.textColor       = selectColor
            label.font            = textFont
            label.backgroundColor = defaultColor
            label.textAlignment   = .center
            labelView?.addSubview(label)
            labels.append(label)
            index = index + 1
        }
        labelMask = UIView()
        labelMask?.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: eachWidth, height: eachHeight))
        labelMask?.backgroundColor = UIColor.white
        labelView?.mask = labelMask
        addSubview(labelView!)
    }
    
    private func refreshView() {
        labelView?.backgroundColor = defaultColor
        backgroundColor            = defaultColor
        layer.borderColor          = defaultColor.cgColor
        for label in labels {
            label.textColor        = selectColor
            label.font             = textFont
            label.backgroundColor  = defaultColor
        }
        for button in buttons {
            button.titleLabel?.font = textFont
            button.backgroundColor  = selectColor
            button.setTitleColor(defaultColor, for: .normal)
        }
    }
    
    //MARK: KVO Methods
    
    
    //MARK: Notification Methods
    @objc private func buttonAction(sender: UIButton) {
        isUserInteractionEnabled = false
        let index = sender.tag - 100
        selectBlock?(index)
        let newProgress = Double(index)/Double(self.numberOfSegments-1)
        allowProgress = false
        UIView.animate(withDuration: 0.3, animations: {
            let width = self.frame.width - (self.labelMask?.frame.width)!
            self.labelMask?.frame.origin = CGPoint.init(x: Double(width)*newProgress, y: 0)
        }, completion: { (complete) in
            self.progress            = newProgress
            self.allowProgress       = true
            self.isUserInteractionEnabled = true
        })
    }
    
    //MARK: Target Methods
    
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}
