//
//  ViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class QuizViewController: UIViewController {
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a sample Question ?"
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.layer.cornerRadius = 30
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        return label
    }()
    
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray5
        addView()
        applyConstraints()
        
    }
    
    private func createAnswerButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .link
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.setTitle("This is a sample answer ", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }
    
    private func addView() {
        view.addSubview(questionLabel)
        let answerButtonA = createAnswerButton()
        let answerButtonB = createAnswerButton()
        let answerButtonC = createAnswerButton()
        let answerButtonD = createAnswerButton()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.addArrangedSubview(answerButtonA)
        stackView.addArrangedSubview(answerButtonB)
        stackView.addArrangedSubview(answerButtonC)
        stackView.addArrangedSubview(answerButtonD)
        view.addSubview(stackView)
    }
    
    private func applyConstraints() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: 200),
            questionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            stackView.heightAnchor.constraint(equalToConstant: 300),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 50),
        ])
    }
}

