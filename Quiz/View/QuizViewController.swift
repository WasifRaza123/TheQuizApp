//
//  ViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class QuizViewController: UIViewController {
    private let answerStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private var viewModel = QuizViewModel()
    
    private var questionNumber = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateView()
            }
        }
    }
    
    private let questionNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .init(red: 0.5, green: 0.5, blue: 0, alpha: 1)
        label.layer.cornerRadius = 30
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.layer.cornerRadius = 30
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        addView()
        applyConstraints()
        initViewModel()
        observeEvent()
        createBackAndSkipButton()
    }
    
    // MARK: Convenience
    
    private func addView() {
        view.addSubview(questionLabel)
        view.addSubview(questionNumberLabel)
        answerStackView.axis = .vertical
        answerStackView.distribution = .fillEqually
        answerStackView.spacing = 20
        view.addSubview(answerStackView)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
    }
    
    private func updateView() {
        questionNumberLabel.text = "\(questionNumber+1)"
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        self.questionLabel.text = questions[questionNumber].question
        let answerCount = questions[questionNumber].incorrect_answers.count + 1
        let answers = returnAnswers(questions: questions)
        
        for subView in answerStackView.arrangedSubviews {
            answerStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        for i in 0..<answerCount {
            let answerButton = createButton()
            answerButton.backgroundColor = .yellow
            answerButton.setTitleColor(.black, for: .normal)
            answerButton.setTitle(answers[i], for: .normal)
            answerButton.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
            answerButton.layer.borderWidth = 2
            answerButton.layer.borderColor = UIColor.black.cgColor
            answerStackView.addArrangedSubview(answerButton)
        }
    }
    
    private func initViewModel() {
        viewModel.fetchQuestions()
    }
    
    private func observeEvent() {
        viewModel.eventHandler = {[weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }
    }
    
    private func createBackAndSkipButton() {
        let backButton = createButton()
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = .link
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(backButton)
        
        let skipButton = createButton()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .link
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(skipButton)
    }
    
    private func createAlert() {
        let alert = UIAlertController(title: "Submit Test", message: "Are you sure you want to submit the test ?", preferredStyle: .actionSheet)
        
        alert.view.tintColor = .red

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            let vc = UINavigationController(rootViewController: SubmitViewController())
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
            
        }))
        present(alert, animated: true)
        
    }
    
    // MARK: - Actions
    
    @objc func didTapAnswerButton() {
        
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        
        if questionNumber < questions.count - 1 {
            questionNumber += 1
        }
        else {
            createAlert()
        }
    }
    
    @objc func didTapBackButton() {
        if questionNumber > 0 {
            questionNumber -= 1
        }
    }
    
    @objc func didTapSkipButton() {
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        
        if questionNumber < questions.count - 1 {
            questionNumber += 1
        }
        else {
            createAlert()
        }
    }
    
    private func applyConstraints() {
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionNumberLabel.heightAnchor.constraint(equalToConstant: 60),
            questionNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            questionNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            questionLabel.heightAnchor.constraint(equalToConstant: 200),
            questionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 10),
            
            answerStackView.heightAnchor.constraint(equalToConstant: 300),
            answerStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            answerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: - Helper Functions
    
    private func returnAnswers(questions: resultData ) -> [String] {
        var answers = [String]()
        
        for item in questions[questionNumber].incorrect_answers {
            answers.append(item)
        }
        
        answers.append(questions[questionNumber].correct_answer)
        answers.shuffle()
        return answers
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.titleLabel?.textAlignment = .center
        return button
    }
    
}

