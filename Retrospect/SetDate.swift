//
//  ChooseName.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-14.
//

import SwiftUI
import SwiftUIIntrospect
import Foundation

struct SetDate: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var oneMonth: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var sixMonth: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
    @State private var oneYear: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var selectedDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var selectedYear = Calendar.current.component(.year, from: Date()) + 1
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDay = Calendar.current.component(.day, from: Date())
    
    private var currentDate: Date {
        Date()
    }

    private var minDate: Date {
        Calendar(identifier: .gregorian).date(byAdding: .month, value: 1, to: currentDate)!
    }

    private var minYear: Int {
        Calendar(identifier: .gregorian).component(.year, from: minDate)
    }

    private var minMonth: Int {
        Calendar(identifier: .gregorian).component(.month, from: minDate)
    }

    private var minDay: Int {
        Calendar(identifier: .gregorian).component(.day, from: minDate)
    }

    private var years: [Int] {
        Array(minYear...2030)
    }
    
    private var months: [Int] {
        if selectedYear == minYear {
            return Array(minMonth...12)
        } else {
            return Array(1...12)
        }
    }

    private var days: [Int] {
        let daysInMonth = numberOfDaysInMonth(year: selectedYear, month: selectedMonth)
        if selectedYear == minYear && selectedMonth == minMonth {
            return Array(minDay...daysInMonth)
        } else {
            return Array(1...daysInMonth)
        }
    }
    
    var body: some View {
        VStack {
            Text("Now, set a date for your time capsule")
                .font(.custom("IvyOraDisplay-Regular", size: 48))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 50)
            
            Spacer()
            
            HStack(spacing: 0) {
                Picker(selection: $selectedYear, label: Text("Year")) {
                    ForEach(years, id: \.self) { year in
                        Text(verbatim: "\(year)")
                            .tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .onChange(of: selectedYear) {
                    adjustDayIfNeeded()
                    selectedDate = setDate(year: selectedYear, month: selectedMonth, day: selectedDay)
                    print(selectedDate)
                }
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
                
                Text("/")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                
                Picker(selection: $selectedMonth, label: Text("Month")) {
                    ForEach(months, id: \.self) {
                        Text(String(format: "%02d", $0)).tag($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .onChange(of: selectedMonth) {
                    adjustDayIfNeeded()
                    selectedDate = setDate(year: selectedYear, month: selectedMonth, day: selectedDay)
                    print(selectedDate)
                }
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
                
                Text("/")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                
                Picker(selection: $selectedDay, label: Text("Day")) {
                    ForEach(days, id: \.self) {
                        Text(String(format: "%02d", $0)).tag($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .onChange(of: selectedDay) {
                    adjustDayIfNeeded()
                    selectedDate = setDate(year: selectedYear, month: selectedMonth, day: selectedDay)
                }
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
            }
            .background(Color.white)
            .cornerRadius(50)
            .foregroundColor(.white)
            .frame(height: 70)
            .padding(.horizontal, 10)
            
            Spacer()
            
            Button(action: {
                globalState.route = "/capsule/seal-box"
            }) {
                Text("I'm ready to seal!")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.bottom, 80)
        }
    }
    
    private func numberOfDaysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    private func adjustDayIfNeeded() {
        let daysInMonth = numberOfDaysInMonth(year: selectedYear, month: selectedMonth)
        if selectedDay > daysInMonth {
            selectedDay = daysInMonth
        }
        if selectedYear == minYear && selectedMonth == minMonth && selectedDay < minDay {
            selectedDay = minDay
        }
    }
    
    private func setDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: components) {
            return date
        } else {
            return Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        SetDate() 
    }
}

