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
    }
    
    // MARK: - Convenience
    
    private func setQuestions() {
        guard let questions = viewModel.questions else {
            print("No questions present")
            return
        }
        self.questions = questions
    }
    
    private func addView() {
        questionNumberStackView.setStackView(axis: .horizontal, distribution: .fillEqually, spacing: 10)
        answerStackView.setStackView(axis: .vertical, distribution: .fillEqually, spacing: 10)
        buttonStackView.setStackView(axis: .horizontal, distribution: .fillEqually, spacing: 20)
        
        view.addSubview(buttonStackView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(questionLabel)
        scrollView.addSubview(answerStackView)
        scrollView.addSubview(horizontalScrollView)
        
        horizontalScrollView.addSubview(questionNumberStackView)
        
        setQuestionNumberStackView()
        setAnswerStackView()
        createBackAndNextButton()
    }
    
    private func updateView() {
        emptyAnswerStackView()
        setAnswerStackView()
        updateQuestionNumberStackView()
    }
    
    private func setQuestionNumberStackView() {
        for i in 0..<questions.count {
            let questionNumberButton = UIButton()
            questionNumberButton.setStackViewButton(withTitle: String(i+1), bgColor: UIColor.skyBlue,  cornerRadius: 20)
            questionNumberButton.addTarget(self, action: #selector(didTapQuestionNumberButton), for: .touchUpInside)
            
            // Highlight current question number in the question number stack view.
            if i == questionNumber {
                questionNumberButton.isSelected = true
                questionNumberButton.backgroundColor = UIColor.black
            }
            questionNumberButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            questionNumberButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            questionNumberStackView.addArrangedSubview(questionNumberButton)
        }
    }
    
    private func setAnswerStackView(){
        guard let (currentQuestion, currentAnswers) = getAnswers() else {
            return
        }
        
        self.questionLabel.text = currentQuestion
        
        for answer in currentAnswers {
            let answerButton = UIButton()
            answerButton.setStackViewButton(withTitle: answer, bgColor: UIColor.white,  cornerRadius: 15)
            answerButton.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
            
            // If user has marked answer for current question, highlight the ,marked answer
            if submittedAnswers[questionNumber] != nil && answer == submittedAnswers[questionNumber] {
                answerButton.isSelected = true
                answerButton.backgroundColor = .blue
            }
            answerButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
            answerButton.titleLabel?.numberOfLines = 0
            answerStackView.addArrangedSubview(answerButton)
        }
    }
    
    private func createBackAndNextButton() {
        let backButton = UIButton()
        backButton.setButton(withTitle: Constants.backButtonTitle, bgColor: UIColor.black)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(backButton)
        
        let nextButton = UIButton()
        nextButton.setButton(withTitle: Constants.nextButtonTitle, bgColor: UIColor.black)
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
}

// MARK: -  Functions related with updating the stack views
extension QuizViewController {
    
    private func emptyAnswerStackView(){
        for subView in answerStackView.arrangedSubviews {
            answerStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
    
    private func updateQuestionNumberStackView() {
        for (index, subview) in questionNumberStackView.arrangedSubviews.enumerated() {
            if let button = subview as? UIButton {
                button.isSelected = false
                button.backgroundColor = UIColor.skyBlue
                
                if submittedAnswers[index] != nil {
                    button.isSelected = true
                    button.backgroundColor = UIColor.black
                }

                if index == questionNumber {
                    
                    button.isSelected = true
                    button.backgroundColor = UIColor.black
                    let buttonFrame = button.superview?.convert(button.frame, from: horizontalScrollView)
                    horizontalScrollView.scrollRectToVisible(buttonFrame ?? .zero, animated: true)
                }
                
            }
        }
    }
}

// MARK: - Actions

extension QuizViewController {
    
    @objc func didTapAnswerButton(sender: UIButton) {
        // When user taps again on the selected answer, it gets deselected
        guard sender.isSelected == false else {
            sender.isSelected = false
            sender.backgroundColor = .white
            score[questionNumber] = nil
            submittedAnswers[questionNumber] = nil
            return
        }
        
        // Deselect other button, when user clicks on more than one button
        for view in sender.superview?.subviews ?? [] {
            if let button = view as? UIButton {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
        
        // Select the current button clicked
        sender.isSelected = true
        sender.backgroundColor = .blue
        
        // Add score if selected answer is correct, and also mark submitted answers
        if let answer = sender.titleLabel?.text {
            if questions[questionNumber].correct_answer == answer {
                score[questionNumber] = 1;
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
        sender.isSelected = true
        sender.backgroundColor = UIColor.black
    }
}
