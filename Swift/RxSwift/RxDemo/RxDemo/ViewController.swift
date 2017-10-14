//
//  ViewController.swift
//  RxDemo
//
//  Created by 黄继平 on 2017/10/14.
//  Copyright © 2017年 EApple. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

          _ =  Observable.of("1","2","3","4","5","6","7","8","9")
        
        let evenNumberObservable = Observable.from(["1","2","3","4","5","6","7","8","9"]).map {Int($0)}.filter {
            if let item = $0 , item % 2 == 0 {
                print("even : \(item)")
                return true
            }
            
            return false
        }
        // 注意这里的map和filter操作 与 对一般序列的map/filter操作不同, 一般的map/filter会立刻执行,这里的是回调,当我们对evenNumberObservable订阅时,才会执行,属于Rx中的cold操作
        
        _ = evenNumberObservable.skip(2).subscribe( // 这里skip表示跳过前两个数
            onNext: {even in print("interesting Event number:\(even)")},
            onError: {print($0)},
            onCompleted: {print("completed")},
            onDisposed:{}
            
        )
        /*
         even : 2
         even : 4
         even : 6
         interesting Event number:Optional(6)
         even : 8
         interesting Event number:Optional(8)
         completed
         */
        
        // 使用bag回收销毁Observable
        var bag = DisposeBag()
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe(
            onNext:{print("Subscribed:\($0)")},
            onDisposed:{print("The queue was disposed.")}
        ).disposed(by: bag)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            bag = DisposeBag()
        }
        /*
         Subscribed:0
         Subscribed:1
         Subscribed:2
         Subscribed:3
         Subscribed:4
         The queue was disposed.
         */
    }



}

