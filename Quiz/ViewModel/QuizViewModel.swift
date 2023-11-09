//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import Foundation

class QuizViewModel{
    var eventHandler: (() -> Void)?
    private(set) var questions: [Response]? {
        didSet{
            eventHandler?()
        }
    }
//    var questions = [Response]()
    func fetchQuestions() {
        APICaller.shared.fetchDataFromURL(urlString: Constants.urlString, completion: {[weak self] result in
            switch result {
            case .success(let data):
                self?.questions = data.results
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
}
