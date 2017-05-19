//
//  SKFPageView.swift
//  StudySwiftTableview
//
//  Created by 孙凯峰 on 2017/5/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit




class SKFPageView: UIView {
    //swift中，如果类有自定义构造函数，或者重新父类的构造函数，那么必须实现父类中使用required修饰的构造函数
    // MARK:- 定义属性
    
    
    fileprivate  var style : SKFPageStyle
    fileprivate  var titles :[String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc :UIViewController
    
    
    // MARK:- 构造函数
    init(frame: CGRect,style:SKFPageStyle,titles:[String],childVcs:[UIViewController],parentVc:UIViewController) {
        self.style=style
        self.titles=titles
        self.childVcs=childVcs
        self.parentVc=parentVc
        super.init(frame:frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SKFPageView{
    fileprivate func setupUI(){
        //1 创建SKFTitleViewz
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        
        let titleView=SKFTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor=UIColor.randomColor
        titleView.backgroundColor = UIColor.orange
        addSubview(titleView)
        //2 创建SKFcontentview
        let contentFrame=CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height)
        let contentView=SKFContentView(frame: contentFrame, childVcs: childVcs,parentVc:parentVc)
        contentView.backgroundColor=UIColor.randomColor
        addSubview(contentView)
        //3 让SKFTitleView&SKFcontentview进行交互
        titleView.delegate=contentView
        contentView.delegate = titleView
    }
}
