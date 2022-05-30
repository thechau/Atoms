//
//  ReportViewController.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 1/7/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {
    
    @IBOutlet weak var allPatientsReportTableView: UITableView!
    @IBOutlet weak var latestReportTableView: UITableView!
    @IBOutlet weak var selectTypeReportView: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var latestButton: UIButton!
    @IBOutlet weak var allPatientsButton: UIButton!
    
    let data : [[PatientType]] = [[.alert, .boderLine, .normal],[.normal, .boderLine, .normal],[.alert, .boderLine, .normal],[.alert, .boderLine, .normal],[.normal, .boderLine, .normal],[.alert, .boderLine, .normal]]
    let sectionString = ["September 14", "September 13", "September 12","September 11","September 10", "September 9"]
    var namePatientsDictionary = [String: [String]]()
    var namePatientsSectionTitles = [String]()
    let namePatients = ["Adam.J", "Arun.M","Bony.P", "Brian.D", "Bharat.M","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setUpTableView()
        setUpFilterAllPatientsReportTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configView() {
        selectView.layer.borderWidth = 1
        selectView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        selectView.tintColor = .clear
        selectView.layer.shadowColor = UIColor(hex: "c9cdda").cgColor
        selectView.layer.shadowOffset = CGSize(width: 0, height: 4)
        selectView.layer.shadowRadius = 2
        selectView.layer.shadowOpacity = 1
        selectView.layer.cornerRadius = 18
        selectTypeReportView.layer.cornerRadius = 18
        allPatientsReportTableView.isHidden = true
        latestButton.setTitleColor(UIColor.darkGray, for: .normal)
        allPatientsButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    private func setUpTableView() {
        latestReportTableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        latestReportTableView.register(UINib(nibName: "HeaderReportCell", bundle: nil), forCellReuseIdentifier: "HeaderReportCell")
        latestReportTableView.delegate = self
        latestReportTableView.dataSource = self
        
        allPatientsReportTableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        allPatientsReportTableView.register(UINib(nibName: "HeaderReportCell", bundle: nil), forCellReuseIdentifier: "HeaderReportCell")
        allPatientsReportTableView.delegate = self
        allPatientsReportTableView.dataSource = self
    }
    
    private func changeTextColorWhenSelect(isLatest: Bool) {
        if isLatest {
            latestButton.setTitleColor(UIColor.darkGray, for: .normal)
            allPatientsButton.setTitleColor(UIColor.lightGray, for: .normal)
        } else {
            allPatientsButton.setTitleColor(UIColor.darkGray, for: .normal)
            latestButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    private func setUpFilterAllPatientsReportTableView() {
        for patient in namePatients {
            let nameKey = String(patient.prefix(1))
                if var patientValues = namePatientsDictionary[nameKey] {
                    patientValues.append(patient)
                    namePatientsDictionary[nameKey] = patientValues
                } else {
                    namePatientsDictionary[nameKey] = [patient]
                }
        }
        namePatientsSectionTitles = [String](namePatientsDictionary.keys)
        namePatientsSectionTitles = namePatientsSectionTitles.sorted(by: { $0 < $1 })
    }
    
    private func setPositionSelectView(_ x: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.selectView.frame.origin.x = x
        }
    }
    
    private func showTableView(_ isShowlatestReportTableView: Bool) {
        latestReportTableView.isHidden = !isShowlatestReportTableView
        allPatientsReportTableView.isHidden = isShowlatestReportTableView
    }
    
    @IBAction func searchPatientButton(_ sender: UIButton) {
        let ub = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = ub.instantiateViewController(withIdentifier: "FilterReportViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToCreatePatient(_ sender: UIButton) {
        let ub = UIStoryboard(name: "Main", bundle: nil)
        let vc = ub.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectTypeReportButton(_ sender: UIButton) {
        let positionX = sender.tag == 0 ? 0 : selectTypeReportView.frame.width/2
        let isShowlatestReportTableView = sender.tag == 0 ? true : false
        setPositionSelectView(positionX)
        showTableView(isShowlatestReportTableView)
        changeTextColorWhenSelect(isLatest: isShowlatestReportTableView)
    }
}


//MARK: UITableViewDataSource
extension ReportViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == latestReportTableView ? data.count : namePatientsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == latestReportTableView {
            return data[section].count
        }
        let nameKey = namePatientsSectionTitles[section]
           if let nameValues = namePatientsDictionary[nameKey] {
               return nameValues.count
           }
           return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == latestReportTableView {
          let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderReportCell") as! HeaderReportCell
               headerView.dateLabel.text = sectionString[section]
               return headerView
        }
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderReportCell") as! HeaderReportCell
           headerView.dateLabel.text = namePatientsSectionTitles[section]
           return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == latestReportTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportCell
                 let type = data[indexPath.section][indexPath.row]
                 cell.setTypePatient(type: type)
                 return cell
        }
        // config Filter Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        let nameKey = namePatientsSectionTitles[indexPath.section]
        if let patientValues = namePatientsDictionary[nameKey] {
            cell.hiddenDotViewAndTypePatientLabel()
            cell.setNamePatient(name: patientValues[indexPath.row])
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension ReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == allPatientsReportTableView {
            return namePatientsSectionTitles
        }
        return [""]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == latestReportTableView {
            let ub = UIStoryboard(name: "ReportSTB", bundle: nil)
            let vc = ub.instantiateViewController(withIdentifier: "DetailReportPatientViewController")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
