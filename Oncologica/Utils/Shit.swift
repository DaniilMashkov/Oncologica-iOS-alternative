//
//  Shit.swift
//  Oncologica
//
//  Created by Daniil Mashkov on 09.01.2024.
//

import Foundation
import SwiftUI


func setColor(text: String) -> Color {
    if text == "Не пойду" {
        return Color(.red)
    }
    if ["Записан", "Мастер-класс"].contains(text) {
        return Color(.green)
    }
    if text == "Очно" {
        return Color(.cyan)
    }
    if text == "Встреча команды" {
        return Color(.purple)
    }
    if text == "Прямой эфир" {
        return Color(.orange)
    } else {
        return Color(.gray)
    }
}
