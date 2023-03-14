//
//  Extensions.swift
//  MyDalle
//
//  Created by Илья Дубенский on 11.03.2023.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
