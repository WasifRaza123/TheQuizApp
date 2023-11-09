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
    private let horizontalScrollView = UIScrollView()
    private let questionNumberStackView = UIStackView()
    private let viewModel: QuizViewModel
    private var questions = [Response]()
    
    private var isQuestionNumberStackViewSet = false
    private var score = [Int:Int]()
    private var submittedAnswers = [Int:String]()
    
    private var questionNumber = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateView()
            }
        }
    }

    private let questionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        
        label.layer.cornerRadius = 30
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        
        return label
    }()
    
    // MARK: - Initialisation
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setQuestions()
        addView()
        applyConstraints()
        updateView()
    }
    
    // MARK: Convenience
    
    private func setQuestions() {
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        self.questions = questions
    }
    
    private func addView() {
        answerStackView.setStackView(axis: .vertical, distribution: .fillEqually, spacing: 10)
        buttonStackView.setStackView(axis: .horizontal, distribution: .fillEqually, spacing: 20)
        questionNumberStackView.setStackView(axis: .horizontal, distribution: .fillEqually, spacing: 10)
        
        view.addSubview(buttonStackView)
        view.addSubview(scrollView)
        horizontalScrollView.addSubview(questionNumberStackView)
        scrollView.addSubview(questionLabel)
        scrollView.addSubview(answerStackView)
        scrollView.addSubview(horizontalScrollView)
        setQuestionNumberStackView()
        createBackAndNextButton()
    }
    
    
    private func updateView() {
        guard let (currentQuestion, currentAnswers) = getAnswers() else {
            return
        }
        let answerCount = currentAnswers.count
        self.questionLabel.text = currentQuestion
        
        for subView in answerStackView.arrangedSubviews {
            answerStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        for i in 0..<answerCount {
            let answerButton = createButton()
            answerButton.backgroundColor = .white
            answerButton.setTitleColor(.black, for: .normal)
            answerButton.setTitleColor(.white, for: .selected)
            answerButton.setTitle(currentAnswers[i], for: .normal)
            answerButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
            answerButton.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
            answerButton.layer.borderWidth = 1
            answerButton.layer.borderColor = UIColor.gray.cgColor
            if submittedAnswers[questionNumber] != nil && currentAnswers[i] == submittedAnswers[questionNumber] {
                answerButton.isSelected = true
                answerButton.backgroundColor = .blue
            }
            answerStackView.addArrangedSubview(answerButton)
        }
            updateQuestionNumberStackView()
    }
    
    private func setQuestionNumberStackView() {
        for i in 0..<questions.count {
            let questionNumberButton = createButton()
            questionNumberButton.backgroundColor = UIColor.skyBlue
            questionNumberButton.setTitleColor(.black, for: .normal)
            questionNumberButton.setTitleColor(.white, for: .selected)
            questionNumberButton.setTitle("\(i+1)", for: .normal)
            
            questionNumberButton.layer.borderWidth = 1
            questionNumberButton.layer.borderColor = UIColor.gray.cgColor
            questionNumberButton.layer.cornerRadius = 20
            
            questionNumberButton.addTarget(self, action: #selector(didTapQuestionNumberButton), for: .touchUpInside)
            questionNumberStackView.addArrangedSubview(questionNumberButton)
            
            questionNumberButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            questionNumberButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            if i == questionNumber {
                questionNumberButton.isSelected = true
                questionNumberButton.backgroundColor = UIColor.oliveGreen
            }
            
        }
        isQuestionNumberStackViewSet = true
    }
    
    private func updateQuestionNumberStackView() {
        for (index, subview) in questionNumberStackView.arrangedSubviews.enumerated() {
            if let button = subview as? UIButton {
                button.isSelected = false
                button.backgroundColor = UIColor.skyBlue
                
                if submittedAnswers[index] != nil {
                    button.isSelected = true
                    button.backgroundColor = UIColor.oliveGreen
                }

                if index == questionNumber {
                    
                    button.isSelected = true
                    button.backgroundColor = UIColor.oliveGreen
                    let buttonFrame = button.superview?.convert(button.frame, from: horizontalScrollView)
                    horizontalScrollView.scrollRectToVisible(buttonFrame ?? .zero, animated: true)
                }
                
            }
        }
    }
    
    
    private func createBackAndNextButton() {
        let backButton = createButton()
        backButton.setTitle(Constants.backButtonTitle, for: .normal)
        backButton.backgroundColor = .link
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(backButton)
        
        let nextButton = createButton()
        nextButton.setTitle(Constants.nextButtonTitle, for: .normal)
        nextButton.backgroundColor = .link
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(nextButton)
    }
    
    private func createAlert() {
        let alert = UIAlertController(title: Constants.alertTitle , message: Constants.alertMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.cancelActionTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: Constants.submitActionTitle, style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            let vc = UINavigationController(rootViewController: SubmitViewController(score: strongSelf.score, submittedAnswers: strongSelf.submittedAnswers))
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
            
        }))
        present(alert, animated: true)
        
    }
    
    // MARK: - Actions
    
    @objc func didTapAnswerButton(sender: UIButton) {
        guard sender.isSelected == false else {
            sender.isSelected = false
            sender.backgroundColor = .white
            score[questionNumber] = nil
            submittedAnswers[questionNumber] = nil
            return
        }
        
        
        for view in sender.superview?.subviews ?? [] {
            if let button = view as? UIButton {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
        
        sender.isSelected = true
        sender.backgroundColor = .blue
        
        if let answer = sender.titleLabel?.text {
            if questions[questionNumber].correct_answer == answer {
                score[questionNumber] = 1;
            }
            else {
                score[questionNumber] = 0;
            }
            submittedAnswers[questionNumber] = answer
        }
    }

    @objc func didTapBackButton() {
        if questionNumber > 0 {
            questionNumber -= 1
        }
    }
    
    @objc func didTapNextButton() {
        if questionNumber < questions.count - 1 {
            questionNumber += 1
        }
        else {
            createAlert()
        }
    }
    
    @objc private func didTapQuestionNumberButton(sender: UIButton){
    
        guard let questionNumber = sender.titleLabel?.text, let questionValue = Int(questionNumber)  else {
            return
        }
        self.questionNumber = questionValue - 1
//        for view in sender.superview?.subviews ?? [] {
//            if let button = view as? UIButton {
//                button.isSelected = false
//                button.backgroundColor = UIColor.skyBlue
//            }
//        }
        sender.isSelected = true
        sender.backgroundColor = UIColor.oliveGreen
    }
    
    private func applyConstraints() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        questionNumberStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            
            horizontalScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            questionNumberStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            questionNumberStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            questionNumberStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor),
            questionNumberStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),
           
            questionLabel.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: 20),
            questionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            answerStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            answerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            answerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    
    private func getAnswers() -> (String, [String])? {
        guard let currentQuestion = questions[questionNumber].question.html2Attributed?.string else {
            print("No questions present")
            return nil
        }
        var currentAnswers = [String]()
        
        for item in questions[questionNumber].incorrect_answers {
            currentAnswers.append(item.html2Attributed?.string ?? "")
        }
        
        currentAnswers.append(questions[questionNumber].correct_answer.html2Attributed?.string ?? "")
        if score[questionNumber] == nil {
            currentAnswers.shuffle()
        }
        return (currentQuestion, currentAnswers)
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

