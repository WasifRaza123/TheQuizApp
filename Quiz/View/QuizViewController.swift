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
    private let scrollView = UIScrollView()
    
    private var viewModel = QuizViewModel()
    private var score = [Int:Int]()
    private var visitedAnswers = [Int:String]()
    
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
        createBackAndNextButton()
    }
    
    // MARK: Convenience
    
    private func addView() {
        answerStackView.axis = .vertical
        answerStackView.distribution = .fillEqually
        answerStackView.spacing = 20
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(questionNumberLabel)
        scrollView.addSubview(questionLabel)
        scrollView.addSubview(answerStackView)
    }
    
    private func updateView() {
        questionNumberLabel.text = "\(questionNumber+1)"
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        
        let questionText = questions[questionNumber].question.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#039;", with: "\'")
        self.questionLabel.text = questionText
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
            answerButton.setTitleColor(.white, for: .selected)
            answerButton.setTitle(answers[i], for: .normal)
            answerButton.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
            answerButton.layer.borderWidth = 2
            answerButton.layer.borderColor = UIColor.black.cgColor
            if visitedAnswers[questionNumber] != nil && answers[i] == visitedAnswers[questionNumber] {
                answerButton.isSelected = true
                answerButton.backgroundColor = .init(red: 0.5, green: 0.5, blue: 0, alpha: 1)
            }
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
    
    private func createBackAndNextButton() {
        let backButton = createButton()
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = .link
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(backButton)
        
        let nextButton = createButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .link
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(nextButton)
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
    
    @objc func didTapAnswerButton(sender: UIButton) {
        
        
        guard sender.isSelected == false else {
            sender.isSelected = false
            sender.backgroundColor = .yellow
            score[questionNumber] = nil
            visitedAnswers[questionNumber] = nil
            return
        }
        
        
        for view in sender.superview?.subviews ?? [] {
            if let button = view as? UIButton {
                button.isSelected = false
                button.backgroundColor = .yellow
            }
        }
        
        sender.isSelected = true
        sender.backgroundColor = .init(red: 0.5, green: 0.5, blue: 0, alpha: 1)
        
        
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        
        
        if let answer = sender.titleLabel?.text {
            if questions[questionNumber].correct_answer == answer {
                score[questionNumber] = 1;
            }
            else {
                score[questionNumber] = 0;
            }
            visitedAnswers[questionNumber] = answer
        }
        
        if questionNumber < questions.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.questionNumber += 1
            }
            
            
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
    
    @objc func didTapNextButton() {
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            
            questionNumberLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            questionNumberLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            questionNumberLabel.heightAnchor.constraint(equalToConstant: 60),
            questionNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            
            
            questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            questionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 20),
            questionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            answerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            answerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            answerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            answerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            answerStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            answerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    
    private func returnAnswers(questions: resultData ) -> [String] {
        var answers = [String]()
        
        for item in questions[questionNumber].incorrect_answers {
            answers.append(item.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#039;", with: "\'"))
        }
        
        answers.append(questions[questionNumber].correct_answer.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#039;", with: "\'"))
        if score[questionNumber] == nil {
            answers.shuffle()
        }
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

