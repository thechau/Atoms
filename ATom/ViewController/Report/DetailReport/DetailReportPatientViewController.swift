//
//  PatientViewController.swift
//  ATom
//
//  Created by nguyen.vuong.thanh.loc on 11/28/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class DetailReportPatientViewController: BaseViewController {

    @IBOutlet weak var contactView: ContactView!
    @IBOutlet weak var patientTableView: UITableView!
    @IBOutlet weak var mainPatienView: SelectPatientView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var showViewContact = false
    private var isShowSelect = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        setUpTableView()
        patientTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        contactView.delegate = self
        contactView.isHidden = true
    }
    
    func setUpTableView() {
        patientTableView.register(UINib(nibName: "PatientOptionCell", bundle: nil), forCellReuseIdentifier: "PatientOptionCell")
        patientTableView.dataSource = self
        patientTableView.delegate = self
    }
    
    func showButtonSelectInPatientView(isShow: Bool) {
        if isShow {
            mainPatienView.showIconCheck(isShow: true)
        } else {
            mainPatienView.showIconCheck(isShow: false)
        }

    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        if isShowSelect == false {
            selectButton.setTitle("Deselect", for: .normal)

            showButtonSelectInPatientView(isShow: true)
            mainPatienView.enableSelect(enable: true)
            isShowSelect = true
        } else {
            selectButton.setTitle("Select", for: .normal)

            showButtonSelectInPatientView(isShow: false)
            mainPatienView.enableSelect(enable: false)

            isShowSelect = false
        }
        patientTableView.reloadData()

    }
    
    func sharePdf(path:URL) {

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: path.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path, path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
            let alertController = UIAlertController(title: "Error", message: "Document was not found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editInformationButotn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PatientInformationViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        if let pdf = Bundle.main.url(forResource: "patient", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            self.sharePdf(path: pdf)
        }
    }
    
    @IBAction func contactButton(_ sender: UIButton) {
        contactView.isHidden = false
        showViewContact = true
    }
}

extension DetailReportPatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientOptionCell") as! PatientOptionCell
        
        if isShowSelect {
            cell.showSelect(isShow: true)
        } else {
            cell.showSelect(isShow: false)
        }
        
        if indexPath.row % 2 == 0 {
            cell.setTypePatient(type: .boderLine)
        } else {
            cell.setTypePatient(type: .normal)
        }
        return cell
    }
    
}

extension DetailReportPatientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DetailReportPatientViewController: ContactViewDelegate {
    func closeContactView() {
        if showViewContact == false {
            contactView.isHidden = false
            showViewContact = true
        } else {
            contactView.isHidden = true
            showViewContact = false
        }
    }
}
