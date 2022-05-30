//
//  ReportViewController.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 12/5/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
import AFDateHelper
class SearchReportViewController: BaseViewController {
    @IBOutlet weak var resultFilterLabel: UILabel!
    @IBOutlet weak var tagFilterCollectionView: UICollectionView!
    @IBOutlet weak var detailReportTableView: UITableView!
    var patientsFilterDate = [Patient]()
    var patients = [Patient]()
    var patientsDictionary = [Date: [Patient]]()
    var patientsSectionTitles = [Date]()
    var propertyFilter = [PatientType]()
    var timeOption = Int()
    private var countObjectOfProperty = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        propertyFilter.removeAll()
    }
    
    func configView() {
        setTableView()
        setCollectionView()
    }
    
    private func setTableView() {
        detailReportTableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        detailReportTableView.register(UINib(nibName: "HeaderReportCell", bundle: nil), forCellReuseIdentifier: "HeaderReportCell")
        detailReportTableView.delegate = self
        detailReportTableView.dataSource = self
        filterWithoptionTime(timeOption: timeOption)
        filterPatientwithProperty()
        createSectionForTableView()
    }
    
    private func setCollectionView() {
        tagFilterCollectionView.register(UINib(nibName: "TagFilterCell", bundle: nil), forCellWithReuseIdentifier: "TagFilterCell")
        tagFilterCollectionView.delegate = self
        tagFilterCollectionView.dataSource = self
        let layout = MyLeftCustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagFilterCollectionView.collectionViewLayout = layout
    }

    private func filterWithoptionTime(timeOption: Int) {
        var filter: DateComparisonType = .isToday
        var textResult = ""
        switch timeOption {
        case 1:
            filter = .isToday
            textResult = " Search Results for to day"
        case 2:
            filter = .isLastWeek
            textResult = " Search Results for week till date"
        case 3:
            filter = .isLastMonth
            textResult = " Search Results for month till date"
        case 4:
            filter = .isThisYear
            textResult = " Search Results for year till date"
        default:
            filter = .isToday
            textResult = " Search Results for all time"
        }
        if timeOption != 5 && timeOption != 0 {
            for i in mockData {
                if i.date.compare(filter) == true {
                    patientsFilterDate.append(i)
                }
            }
        } else {
            patientsFilterDate = mockData
        }
        resultFilterLabel.text = "\(patientsFilterDate.count)" + textResult
    }
    
    private func filterPatientwithProperty() {
        if propertyFilter.count != 0 {
            for type in propertyFilter {
                var cuont = 0
                for patient in patientsFilterDate {
                    if patient.type == type {
                        patients.append(patient)
                        cuont += 1
                    }
                }
                countObjectOfProperty.append(cuont)
            }
        } else {
            patients = patientsFilterDate
        }
    }
    
    private func createSectionForTableView() {
        for patient in patients {
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
    
    @IBAction func searchButton(_ sender: UIButton) {
        let ub = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = ub.instantiateViewController(withIdentifier: "SearchPatientViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableViewDataSource
extension SearchReportViewController: UITableViewDataSource {
    
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
    }
}

//MARK: UITableViewDelegate
extension SearchReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: UICollectionViewDataSource
extension SearchReportViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propertyFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagFilterCell", for: indexPath) as! TagFilterCell
        cell.setUpCell(type: propertyFilter[indexPath.row], count: countObjectOfProperty[indexPath.row])
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SearchReportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
//extension Calendar {
//  private var currentDate: Date { return Date() }
//
//  func isDateInThisWeek(_ date: Date) -> Bool {
//    return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
//  }
//
//  func isDateInThisMonth(_ date: Date) -> Bool {
//    return isDate(date, equalTo: currentDate, toGranularity: .month)
//  }
//
//  func isDateInLastWeek(_ date: Date) -> Bool {
//    guard let nextWeek = self.date(byAdding: DateComponents(weekOfYear: 1), to: currentDate) else {
//      return false
//    }
//    print(nextWeek)
////    Calendar.date(date(byAdding: <#T##Calendar.Component#>, value: -7, to: nextWeek)
//    return isDate(date, equalTo: "04/02/2020".createDateFromStr(), toGranularity: .weekOfYear)
//  }
//
//  func isDateInLastMonth(_ date: Date) -> Bool {
//    guard let nextMonth = self.date(byAdding: DateComponents(month: 1), to: currentDate) else {
//      return false
//    }
//    return isDate(date, equalTo: nextMonth, toGranularity: .month)
//  }
//
//  func isDateInFollowingMonth(_ date: Date) -> Bool {
//    guard let followingMonth = self.date(byAdding: DateComponents(month: 2), to: currentDate) else {
//      return false
//    }
//    return isDate(date, equalTo: followingMonth, toGranularity: .month)
//  }
//}
//
//
//extension Date {
//
//  static func today() -> Date {
//      return Date()
//  }
//
//  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
//    return get(.next,
//               weekday,
//               considerToday: considerToday)
//  }
//
//  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
//    return get(.previous,
//               weekday,
//               considerToday: considerToday)
//  }
//
//  func get(_ direction: SearchDirection,
//           _ weekDay: Weekday,
//           considerToday consider: Bool = false) -> Date {
//
//    let dayName = weekDay.rawValue
//
//    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
//
//    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
//
//    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
//
//    let calendar = Calendar(identifier: .gregorian)
//
//    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
//      return self
//    }
//
//    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
//    nextDateComponent.weekday = searchWeekdayIndex
//
//    let date = calendar.nextDate(after: self,
//                                 matching: nextDateComponent,
//                                 matchingPolicy: .nextTime,
//                                 direction: direction.calendarSearchDirection)
//
//    return date!
//  }
//
//}
//
//// MARK: Helper methods
//extension Date {
//  func getWeekDaysInEnglish() -> [String] {
//    var calendar = Calendar(identifier: .gregorian)
//    calendar.locale = Locale(identifier: "en_US_POSIX")
//    return calendar.weekdaySymbols
//  }
//
//  enum Weekday: String {
//    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
//  }
//
//  enum SearchDirection {
//    case next
//    case previous
//
//    var calendarSearchDirection: Calendar.SearchDirection {
//      switch self {
//      case .next:
//        return .forward
//      case .previous:
//        return .backward
//      }
//    }
//  }
//}
