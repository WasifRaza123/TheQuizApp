//
//  HomeViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var startQuizButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.setTitle("Start Quiz", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(startQuizButton)
        
        
        startQuizButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startQuizButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startQuizButton.heightAnchor.constraint(equalToConstant: 100),
            startQuizButton.widthAnchor.constraint(equalToConstant: 100),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startQuizButton.topAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func didTapStartButton() {
        let vc = UINavigationController(rootViewController: QuizViewController())
        navigationController?.pushViewController(QuizViewController(), animated: true)
    }
}
