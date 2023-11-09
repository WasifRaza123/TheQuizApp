//
//  HomeViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var vc: QuizViewController?
    private var viewModel = QuizViewModel()
    
    private var startQuizButton: UIButton = {
        let button = UIButton()
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.setTitle(Constants.startQuizButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(startQuizButton)
        
        startQuizButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startQuizButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startQuizButton.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            startQuizButton.widthAnchor.constraint(equalTo: startQuizButton.heightAnchor),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startQuizButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startQuizButton.layer.cornerRadius = startQuizButton.frame.width/2
    }
    
    private func initViewModel() {
        viewModel.fetchQuestions()
    }
    
    private func observeEvent() {
        viewModel.eventHandler = {[weak self] in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.startQuizButton.isEnabled = true
                
                strongSelf.vc = QuizViewController(viewModel: strongSelf.viewModel)
                
                if let newVc = strongSelf.vc {
                    strongSelf.navigationController?.pushViewController(newVc, animated: true)
                }
            }
        }
    }
    
    @objc func didTapStartButton() {
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            startQuizButton.isEnabled = false
            initViewModel()
            observeEvent()
        }
    }
}
