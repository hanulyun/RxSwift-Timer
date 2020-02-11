//
//  TimerView.swift
//  RxSwift-Timer
//
//  Created by HanulYun-Comp on 2020/02/11.
//  Copyright © 2020 Yun. All rights reserved.
//

import UIKit
import RxSwift

class TimerView: UIView {
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    let titleText: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray
        return label
    }()
    fileprivate let timerValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        label.text = "0"
        label.textColor = .darkText
        return label
    }()
    fileprivate let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    fileprivate let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    fileprivate let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    init(title: String, color: UIColor) {
        self.titleText = title
        
        super.init(frame: .zero)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        layer.borderColor = color.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        
        configureAutolayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimerView {
    func timerValueSetting(_ value: Int) {
        timerValueLabel.text = String(value)
    }
    
    func startButtonTapEvent(isTap: ((Bool) -> Void)?) {
        startButton
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe { _ in
                isTap?(true)
        }.disposed(by: disposeBag)
    }
    
    func stopButtonTapEvent(isTap: ((Bool) -> Void)?) {
        stopButton
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe { _ in
                isTap?(true)
        }.disposed(by: disposeBag)
    }
    
    func resetButtonTapEvent(isTap: ((Bool) -> Void)?) {
        resetButton
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe { _ in
                isTap?(true)
        }.disposed(by: disposeBag)
    }
}

extension TimerView {
    fileprivate func configureAutolayouts() {
        let views: [UIView] = [titleLabel, timerValueLabel, startButton, stopButton, resetButton]
        views.forEach({addSubview($0)})
        views.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let titleLabelConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ]
        
        let timerValueLabelConstraints: [NSLayoutConstraint] = [
            timerValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            timerValueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        let startButtonConstraints: [NSLayoutConstraint] = [
            startButton.topAnchor.constraint(equalTo: timerValueLabel.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            startButton.heightAnchor.constraint(equalToConstant: 30),
            startButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]

        let endButtonConstraints: [NSLayoutConstraint] = [
            stopButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            stopButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 20),
            stopButton.heightAnchor.constraint(equalTo: startButton.heightAnchor)
        ]

        let resetButtonConstraints: [NSLayoutConstraint] = [
            resetButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor),
            resetButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalTo: startButton.heightAnchor),
            resetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ]
        
        [titleLabelConstraints, timerValueLabelConstraints, startButtonConstraints, endButtonConstraints, resetButtonConstraints]
            .forEach({NSLayoutConstraint.activate($0)})
    }
}
