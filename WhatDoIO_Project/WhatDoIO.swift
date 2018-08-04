//
//  WhatDoIO.swift
//  WhatDoIO_Project
//
//  Created by Ben Scheer on 8/3/18.
//  Copyright © 2018 Benjamin Scheer. All rights reserved.
//

import Foundation

class WhatDoIO {
    var member_cost_dictionary = [String: Double]()
    var members = [String]()
    var pay_matrix = [String : [String : Double]]()
    //var pay_matrix: Matrix<Any>
    var sorted = false
    var compiled = false
    
    init(member_cost_dictionary: [String: Double]) {
        self.member_cost_dictionary = member_cost_dictionary
        self.members = Array(member_cost_dictionary.keys)
        self.pay_matrix = [String : [String : Double]]()
        self.sorted = false
        self.compiled = false
    }
    
    func split_evenly(){
        var total: Double = 0.00
        for cost in member_cost_dictionary.values{
            total += cost
        }
        let size = member_cost_dictionary.count
        let owes_per_person: Double = total/Double(size)
        for member in members{
            member_cost_dictionary[member]! -= owes_per_person
            member_cost_dictionary[member]! *= (-1)
        }
        sorted = true
    }
    
    func compile(){
        if !sorted{
            split_evenly()
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
    
}

