//
//  CurrencyField.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/21/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit

class CurrencyField: UITextField {
    var string: String { return text ?? "" }
    var amount: Double { return Double(string.digits.integer)
        .divided(by: pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var code: String { return Formatter.currency.currencyCode }
    var symbol: String { return Formatter.currency.currencySymbol }
    var internationalSymbol: String { return Formatter.currency.internationalCurrencySymbol }
    private var lastValue: String = ""
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    func editingChanged() {
        guard amount <= 2147483647 else {
            text = lastValue
            return
        }
        text = Formatter.currency.string(for: amount)
        lastValue = text!
    }
}

private extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}

private extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}

private extension String {
    var digits: [Int] { return characters.flatMap{ Int(String($0)) } }
}

private extension BidirectionalCollection where Iterator.Element == Int {
    var string: String { return map(String.init).joined() }
    var integer: Int { return Int(string) ?? 0 }
}
