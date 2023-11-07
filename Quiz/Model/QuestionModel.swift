//
//  QuestionModel.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import Foundation

struct QuestionResponse: Codable {
    var response_code: Int
    var results: [Response]
}

typealias resultData = [Response]

struct Response: Codable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
}
