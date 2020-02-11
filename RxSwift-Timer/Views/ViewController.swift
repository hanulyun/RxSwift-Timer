//
//  ViewController.swift
//  RxSwift-Timer
//
//  Created by HanulYun-Comp on 2020/02/11.
//  Copyright © 2020 Yun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    fileprivate let isRunningFirst: BehaviorRelay = BehaviorRelay(value: false)
    fileprivate var isRunningSecond: Bool = false
    var secondTimerValue: Int = 0
    
    fileprivate let firstTimerView: TimerView = TimerView(title: "Timer 1", color: .systemTeal)
    fileprivate let secondTimerView: TimerView = TimerView(title: "Timer 2", color: .systemOrange)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAutolayouts()
                
        configureTimerViews()
        configureButtonsEvent()
    }
}

extension ViewController {
    fileprivate func configureTimerViews() {
        configureFirstTimerView()
        configureSecondTimerView()
    }
    
    fileprivate func configureFirstTimerView() {
        isRunningFirst.asObservable()
        .debug("isRunningFirst")
            .flatMapLatest { isRunning in
            isRunning ? Observable<Int>
                .interval(.seconds(1), scheduler: MainScheduler.instance) : .empty()
        }
        .subscribe(onNext: { [weak self] value in
            self?.firstTimerView.timerValueSetting(value)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureSecondTimerView() {
        let driver = Driver<Int>.interval(.seconds(1)).map { _ in
            return 1
        }
        driver.asObservable()
            .subscribe(onNext: { [weak self] value in
                if self!.isRunningSecond {
                    self?.secondTimerValue += value
                    self?.secondTimerView.timerValueSetting(self!.secondTimerValue)
                }
            }).disposed(by: disposeBag)
    }
}

extension ViewController {
    fileprivate func configureButtonsEvent() {
        configureFirstTimerButtonEvent()
        configureSecondTimerButtonEvent()
    }
    
    fileprivate func configureFirstTimerButtonEvent() {
        firstTimerView.startButtonTapEvent { [weak self] _ in
            self?.isRunningFirst.accept(true)
        }
        
        firstTimerView.stopButtonTapEvent { [weak self] _ in
            self?.isRunningFirst.accept(false)
        }
        
        firstTimerView.resetButtonTapEvent { [weak self] _ in
            self?.isRunningFirst.accept(false)
            self?.firstTimerView.timerValueSetting(0)
        }
    }
    
    fileprivate func configureSecondTimerButtonEvent() {
        secondTimerView.startButtonTapEvent { [weak self] _ in
            self?.isRunningSecond = true
        }
        
        secondTimerView.stopButtonTapEvent { [weak self] _ in
            self?.isRunningSecond = false
        }
        
        secondTimerView.resetButtonTapEvent { [weak self] _ in
            self?.isRunningSecond = false
            self?.secondTimerValue = 0
            self?.secondTimerView.timerValueSetting(self!.secondTimerValue)
        }
    }
}

extension ViewController {
    fileprivate func configureAutolayouts() {
        [firstTimerView, secondTimerView].forEach({view.addSubview($0)})
        [firstTimerView, secondTimerView].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let firstTimerViewConstraints: [NSLayoutConstraint] = [
            firstTimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstTimerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
        
        let secondTimerViewConstraints: [NSLayoutConstraint] = [
            secondTimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondTimerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ]
        
        [firstTimerViewConstraints, secondTimerViewConstraints].forEach({NSLayoutConstraint.activate($0)})
    }
}
