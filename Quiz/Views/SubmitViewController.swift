//
//  SubmitViewController.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import UIKit

class SubmitViewController: UIViewController {
    private var score:[Int:Int]
    private var questionCount: Int
    private var testResultStackView = UIStackView()
    
    private var goToHomePageButton: UIButton = {
        let button = UIButton()
        button.setButton(withTitle: Constants.goToHomePageButtonTitle, bgColor: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Initialisation
    
    init(score: [Int : Int], questionCount: Int ) {
        self.score = score
        self.questionCount = questionCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.testResultTitle
        view.backgroundColor = .systemGray6
        setUpViews()
        applyConstraints()
    }
    
    func setUpViews(){
        let scoreResultView = createLabelView()
        scoreResultView.setLeadingLabel(withTitle: Constants.scoreTitle)
        let (finalScore, wrongAnswerCount, notVisitedQuestionCount) = getResults()
        scoreResultView.setTrailingLabel(withTitle: "\(finalScore)")
        scoreResultView.isAccessibilityElement = true
        scoreResultView.accessibilityLabel = "\(Constants.scoreTitle) is \(finalScore)"
        
        let wrongAnswerResultView = createLabelView()
        wrongAnswerResultView.setLeadingLabel(withTitle: Constants.wrongAnswerTitle)
        wrongAnswerResultView.setTrailingLabel(withTitle: "\(wrongAnswerCount)")
        wrongAnswerResultView.isAccessibilityElement = true
        wrongAnswerResultView.accessibilityLabel = "\(Constants.wrongAnswerTitle) Question count is \(wrongAnswerCount)"
        
        let notAttemptedResultView = createLabelView()
        notAttemptedResultView.setLeadingLabel(withTitle: Constants.notAttemptedTitle)
        notAttemptedResultView.setTrailingLabel(withTitle: "\(notVisitedQuestionCount)")
        notAttemptedResultView.isAccessibilityElement = true
        notAttemptedResultView.accessibilityLabel = "\(Constants.notAttemptedTitle) Question count is \(notVisitedQuestionCount)"
        
        scoreResultView.translatesAutoresizingMaskIntoConstraints = false
        wrongAnswerResultView.translatesAutoresizingMaskIntoConstraints = false
        notAttemptedResultView.translatesAutoresizingMaskIntoConstraints = false
        
        testResultStackView.axis = .vertical
        testResultStackView.spacing = 10
        testResultStackView.addArrangedSubview(scoreResultView)
        testResultStackView.addArrangedSubview(wrongAnswerResultView)
        testResultStackView.addArrangedSubview(notAttemptedResultView)
        
        view.addSubview(testResultStackView)
        setUpGoToHomePageButton()
    }
    
    func setUpGoToHomePageButton(){
        goToHomePageButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        goToHomePageButton.accessibilityHint = Constants.goToHomePageButtonAccessibilityHint
        view.addSubview(goToHomePageButton)
    }
    
    // Create view for adding results label.
    func createLabelView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return view
    }
    
    func getResults() -> (Int, Int, Int) {
        var resultScore = 0
        var wrongAnswers = 0
        for item in score {
            resultScore += item.value
            if item.value == 0 {
                wrongAnswers += 1
            }
        }
        let unattemptedQuestion = questionCount - score.count
        return (resultScore, wrongAnswers, unattemptedQuestion)
    }
    
    @objc func didTapStartButton() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func applyConstraints() {
        goToHomePageButton.translatesAutoresizingMaskIntoConstraints = false
        testResultStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goToHomePageButton.heightAnchor.constraint(equalToConstant: 70),
            goToHomePageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            goToHomePageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            goToHomePageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            testResultStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            testResultStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            testResultStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
}
