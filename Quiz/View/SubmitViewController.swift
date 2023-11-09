//
//  SubmitViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class SubmitViewController: UIViewController {
    private var score:[Int:Int]
    private var submittedAnswers: [Int:String]
    
    private var goToHomePageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.setTitle("Go To Home Page", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init(score: [Int : Int], submittedAnswers: [Int : String]) {
        self.score = score
        self.submittedAnswers = submittedAnswers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(goToHomePageButton)
        goToHomePageButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        goToHomePageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goToHomePageButton.heightAnchor.constraint(equalToConstant: 100),
            goToHomePageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToHomePageButton.topAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func didTapStartButton() {
        
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
        
    
    }
}
