//
//  ViewController.swift
//  WCLSegmentedView
//
//  Created by 王崇磊 on 2016/11/30.
//  Copyright © 2016年 王崇磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UIScrollViewDelegate {

    var segment: WCLSegmentedView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectColor = UIColor.init(red: 70.0/255.0, green: 104.0/255.0, blue: 176.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = selectColor
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view, typically from a nib.
        segment = WCLSegmentedView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 29)), textArr: ["最新", "热门", "排行"], select: { [weak self](index) in
            let width = self?.scrollView.frame.width
            self?.scrollView.setContentOffset(CGPoint.init(x: CGFloat(index)*width!, y: 0), animated: true)
        })
        segment?.cornerRadius = 14
        segment?.selectColor = selectColor
        navigationItem.titleView = segment
        
        let count = segment!.numberOfSegments
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize.init(width: view.frame.size.width * CGFloat(count), height: view.frame.size.height-64)
        let width  = view.frame.size.width
        let height = view.frame.size.height
        for i in 0..<count {
            let v = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: CGFloat(i) * width, y: 0), size: CGSize.init(width: width, height: height - 64)))
            let arr     = ["最新", "热门", "排行", "牛掰"][0...(i+1)]
            let textArr = [String](arr)
            let segment = WCLSegmentedView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 66*textArr.count, height: 29)), textArr:  textArr, select: nil)
            segment.cornerRadius = [0, 4, 14][i]
            segment.center       = CGPoint.init(x: width/2.0, y: height/2.0-64)
            let color            = [UIColor.red, UIColor.blue, UIColor.orange][i]
            v.backgroundColor    = color
            segment.selectColor  = color
            v.addSubview(segment)
            scrollView.addSubview(v)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX       = scrollView.contentOffset.x
        let progress      = offSetX/(scrollView.contentSize.width - scrollView.frame.width)
        segment?.progress = Double(progress)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

