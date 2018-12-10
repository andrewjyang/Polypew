//
//  QuestionViewController.swift
//  polypew
//
//  Created by Andrew Zenoni on 12/9/18.
//  Copyright © 2018 Andrew Yang. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    let questionAnswer: QuestionAnswer? = nil
    
    var correctGuess: Bool = false

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionALabel: UILabel!
    @IBOutlet weak var optionBLabel: UILabel!
    @IBOutlet weak var optionCLabel: UILabel!
    @IBOutlet weak var optionDLabel: UILabel!
    @IBOutlet weak var optionAButton: UIButton!
    @IBOutlet weak var optionBButton: UIButton!
    @IBOutlet weak var optionDButton: UIButton!
    @IBOutlet weak var optionCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let questionAnswer = questionAnswer {
            questionLabel.text = "Question: \(questionAnswer.question)"
            let optionA = questionAnswer.options[0]
            let optionB = questionAnswer.options[1]
            let optionC = questionAnswer.options[2]
            let optionD = questionAnswer.options[3]
            
            optionALabel.text = "A: \(optionA)?"
            optionALabel.text = "B: \(optionB)?"
            optionALabel.text = "C: \(optionC)?"
            optionALabel.text = "D: \(optionD)?"
            
            optionAButton.setTitle("\(optionA)", for: .normal)
            optionBButton.setTitle("\(optionB)", for: .normal)
            optionCButton.setTitle("\(optionC)", for: .normal)
            optionDButton.setTitle("\(optionD)", for: .normal)
            
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func answerButtonPressed(_ sender: Any) {
        if let buttonPressed = sender as? UIButton {
            if let buttonTitle = buttonPressed.currentTitle {
                if buttonTitle == questionAnswer?.answer {
                    print("Question guessed correctly")
                    correctGuess = true
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: QuestionViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
