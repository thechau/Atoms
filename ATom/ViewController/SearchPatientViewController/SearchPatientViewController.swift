//
//  SearchPatientViewController.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 2/14/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class SearchPatientViewController: BaseViewController {
    
    @IBOutlet weak var patientTableView: UITableView!
    @IBOutlet weak var searchPatientTextField: UITextField!
    
    var listSearchPatients = [Patient]()
    var patientsDictionary = [Date: [Patient]]()
    var patientsSectionTitles = [Date]()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func setTableView() {
        patientTableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        patientTableView.register(UINib(nibName: "HeaderReportCell", bundle: nil), forCellReuseIdentifier: "HeaderReportCell")
        patientTableView.delegate = self
        patientTableView.dataSource = self
        createSectionForTableView()
    }
    
    private func createSectionForTableView() {
        patientsDictionary.removeAll()
        patientsSectionTitles.removeAll()
        for patient in listSearchPatients {
            let dateKey = patient.date
                       if var patientValues = patientsDictionary[dateKey] {
                           patientValues.append(patient)
                           patientsDictionary[dateKey] = patientValues
                       } else {
                           patientsDictionary[dateKey] = [patient]
                       }
               }
        patientsSectionTitles = [Date](patientsDictionary.keys)
        patientsSectionTitles = patientsSectionTitles.sorted(by: { $0 > $1 })
    }
    
    private func configView() {
        patientTableView.isHidden = true
        searchPatientTextField.setLeftView(image: #imageLiteral(resourceName: "ic-search"))
        searchPatientTextField.cornerRadius(value: 17)
        searchPatientTextField.delegate = self
        setTableView()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        searchPatientTextField.text = ""
        listSearchPatients.removeAll()
        patientTableView.reloadData()
    }
}

extension SearchPatientViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func getListSearchProduct(){
        if searchPatientTextField.text?.count != 0 {
            self.listSearchPatients.removeAll()
            for patient in mockData{
                let namePatient = patient.name
                let range = namePatient.lowercased().range(of: searchPatientTextField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil{
                    self.listSearchPatients.append(patient)
                }
            }
            patientTableView.isHidden = false
        } else {
            patientTableView.isHidden = true
            listSearchPatients.removeAll()
        }
        
        createSectionForTableView()
        patientTableView.reloadData()
        timer.invalidate()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] (timer) in
            print(timer)
            self?.getListSearchProduct()
        }
        return true
    }
}


//MARK: UITableViewDataSource
extension SearchPatientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderReportCell") as! HeaderReportCell
        let df = DateFormatter()
        df.dateFormat = "MMMM dd"
        let dateString = df.string(from: patientsSectionTitles[section])
        headerView.dateLabel.text = dateString
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return patientsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = patientsSectionTitles[section]
           if let patientValues = patientsDictionary[dateKey] {
               return patientValues.count
           }
           return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportCell
        let nameKey = patientsSectionTitles[indexPath.section]
        if let patientValues = patientsDictionary[nameKey] {
            cell.setTypePatient(type: patientValues[indexPath.row].type)
            cell.setNamePatient(name: patientValues[indexPath.row].name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PatientInformationViewController")
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableViewDelegate
extension SearchPatientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
