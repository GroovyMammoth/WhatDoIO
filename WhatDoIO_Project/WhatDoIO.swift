//
//  WhatDoIO.swift
//  WhatDoIO_Project
//
//  Created by Ben Scheer and Fidel R. on 8/3/18.
//  Copyright © 2018 Ben Scheer. All rights reserved.
//

import Foundation

//algorithm for figuring out what people owe
class WhatDoIO {
    var member_cost_dictionary = [String: Double]()
    var members = [String]()
    var pay_matrix = [String : [String : Double]]()
    var partition = [String: Double]()
    //var pay_matrix: Matrix<Any>
    var compiled = false
    
    init(member_cost_dictionary: [String: Double], partition : [String: Double]) {
        self.member_cost_dictionary = member_cost_dictionary
        self.members = Array(member_cost_dictionary.keys)
        self.pay_matrix = [String : [String : Double]]()
        self.partition = partition
        self.compiled = false
    }
    
    func split_evenly(){
        var total = 0.00
        for cost in member_cost_dictionary.values{
           total += cost
        }
        let owes_per_person = total/Double(member_cost_dictionary.count)
        for member in members{
            partition[member] = owes_per_person
        }
    }
    
    func compile(){
        for member in members{
            member_cost_dictionary[member]! = member_cost_dictionary[member]! - partition[member]!
            member_cost_dictionary[member]! = member_cost_dictionary[member]!*(-1)
        }
        var pool = 0.00
        for member in members{
            pool -= min(0, member_cost_dictionary[member]!)
        }
        for memberInDebt in members{
            if member_cost_dictionary[memberInDebt]! > 0.00 {
                pay_matrix[memberInDebt] = [:]
                for member in members {
                    if member != memberInDebt {
                        pay_matrix[memberInDebt]![member] = max(0, -member_cost_dictionary[memberInDebt]!*member_cost_dictionary[member]!/pool)
                    }
                }
            } else {
                pay_matrix[memberInDebt] = [:]
            }
        }
        compiled = true
    }
    
    func show(individual: String)->[String : Double]{
        if !compiled {
            compile()
        }
        return pay_matrix[individual]!
        //may need return on definition
    }
    
    func show_all() -> [String : [String : Double]]{
        if !compiled {
            compile()
        }
        return pay_matrix
    }
    
    func round(pay_matrix: [String : [String : Double]]) -> [String : [String : Double]]{
        //do rounding here
        return pay_matrix
    }
    
    func translate() -> String{
        if !compiled {
            compile()
        }
        var output = ""
        for memberInDebt in members {
            if pay_matrix[memberInDebt]?.count != 0{
                for member in pay_matrix[memberInDebt]!.keys {
                    let numberFromMatrix: Double = pay_matrix[memberInDebt]![member]!
                    let number: Double = Darwin.round(100.0 * numberFromMatrix)/100.0
                    if number != 0.00 {
                        let amount = String(format: "$%.02f", number)
                        output = "\(output) \(memberInDebt) should pay \(member) \(amount)."
                    }
                }
            }
        }
        return output
    }
    
}

