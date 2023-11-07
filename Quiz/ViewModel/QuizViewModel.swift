//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import Foundation

class QuizViewModel{
    var eventHandler: (() -> Void)?
    var questions: [Response]? {
        didSet{
            eventHandler?()
        }
    }
//    var questions = [Response]()
    func fetchQuestions() {
        APICaller.shared.fetchDataFromURL(urlString: "https://opentdb.com/api.php?amount=10&amp;category=18&amp;difficulty=easy&amp;type=multiple{", completion: {[weak self] result in
            switch result {
            case .success(let data):
                self?.questions = data.results
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
}
