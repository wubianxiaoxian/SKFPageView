//
//  SKFContentView.swift
//  StudySwiftTableview
//
//  Created by 孙凯峰 on 2017/5/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit

protocol SKFContentViewDelegate:class {
    func contentView(_ contentView:SKFContentView,index:Int)
    func contengView(_ contentView:SKFContentView,sourceIndex:Int,targetIndex:Int,progress:CGFloat)
}

private let kContentCellid = "CellID"
class SKFContentView: UIView {
    weak var delegate:SKFContentViewDelegate?
    fileprivate var childVcs:[UIViewController]
    fileprivate var parentVc:UIViewController
    fileprivate var startOffsetX:CGFloat=0
    fileprivate var isForbidDelegete:Bool=false
    fileprivate lazy var collectionView:UICollectionView={

        let layout=UICollectionViewFlowLayout()
        layout.itemSize=self.bounds.size
        layout.minimumLineSpacing=0
        layout.minimumInteritemSpacing=0
        layout.scrollDirection = .horizontal
        let collectionView=UICollectionView(frame: self.bounds, collectionViewLayout: layout)
//        let collectionView=UICollectionView()
        collectionView.showsVerticalScrollIndicator=false
        collectionView.isPagingEnabled=true
        collectionView.scrollsToTop=false
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.bounces = false

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellid)

        return collectionView
    }()
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
        self.childVcs=childVcs
        self.parentVc=parentVc
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKFContentView{
    fileprivate func setupUI(){
        //1. 添加collectionview
      addSubview(collectionView)
        //2 将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        
    }
}
// MARK:-数据源和代理
extension SKFContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1 获取cell
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellid, for: indexPath)
        //2 给cell设置内容
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc=childVcs[indexPath.item]
        childVc.view.frame=cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        cell.backgroundColor=UIColor.randomColor
        return cell
        
    }
    
}
extension SKFContentView:UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //没有减速
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    func collectionViewDidEndScroll()  {
        //1 获取位置
      let inIndex =  Int(collectionView.contentOffset.x/collectionView.bounds.width)
        //2 通知代理
        delegate?.contentView(self,index:inIndex)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegete=false
        startOffsetX=scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否需要执行后续的代码
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegete {
            return
        }
        //定义需要的参数

        var progress :CGFloat = 0
        var targetIndex = 0
        var sourceIndex = Int(startOffsetX/collectionView.bounds.width)
        
        // 判断左滑动 还是右滑动
        
        if collectionView.contentOffset.x>startOffsetX{
            //左滑动
            targetIndex=sourceIndex+1
            progress=(collectionView.contentOffset.x-startOffsetX)/collectionView.bounds.width
        } else{
            //右滑动
            targetIndex=sourceIndex-1
            progress=(startOffsetX-collectionView.contentOffset.x)/collectionView.bounds.width

        }
        
        print("sourceIndex:",sourceIndex,"targetIndex",targetIndex,"progress",progress)
        // 通知代理
        delegate?.contengView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        
        
    }
    
}
extension SKFContentView:SKFTitleViewDelegate{
    func titleView(_ titleView: SKFTitleView, currentIndex: Int) {
        //0 设置iSForbidDelegete的属性为True
        isForbidDelegete=true
        // 1根据currentIndex获取indexpath
        let  indexPath = IndexPath(item:currentIndex,section:0)
        //2 滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        
        
    }
}
