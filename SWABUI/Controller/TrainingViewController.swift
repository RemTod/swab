//
//  TrainingViewController.swift
//  SWABUI
//
//  Created by Rem Remy on 08/07/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.black
    static var monthViewBtnRightColor = UIColor.black
    static var monthViewBtnLeftColor = UIColor.black
    static var activeCellLblColor = UIColor.black
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.darkGray
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class TrainingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UIScrollViewDelegate{

    var datesArr = [Int]()
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var selectedIndex: IndexPath!
    var indexToday = 0
    
    func initializeView() {
        for i in 0...364{
            datesArr.append(i)
        }
        
        dateCollection.delegate=self
        dateCollection.dataSource=self
        dateCollection.register(CalendarCell.self, forCellWithReuseIdentifier: "Cell")
        
        let today = Date()
        indexToday = Calendar.current.ordinality(of: .day, in: .year, for: today)!
        
        self.dateCollection.scrollToItem(at:IndexPath(item: indexToday, section: 0), at: .right, animated: false)

    }
    
    func snapToNearestCell(_ collectionView: UICollectionView) {
        let collectionViewFlowLayout = dateCollection.collectionViewLayout as! UICollectionViewFlowLayout
        for i in 0..<dateCollection.numberOfItems(inSection: 0) {

            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width

            if dateCollection.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / CGFloat(2){
                if i%7 == 0{
                    var j = i+3

                    let indexPath = IndexPath(item: j, section: 0)
                    dateCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    break
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToNearestCell(dateCollection)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            snapToNearestCell(dateCollection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.dateCollection{
//            print(indexPath.item)
            let previousSelectedIndex = selectedIndex
            var indexPathToReload = [IndexPath(item: indexPath.item, section: 0)]
            selectedIndex = indexPath
            
            if let previousSelectedIndex = previousSelectedIndex {
                indexPathToReload.append(previousSelectedIndex)
            }
            
//            dateCollection.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
            dateCollection.reloadItems(at: indexPathToReload)
//            if selectedIndex != indexPath{
//                print("yey")
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
//                selectedIndex = indexPath
//
//                cell.circle.backgroundColor =  #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//                cell.circle.layer.cornerRadius = 21
//                cell.dateLb.textColor = UIColor.white
//            }else{
//                let cellBefore = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: selectedIndex) as! CalendarCell
//                cellBefore.circle.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                cellBefore.dateLb.textColor = UIColor.black
//
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
//                selectedIndex = indexPath
//
//                cell.circle.backgroundColor =  #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//                cell.circle.layer.cornerRadius = 21
//                cell.dateLb.textColor = UIColor.white
//            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollection{
            return category.count
        }
        if currentYear % 4 == 0 {
            return 366
        } else {
            return 365
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            let cellIndex = indexPath.item
            
            cell.categoryImg.image = image[cellIndex]
            cell.categoryLb.text = category[cellIndex]
            cell.detailLb.text = detail[cellIndex]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MMMM d"
            let startDate = formatter.date(from: "2019 January 1")!
            
            var dateComponent = DateComponents()
            dateComponent.day = indexPath.row
            let dateToBeDisplayed = Calendar.current.date(byAdding: dateComponent, to: startDate)!
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM yyyy"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            cell.dateLb.text = dateFormatter.string(from: dateToBeDisplayed)
            monthLb.text = monthFormatter.string(from: dateToBeDisplayed)
            
            if selectedIndex != indexPath{
                cell.circle.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.dateLb.textColor = UIColor.black
            }else{
                let cellBefore = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: selectedIndex) as! CalendarCell
                
                cell.circle.backgroundColor =  #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                cell.circle.layer.cornerRadius = cell.circle.frame.width/2
                cell.dateLb.textColor = UIColor.white
                cellBefore.circle.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cellBefore.dateLb.textColor = UIColor.black
            }
            return cell
        }
    }
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var dateCollection: UICollectionView!
    @IBOutlet weak var monthLb: UILabel!
    
    let category = [("Flexibility"),("Stances"),("Test")]
    
    let detail = [("7 Moves - All Levels"),("5 Moves - All Levels"),("Test a Few Moves")]
    
    let image = [UIImage(named: "flexibility"),UIImage(named: "stances"),UIImage(named: "flexibility")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMMM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

