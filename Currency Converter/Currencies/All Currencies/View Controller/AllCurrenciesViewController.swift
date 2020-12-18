//
//  AllCurrenciesViewController.swift
//  Currency Converter
//
//  Created by Ragy Bahgat on 12/18/20.
//

import UIKit

class AllCurrenciesViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyView: UIView!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!
    
    private let allCurrenciesViewModel = AllCurrenciesViewModel()
    private let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    private var baseCurrency = "EGP"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupRecievedAllCurrencies()
        
        allCurrenciesViewModel.fetchCurrencies(baseCurrency: "EGP")
    }

    private func setupViews() {
        setupNavigationBar()
        setupBaseCurrencyView()
        setupBaseCurrencyLabel()
        setupCurrencyTableView()
        setupPickerViewController()
        setupToolBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Currency Converter"
    }
    
    private func setupBaseCurrencyView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.baseCurrencyViewPressed))
        baseCurrencyView.addGestureRecognizer(tapGesture)
    }
    
    private func setupBaseCurrencyLabel() {
        baseCurrencyLabel.text = "Base currency = EGP"
    }
    
    private func setupCurrencyTableView() {
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
        let nib = UINib(nibName: String(describing: CurrencyTableViewCell.self), bundle: nil)
        currencyTableView.register(nib, forCellReuseIdentifier: String(describing: CurrencyTableViewCell.self))
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
        baseCurrencyLabel.text = "Base currency = \(baseCurrency)"
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
    
    private func setupRecievedAllCurrencies() {
        allCurrenciesViewModel.didRecievedCurrecies = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.currencyTableView.reloadData()
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    @objc private func baseCurrencyViewPressed() {
        UIView.animate(withDuration: 0.5) {
            self.toolBar.isHidden = false
            self.pickerView.isHidden = false
            
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: -230)
            self.pickerView.transform = CGAffineTransform(translationX: 0, y: -230)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OneCurrencyViewController, let index = sender as? Int {
            vc.baseCurrency = baseCurrency
            vc.otherCurrency = allCurrenciesViewModel.getCities()[index]
        }
    }
    
}

extension AllCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCurrenciesViewModel.getCurrenciesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyTableViewCell.self), for: indexPath) as! CurrencyTableViewCell
        
        cell.setupData(currencyModel: allCurrenciesViewModel.getCurrencies()[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showOneCurrency", sender: indexPath.row)
    }
    
}

extension AllCurrenciesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
