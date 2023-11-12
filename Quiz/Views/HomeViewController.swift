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
    private var circularProgressBarView: CircularProgressBarView!
    private var circularViewDuration: TimeInterval = 1.5
    
    private var startQuizButton: UIButton = {
        let button = UIButton()
        button.setButton(withTitle: Constants.startQuizButtonTitle, bgColor: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var resumeQuizButton: UIButton = {
        let button = UIButton()
        button.setButton(withTitle: Constants.resumeQuizButtonTitle , bgColor: .black)
        button.isHidden = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setUpViews()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startQuizButton.layer.cornerRadius = startQuizButton.frame.width/2
    }
    
    private func setUpViews(){
        resumeQuizButton.addTarget(self, action: #selector(didTapResumeQuizButton), for: .touchUpInside)
        resumeQuizButton.accessibilityHint = Constants.resumePrevQuizButtonAccessibilityHint
        
        startQuizButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startQuizButton.accessibilityHint = Constants.startNewQuizButtonAccessibilityHint
        view.addSubview(startQuizButton)
        view.addSubview(resumeQuizButton)
        setUpCircularProgressBarView()
    }
    
    private func setUpCircularProgressBarView() {
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.center = view.center
        view.addSubview(circularProgressBarView)
    }
    
    // MARK: - Action
    
    @objc private func didTapStartButton() {
        // call the animation with circularViewDuration
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        startQuizButton.isEnabled = false
        initViewModel()
        observeEvent()
    }
    
    @objc private func didTapResumeQuizButton() {
        if let vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - DATA BINDING
    
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.resumeQuizButton.isHidden = false
            }
        }
    }
    
    private func applyConstraints() {
        startQuizButton.translatesAutoresizingMaskIntoConstraints = false
        resumeQuizButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startQuizButton.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            startQuizButton.widthAnchor.constraint(equalTo: startQuizButton.heightAnchor),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startQuizButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resumeQuizButton.heightAnchor.constraint(equalToConstant: 70),
            resumeQuizButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            resumeQuizButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            resumeQuizButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}
