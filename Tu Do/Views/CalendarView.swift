//
//  CalenderView.swift
//  Tu Do
//
//  Created by Ahmed El Gndy on 28/11/2024.
//

import UIKit
import FSCalendar
class CalendarView:UIView {
    weak var delegat: CalenderViewDelegat?
    lazy var calendar : FSCalendar = {
        let calender = FSCalendar()
        calender.delegate = self
        return calender
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Set Deal line"
        label.textAlignment = .center
        return label
        
    }()
    lazy var removeButton : UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(ResetButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    lazy var stackView :UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,calendar,removeButton])
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalender()
    }
    private func setupCalender() {
        backgroundColor = .white
        addSubview(stackView)
        stackView.setConstrains(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        calendar.setHeight(height: 250)
        titleLabel.setHeight(height: 24)
        removeButton.setHeight(height: 40)
        removeButton.setConstrains(left:stackView.leftAnchor ,bottom: stackView.bottomAnchor, right: stackView.rightAnchor,paddingLeft: 20,paddingBottom: 40, paddingRight: 20)
            }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectData(date: Date?){
        calendar.select(date, scrollToDate: true)
    }
    @objc func ResetButtonTapped(_ sender: UIButton){
        if let selected = calendar.selectedDate {
            calendar.deselect(selected)
            self.delegat?.ResetButtonTapped()
        }
    }
}

extension CalendarView:FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.delegat?.deadLineDidSelected(date: date)
    }
}
