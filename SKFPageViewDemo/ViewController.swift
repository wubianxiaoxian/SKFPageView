//
//  ViewController.swift
//  StudySwiftTableview
//
//  Created by 孙凯峰 on 2017/5/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets=false
        
        
        //1,创建需要的样式
        let style = SKFPageStyle()
//        style.isScrollEnabel=true
        style.isShowBottomLine=true
        style.isScaleEnable=true
        
        //2.获取所有的标题
        
        let  titles = ["精选","电影","小龙虾","皮皮虾","京酱肉丝","还有啥"]

        
        //3,获取所有的内容控制器
        //两种区间
        // 0..<5 0
        var childVcs = Array<UIViewController>()
        
        for _ in 0..<titles.count {
            let vc=UIViewController()
            vc.view.backgroundColor=UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVcs.append(vc)
        }
        //4,创建SKFPageView
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        
        let pageView=SKFPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs,parentVc:self)
        pageView.backgroundColor = .blue
        view.addSubview(pageView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


