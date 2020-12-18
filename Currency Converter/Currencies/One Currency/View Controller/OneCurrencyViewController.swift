//
//  OneCurrencyViewController.swift
//  Currency Converter
//
//  Created by Ragy Bahgat on 12/18/20.
//

import UIKit

class OneCurrencyViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var otherCurrencyLabel: UILabel!
    private let pickerView = UIPickerView()
    let toolBar = UIToolbar()

    
    var baseCurrency = ""
    var otherCurrency = ""
    
    let allCurrenciesViewModel = AllCurrenciesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupRecievedAllCurrencies()
        
        allCurrenciesViewModel.fetchCurrencies(baseCurrency: baseCurrency)
    }
    
    private func setupViews() {
        setupBaseCurrencyLabel()
        setupPickerViewController()
        setupToolBar()
    }
    
    private func setupBaseCurrencyLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.baseCurrencyLabelPressed))
        baseCurrencyLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupBaseCurrencyLabelText() {
        baseCurrencyLabel.text = "1 \(baseCurrency)"
    }
    
    private func setupOtherCurrencyLabel(currency: Double) {
        otherCurrencyLabel.text = "\(currency) in \(otherCurrency)"
    }
    
    private func setupPickerViewController() {
        pickerView.frame = CGRect(x: 0, y: self.view.frame.maxY + 50 , width: self.view.frame.width, height: 200)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .groupTableViewBackground
        pickerView.isHidden = true
        view.addSubview(pickerView)
        view.bringSubviewToFront(pickerView)
    }
    
    private func setupToolBar() {
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY , width: self.view.frame.width, height: 50)
        toolBar.backgroundColor = .groupTableViewBackground
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonPressed))
        let items = [cancelButton, flexSpace, doneButton]
        toolBar.items = items
        toolBar.isHidden = true
        view.addSubview(toolBar)
        view.bringSubviewToFront(toolBar)
    }
    
    @objc private func doneButtonPressed() {
        let index = pickerView.selectedRow(inComponent: 0)
        baseCurrency = allCurrenciesViewModel.getCities()[index]
        allCurrenciesViewModel.fetchCurrencies(baseCurrency: baseCurrency)
        animatedPickerView()
    }
    
    @objc private func cancelButtonPressed() {
            animatedPickerView()
    }
    
    private func animatedPickerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.transform = CGAffineTransform(translationX: 0, y: 230)
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: 230)
        }) { (_) in
            self.pickerView.isHidden = true
            self.toolBar.isHidden = true
        }
    }
    
    @objc private func baseCurrencyLabelPressed() {
        UIView.animate(withDuration: 0.5) {
            self.toolBar.isHidden = false
            self.pickerView.isHidden = false
            
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: -230)
            self.pickerView.transform = CGAffineTransform(translationX: 0, y: -230)
        }
    }
    
    private func setupRecievedAllCurrencies() {
        allCurrenciesViewModel.didRecievedCurrecies = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.setupBaseCurrencyLabelText()
                self.setupOtherCurrencyLabel(currency: self.allCurrenciesViewModel.getCurrencyDictionary()[self.otherCurrency]!)
                self.pickerView.reloadAllComponents()
            }
        }
    }

}

extension OneCurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrenciesViewModel.getCurrenciesCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(allCurrenciesViewModel.getCities()[row])"
    }
    
}
