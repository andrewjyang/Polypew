//
//  QuestionAnswer.swift
//  polypew
//  File generates some sort of random math question using basic operators (+,-,*,/)
//
//  Created by Andrew Zenoni on 12/6/18.
//  Copyright © 2018 Andrew Yang. All rights reserved.
//

import Foundation

// Struct of a QuestionAnswer the user is supposed to answer
struct QuestionAnswer {
    var question: String = ""
    var answer: String = ""
    var options: [String] = [String]()
    
    // initialize a quetion answer
    init() {
        let questionAnswerDict = generateQuestionAnswer()
        self.question = questionAnswerDict.keys.first!
        self.answer = questionAnswerDict[question]!
        self.options = generateOptions(answer: questionAnswerDict[question]!)
    }
    
    /**
     Generate the options array with random values then shuffle so answer placement is random
     
     - Parameter answer: The answer to the question
     - Returns: A dictionary consisting of the different options the user will have
    */
    func generateOptions(answer: String) -> [String] {
        var options = [String]()
        for _ in 0..<3 {
            options.append("\(Int.random(in: 0...100))")
        }
        options.append(answer)
        return options.shuffled()
    }
    
    /**
     Generate a random QuestionAnswer of either type addition, multiplication, subtraction, or division
     
     - Returns: A dictionary consisting of question key and answer value
    */
    func generateQuestionAnswer() -> [String: String] {
        let options = Int.random(in: 0...4)
        switch options {
        case 0:
            return multiplicationQuestion()
        case 1:
            return additionQuestion()
        case 2:
            return subtractionQuestion()
        case 3:
            return divisionQuestion()
        default:
            return ["Nothing": "Nothing"]
        }
    }
    
    /**
     Generate a random multiplication question
     
     - Returns: A dictionary with a question key and answer value
    */
    func multiplicationQuestion() -> [String: String] {
        var rand1 = Int.random(in: 0...10)
        var rand2 = Int.random(in: 0...10)
        let options = Int.random(in: 0...2)
        var question = ""
        var answer = ""
        switch options {
        case 0:
            answer = "\(rand1 * rand2)"
            question = "\(rand1) x \(rand2) = ?"
        case 1:
            while rand2 % rand1 != 0 {
                rand2 = Int.random(in: 0...10)
                rand1 = Int.random(in: 0...10)
            }
            question = "\(rand1) * ? = \(rand2)"
            answer = "\(rand2 / rand1)"
        case 2:
            while rand1 % rand2 != 0 {
                rand2 = Int.random(in: 0...10)
                rand1 = Int.random(in: 0...10)
            }
            question = "? * \(rand2) = \(rand1)"
            answer = "\(rand1 / rand2)"
        default:
            question = "1 * 1 = ?"
            answer = "1"
        }
        
        return [question: answer]
    }
    
    /**
     Generate a random addition question
     
     - Returns: A dictionary with a question key and answer value
     */
    func additionQuestion() -> [String: String] {
        let rand1 = Int.random(in: 0...100)
        let rand2 = Int.random(in: 0...100)
        let options = Int.random(in: 0...2)
        var question = ""
        var answer = ""
        switch options {
        case 0:
            answer = "\(rand1 + rand2)"
            question = "\(rand1) + \(rand2) = ?"
        case 1:
            question = "\(rand1) + ? = \(rand2)"
            answer = "\(rand2 - rand1)"
        case 2:
            question = "? + \(rand2) = \(rand1)"
            answer = "\(rand1 - rand2)"
        default:
            question = "1 + 1 = ?"
            answer = "2"
        }
        
        return [question: answer]
    }
    
    /**
     Generate a random subtraction question
     
     - Returns: A dictionary with a question key and answer value
     */
    func subtractionQuestion() -> [String: String] {
        var rand1 = Int.random(in: 0...100)
        var rand2 = Int.random(in: 0...100)
        let options = Int.random(in: 0...2)
        var question = ""
        var answer = ""
        switch options {
        case 0:
            while rand1 < rand2 {
                rand1 = Int.random(in: 0...100)
                rand2 = Int.random(in: 0...100)
            }
            answer = "\(rand1 - rand2)"
            question = "\(rand1) - \(rand2) = ?"
        case 1:
            while rand2 < rand1 {
                rand1 = Int.random(in: 0...100)
                rand2 = Int.random(in: 0...100)
            }
            question = "\(rand1) - ? = \(rand2)"
            answer = "\(rand1 - rand2)"
        case 2:
            while rand1 < rand2 {
                rand1 = Int.random(in: 0...100)
                rand2 = Int.random(in: 0...100)
            }
            question = "? - \(rand2) = \(rand1)"
            answer = "\(rand1 + rand2)"
        default:
            question = "1 - 1 = ?"
            answer = "0"
        }
        
        return [question: answer]
    }
    
    /**
     Generate a random division question
     
     - Returns: A dictionary with a question key and answer value
     */
    func divisionQuestion() -> [String: String] {
        var rand1 = Int.random(in: 0...10)
        var rand2 = Int.random(in: 0...10)
        let options = Int.random(in: 0...2)
        var question = ""
        var answer = ""
        switch options {
        case 0:
            answer = "\(rand1 * rand2)"
            question = "? / \(rand1) = \(rand2)"
        case 1:
            while rand2 % rand1 != 0 {
                rand2 = Int.random(in: 0...10)
                rand1 = Int.random(in: 0...10)
            }
            question = "\(rand1) / \(rand2) = ?"
            answer = "\(rand1 / rand2)"
        case 2:
            while rand1 % rand2 != 0 {
                rand2 = Int.random(in: 0...10)
                rand1 = Int.random(in: 0...10)
            }
            question = "\(rand1) / ? = \(rand2)"
            answer = "\(rand1 / rand2)"
        default:
            question = "1 / 1 = ?"
            answer = "1"
        }
        
        return [question: answer]
    }
    
    
}
