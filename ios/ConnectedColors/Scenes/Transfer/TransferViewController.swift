//
//  TransferViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import Eureka

enum Currency: String {
    case CAD
    case US
}

class TransferViewController: FormViewController {
    
    var user: User?
    
    var service = UserWorker(http: HTTPService())
    
    var myAccounts: [MaskedRelatedBankAccount] = []
    var currentSelectedAccount: MaskedRelatedBankAccount?
    
    var toAccounts: [MaskedRelatedBankAccount] = []
    var currentReceiverAccount: MaskedRelatedBankAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user,
            let dic = user.maskedRelatedBankAccounts,
            let tos = dic["individual"] {
            toAccounts = tos
            currentReceiverAccount = tos.first
        }
        
        
        let givenName = user?.giveName
        let surName = user?.surname
        if let accountsData = UserDefaults.standard.data(forKey: "BankAccounts"),
            let accounts = try? JSONDecoder().decode([MaskedRelatedBankAccount].self, from: accountsData) {
            myAccounts = accounts
            currentSelectedAccount = accounts.first
        }
        form +++ Section("Section1")
            <<< LabelRow("givenName"){ row in
                row.title = givenName
            }
            <<< LabelRow("surName"){ row in
                row.title = surName
            }
            <<< TextRow("amount"){
                $0.title = "Amount"
                $0.placeholder = "And numbers here"
            }
            <<< ActionSheetRow<String>("account") {
                $0.title = "Account select"
                $0.selectorTitle = "Pick an account"
                $0.options = myAccounts.map { $0.maskedAccountNumber ?? "" }
                $0.value = myAccounts.first?.maskedAccountNumber ?? ""
                }.onChange({ (row) in
                    for account in self.myAccounts {
                        if let value = row.value, value == account.maskedAccountNumber {
                            self.currentReceiverAccount = account
                        }
                    }
                })
            +++ Section("Details")
            <<< TextAreaRow("receipt"){
                $0.title = "Receipt"
            }
            <<< ActionSheetRow<String>("toAccount") {
                $0.title = "Receiver account select"
                $0.selectorTitle = "Pick an account to receive money"
                $0.options = toAccounts.map { $0.maskedAccountNumber ?? "" }
                $0.value = toAccounts.first?.maskedAccountNumber ?? ""
                }.onChange({ (row) in
                    for account in self.toAccounts {
                        if let value = row.value, value == account.maskedAccountNumber {
                            self.currentSelectedAccount = account
                        }
                    }
                })
            <<< ActionSheetRow<String>("currency") {
                $0.title = "Current select"
                $0.selectorTitle = "Pick a currency"
                $0.options = [Currency.CAD.rawValue, Currency.US.rawValue]
                $0.value = Currency.CAD.rawValue
            }
            +++ Section("Submit")
            <<< ButtonRow("submit") {
                $0.title = "Submit"
                $0.onCellSelection(self.buttonTapped)
            }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        let amountRow: TextRow? = form.rowBy(tag: "amount")
        let amount = Int(amountRow?.value ?? "") ?? 0
        
        let receiptRow: TextAreaRow? = form.rowBy(tag: "receipt")
        let receipt = receiptRow?.value ?? ""
        
        let currencyRow: ActionSheetRow? = form.rowBy(tag: "currency") as? ActionSheetRow<String>
        let currency = currencyRow?.value ?? Currency.CAD.rawValue
        
        service.transfer(amount: amount, currency: currency, receipt: receipt, fromAccountID: (currentSelectedAccount?.accountId)! , toAccountID: currentReceiverAccount?.accountId ?? "") { (result) in
            switch result {
            case .Success(let transfer):
                let alert = UIAlertController(title: "Success", message: "money on the way", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            case .Failure(let error):
                let alert = UIAlertController(title: "Something goes wrong: \(error.localizedDescription)", message: "please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
    }
}
