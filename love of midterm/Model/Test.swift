//
//  Test.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/18.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation


struct Test {
    let num:Int
    let title:String
    let questionOne:String
    let questionTwo:String
    let questionThree:String
    let questionFour:String
    let answer:Int
    
    init(num:Int, title:String, questionOne:String, questionTwo:String, questionThree:String,
         questionFour:String, answer:Int) {
        self.num = num
        self.title = title
        self.questionOne = questionOne
        self.questionTwo = questionTwo
        self.questionThree = questionThree
        self.questionFour = questionFour
        self.answer = answer
    }
    
    init(data:[String:Any]){
        let num = data["num"] as? Int ?? 0
        let title = data["title"] as? String ?? ""
        let questionOne = data["questionOne"] as? String ?? ""
        let questionTwo = data["questionTwo"] as? String ?? ""
        let questionThree = data["questionThree"] as? String ?? ""
        let questionFour = data["questionFour"] as? String ?? ""
        let answer = data["answer"] as? Int ?? 0
        
        
        self.num = num
        self.title = title
        self.questionOne = questionOne
        self.questionTwo = questionTwo
        self.questionThree = questionThree
        self.questionFour = questionFour
        self.answer = answer
        
    }
}
