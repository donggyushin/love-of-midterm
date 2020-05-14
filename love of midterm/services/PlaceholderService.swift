//
//  PlaceholderService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/05/11.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation

struct PlaceholderService {
    
    static let shared = PlaceholderService()
    
    var placeholders:[Placeholder]
    
    
    init() {
        
        let placeHolderOne = Placeholder(title: "다음중 내가 가장 좋아하는 동물은?", questionOne: "강아지", questionTwo: "고양이", questionThree: "거북이", questionFour: "토끼")
        
        let placeHolderTwo = Placeholder(title: "다음중 내가 가장 좋아하는 곳은?", questionOne: "산", questionTwo: "바다", questionThree: "계곡", questionFour: "남극")
        
        let placeHolderThree = Placeholder(title: "다음중 나와 닮은 연예인은?", questionOne: "정해인", questionTwo: "한가인", questionThree: "아이유", questionFour: "김수현")
        
        let placeHolderFour = Placeholder(title: "다음중 내가 좋아하는 영화는?", questionOne: "반지의 제왕", questionTwo: "해리포터", questionThree: "포레스트 검프", questionFour: "캐스트 어웨이")
        
        let placeHolderFive = Placeholder(title: "다음중 내가 쉴때 하기 좋아하는 일은?", questionOne: "독서하기", questionTwo: "영화보기", questionThree: "산책하기", questionFour: "운동하기")
        
        let placeHolderSix = Placeholder(title: "다음중 내가 좋아하는 게임은?", questionOne: "카트라이더", questionTwo: "리니지", questionThree: "메이플스토리", questionFour: "포켓몬스터")
        
        let placeHolderSeven = Placeholder(title: "저는 무엇을 하는 사람일까요?", questionOne: "프로그래머", questionTwo: "화가", questionThree: "피아니스트", questionFour: "연예인")
        
        let placeHolderEight = Placeholder(title: "다음중 내가 가장 좋아하는 예능은?", questionOne: "무한도전", questionTwo: "1박2일", questionThree: "런닝맨", questionFour: "Wild vs Man")
        
        let placeHolderNine = Placeholder(title: "저의 연애 횟수는 얼마나 될까요?", questionOne: "1~3", questionTwo: "4~6", questionThree: "7~10", questionFour: "그 이상")
        
        let placeHolderTen = Placeholder(title: "저의 이상형은 어떻게 될까요?", questionOne: "착한사람", questionTwo: "성실한사람", questionThree: "외모가 출중한 사람", questionFour: "다")
        
        let placeHolderEleven = Placeholder(title: "내가 가장 좋아하는 색상은?", questionOne: "빨간색", questionTwo: "검정", questionThree: "파랑", questionFour: "초록")
        
        let placeHolderTwelve = Placeholder(title: "내가 가장 좋아하는 음악 장르는?", questionOne: "R&B", questionTwo: "발라드", questionThree: "힙합", questionFour: "POP")
        
        let placeHolderThirteen = Placeholder(title: "내가 할수있는 말!", questionOne: "영어", questionTwo: "네덜란드어", questionThree: "광동어", questionFour: "아랍어")
        
        let placeHolderFourteen = Placeholder(title: "내가 할수있는 언어!", questionOne: "javascript", questionTwo: "java", questionThree: "python", questionFour: "ruby")
        
        let placeHolderFifteen = Placeholder(title: "다음중 내가 가장 좋아하는 스포츠는?", questionOne: "스카이다이빙", questionTwo: "서핑", questionThree: "테니스", questionFour: "농구")
        
        let placeHolderSixteen = Placeholder(title: "다음중 내가 가장 좋아하는 애니메이션은?", questionOne: "바다가 들린다", questionTwo: "모노노케 히메", questionThree: "센과치히로의행방불명", questionFour: "귀멸의칼날")
        
        let placeHolderSeventeen = Placeholder(title: "다음중 내가 가장 좋아하는 드라마는?", questionOne: "제빵왕 김탁구", questionTwo: "주몽", questionThree: "해신", questionFour: "대조영")
        
        let placeHolderEighteen = Placeholder(title: "내가 가장 좋아하는 음식은?", questionOne: "소고기", questionTwo: "간장게장", questionThree: "황소개구리", questionFour: "돈까스")
        
        let placeHolderNineteen = Placeholder(title: "다음중 내가 좋아하는 취미는?", questionOne: "체스", questionTwo: "바둑", questionThree: "장기", questionFour: "코딩")
        
        let placeholderTwenty = Placeholder(title: "최근 내가 많이 듣는 노래는?", questionOne: "여우비", questionTwo: "거짓말", questionThree: "흔들리는꽃들속에서네샴푸향이느껴진거야", questionFour: "histeria")
        
        placeholders = [
            placeHolderOne,
            placeHolderTwo,
            placeHolderThree,
            placeHolderFour,
            placeHolderFive,
            placeHolderSix,
            placeHolderSeven,
            placeHolderEight,
            placeHolderNine,
            placeHolderTen,
            placeHolderEleven,
            placeHolderTwelve,
            placeHolderThirteen,
            placeHolderFourteen,
            placeHolderFifteen,
            placeHolderSixteen,
            placeHolderSeventeen,
            placeHolderEighteen,
            placeHolderNineteen,
            placeholderTwenty
        ]
    }
}
