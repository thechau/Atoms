//
//  ViewController.swift
//  Test
//
//  Created by nguyen.vuong.thanh.loc on 11/12/19.
//  Copyright © 2019 vuongthanhloc. All rights reserved.
//

import UIKit
import JTAppleCalendar

class FilterReportViewController: BaseViewController {

    
    @IBOutlet weak var untillDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var selectDateView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var dateRangeTableView: UITableView!
    @IBOutlet weak var alertButton: CustomButtom!
    @IBOutlet weak var borderlineButton: CustomButtom!
    @IBOutlet weak var normalButton: CustomButtom!
    @IBOutlet weak var repeatEcgButton: CustomButtom!
    @IBOutlet weak var analysisDueButton: CustomButtom!
    @IBOutlet weak var allButton: CustomButtom!
    @IBOutlet weak var stateSelectDateRangeView: UIView!
    @IBOutlet weak var stateSelectCustomDateView: UIView!
    @IBOutlet weak var dateRangeButton: UIButton!
    @IBOutlet weak var customDateButton: UIButton!
    private let dateRangeArray = ["Today", "Week till date", "Month till date", "Year till date", "All time"]
    var propertyFilter = [PatientType]()
    var timeOption = Int()
    let testCalendar = Calendar(identifier: .gregorian)
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateRangeTableView.register(UINib(nibName: "DateRangeCell", bundle: nil), forCellReuseIdentifier: "DateRangeCell")
        dateRangeTableView.delegate = self
        dateRangeTableView.dataSource = self
        
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        selectDateView.isHidden = true
        
        
    }
    
    func changeColorButtonWhenSelect(color: UIColor, button: UIButton) {
        if button.isSelected == false {
            button.isSelected = true
            button.backgroundColor = color
            button.setTitleColor(.white, for: .normal)
        } else {
            button.isSelected = false
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
        if button != allButton {
            allButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            allButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            allButton.isSelected = false
        }
    }
    
    func selectDateRangeOfCustomDate(selectDateRange: Bool) {
        if selectDateRange {
            stateSelectDateRangeView.backgroundColor = #colorLiteral(red: 0.3105244637, green: 0.4771254063, blue: 0.9876179099, alpha: 1)
            stateSelectCustomDateView.backgroundColor = .white
            dateRangeButton.setTitleColor(#colorLiteral(red: 0.354794085, green: 0.3673947752, blue: 0.4309301972, alpha: 1), for: .normal)
            customDateButton.setTitleColor(#colorLiteral(red: 0.5720342994, green: 0.625646472, blue: 0.67997545, alpha: 1), for: .normal)
            selectDateView.isHidden = true
            dateRangeTableView.isHidden = false
        } else {
            stateSelectCustomDateView.backgroundColor = #colorLiteral(red: 0.3105244637, green: 0.4771254063, blue: 0.9876179099, alpha: 1)
            stateSelectDateRangeView.backgroundColor = .white
            customDateButton.setTitleColor(#colorLiteral(red: 0.354794085, green: 0.3673947752, blue: 0.4309301972, alpha: 1), for: .normal)
            dateRangeButton.setTitleColor(#colorLiteral(red: 0.5720342994, green: 0.625646472, blue: 0.67997545, alpha: 1), for: .normal)
            selectDateView.isHidden = false
            dateRangeTableView.isHidden = true

        }
    }
    
    func resetAll() {
        for button in [alertButton , borderlineButton, normalButton, repeatEcgButton, analysisDueButton, allButton] {
            button?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            button?.isSelected = false
        }
        propertyFilter.removeAll()
        dateRangeTableView.reloadData()
        calendarView.deselectAllDates()
    }
    
    func convertDateToString(date: Date, formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    private func deactivatedAllButton() {
        for button in [alertButton , borderlineButton, normalButton, repeatEcgButton, analysisDueButton] {
            button?.backgroundColor = #colorLiteral(red: 0.8873564005, green: 0.8941367269, blue: 0.9048580527, alpha: 1)
            button?.setTitleColor(#colorLiteral(red: 0.6694795489, green: 0.6695944071, blue: 0.6694634557, alpha: 1), for: .normal)
            button?.isSelected = false
        }
    }
    
    private func addPropertyToFilter(type: PatientType, isSelected: Bool) {
        if isSelected == true {
            propertyFilter.append(type)
        } else {
            if let type = propertyFilter.index(of: type) {
                propertyFilter.remove(at: type)
            }
        }
    }
    
    @IBAction func alertButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.8980392157, green: 0.2235294118, blue: 0.2078431373, alpha: 1), button: sender)
        addPropertyToFilter(type: .alert, isSelected: sender.isSelected)
    }
    
    @IBAction func borderLineButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.9846976399, green: 0.7539826035, blue: 0.1756163239, alpha: 1), button: sender)
        addPropertyToFilter(type: .boderLine, isSelected: sender.isSelected)
    }
    @IBAction func normalButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.4394078553, green: 0.7241675258, blue: 0.166809231, alpha: 1), button: sender)
        addPropertyToFilter(type: .normal, isSelected: sender.isSelected)
    }
    
    @IBAction func repeatButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.7307185531, green: 0.4072598815, blue: 0.7814572453, alpha: 1), button: sender)

    }
    
    @IBAction func analysisButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1), button: sender)
    }
    
    @IBAction func allButton(_ sender: UIButton) {
        changeColorButtonWhenSelect(color: #colorLiteral(red: 0.2998971343, green: 0.3169040978, blue: 0.3821227551, alpha: 1), button: sender)
        deactivatedAllButton()
        propertyFilter.removeAll()
    }
    @IBAction func dateRangeButton(_ sender: UIButton) {
        selectDateRangeOfCustomDate(selectDateRange: true)
        
    }
    @IBAction func customDateButton(_ sender: UIButton) {
        selectDateRangeOfCustomDate(selectDateRange: false)

    }
    
    @IBAction func applyButton(_ sender: CustomButtom) {
        let sb = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchReportViewController") as! SearchReportViewController
        vc.propertyFilter = self.propertyFilter
        vc.timeOption = self.timeOption
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetAll()
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.cornerRadius = 10
            cell.selectedView.backgroundColor = #colorLiteral(red: 0.2300223112, green: 0.4335231781, blue: 0.8104397655, alpha: 1)
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            fromDateLabel.text = convertDateToString(date: cellState.date, formatter: "dd/MM/yyyy")

        case .middle:
            cell.selectedView.backgroundColor = #colorLiteral(red: 0.9138564467, green: 0.9177395701, blue: 0.9217028022, alpha: 1)
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
    
        case .right:
            cell.selectedView.backgroundColor = #colorLiteral(red: 0.2300223112, green: 0.4335231781, blue: 0.8104397655, alpha: 1)
            cell.selectedView.layer.cornerRadius = 10
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            untillDateLabel.text = convertDateToString(date: cellState.date, formatter: "dd/MM/yyyy")

        case .full:
            cell.selectedView.backgroundColor = #colorLiteral(red: 0.2300223112, green: 0.4335231781, blue: 0.8104397655, alpha: 1)
            cell.selectedView.layer.cornerRadius = 10
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            fromDateLabel.text = ""
            untillDateLabel.text = ""
        default: break
        }
    }
  
}

extension FilterReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRangeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateRangeCell") as! DateRangeCell
        cell.titleLabel.text = dateRangeArray[indexPath.row]
        return cell
    }
}

extension FilterReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.timeOption = indexPath.row + 1
    }
}

extension FilterReportViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2019 01 1")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension FilterReportViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        titleDateLabel.text = convertDateToString(date: visibleDates.monthDates.last?.date ?? Date(), formatter: "MMMM yyyy")
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if firstDate != nil {
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
        }

        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
            firstDate = nil
            let retval = !calendarView.selectedDates.contains(date)
            calendarView.deselectAllDates()
            return retval
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            firstDate = nil
            calendarView.deselectAllDates()
            return false
        }
        return true
    }
}


