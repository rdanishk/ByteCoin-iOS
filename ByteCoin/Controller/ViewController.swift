//
//  ViewController.swift
//  ByteCoin
//
//  Created by Danish Khalid on 11/09/2019.
//  Copyright © 2019 Danish Khalid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var coinManager = CoinManager()

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinManager.getCoinPrice(for: "USD")
        currencyPicker.selectRow(19, inComponent: 0, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
        currencyLabel.text = coinManager.currencyArray[row]
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func updateCoinPrice(price: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", price)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

