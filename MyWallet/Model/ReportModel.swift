//
//  ReportModel.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

class ReportModel {
    static func monthlyOveralInfo() -> [MWMonthlyOverall] {
        let model = Facade.share.model

        let (minDate, maxDate) = model.getMinMaxDateInRecords()
        let monthYearList = Date.monthsBetweenDates(
            startDate: minDate,
            endDate: maxDate
        )
        let totalBudget = model.getTotalBudget()

        return monthYearList.compactMap {
            let numDays = Date.getMonthDuration(
                year: $0.year ?? 0,
                month: $0.month ?? 0,
                considerCurrent: true
            )
            let numDaysAll = Date.getMonthDuration(
                year: $0.year ?? 0,
                month: $0.month ?? 0,
                considerCurrent: false
            )

            let monthlyTotalCost = model.getTotalMonth(
                year: $0.year ?? 0,
                month: $0.month ?? 0,
                type: .cost
            )
            let dailyAverageCost = monthlyTotalCost / Double(numDays)

            let monthlyTotalIncome = model.getTotalMonth(
                year: $0.year ?? 0,
                month: $0.month ?? 0,
                type: .income
            )
            let dailyAverageIncome = monthlyTotalIncome / Double(numDays)

            let monthlyTotal = monthlyTotalIncome - monthlyTotalCost
            let dailyAverage = dailyAverageIncome - dailyAverageCost

            var items = [MWRecordRepresentation]()

            items.append(MWRecordRepresentation(
                type: .totalCost,
                value: monthlyTotalCost,
                recordType: .cost
            ))

            items.append(MWRecordRepresentation(
                type: .totalIncome,
                value: monthlyTotalIncome,
                recordType: .income
            ))

            items.append(MWRecordRepresentation(
                type: .total,
                value: monthlyTotal,
                recordType: .all
            ))

            if totalBudget > 0 {
                let monthlyTotalSave = totalBudget - monthlyTotalCost
                items.append(MWRecordRepresentation(
                    type: .totalSave,
                    value: monthlyTotalSave,
                    recordType: .all
                ))
            }

            items.append(MWRecordRepresentation(
                type: .dailyAverage,
                value: dailyAverage,
                recordType: .all
            ))

            items.append(MWRecordRepresentation(
                type: .dailyAverageCost,
                value: dailyAverageCost,
                recordType: .cost
            ))

            items.append(MWRecordRepresentation(
                type: .dailyAverageIncome,
                value: dailyAverageIncome,
                recordType: .income
            ))

            let monthlyForecast = dailyAverage * Double(numDaysAll)
            items.append(MWRecordRepresentation(
                type: .forcast,
                value: monthlyForecast,
                recordType: .all
            ))

            let monthlyForecastCost = dailyAverageCost * Double(numDaysAll)
            items.append(MWRecordRepresentation(
                type: .forcastCost,
                value: monthlyForecastCost,
                recordType: .cost
            ))

            let monthlyForecastIncome = dailyAverageIncome * Double(numDaysAll)
            items.append(MWRecordRepresentation(
                type: .forcastIncome,
                value: monthlyForecastIncome,
                recordType: .income
            ))

            return MWMonthlyOverall(month: $0, items: items)
        }
    }
}

struct MWMonthlyOverall {
    let month: MWMonth
    var items: [MWRecordRepresentation]
}

struct MWRecordRepresentation {
    let type: MWRepresentationType
    let value: Double
    let recordType: RecordType

    var label: String {
        return value.recordPresenter(for: recordType)
    }
}

enum MWRepresentationType: String {
    case totalCost = "Total Cost"
    case totalIncome = "Total Income"
    case total = "Total"
    case totalSave = "Total Save"
    case dailyAverage = "Daily Average"
    case dailyAverageCost = "Daily Average Cost"
    case dailyAverageIncome = "Daily Average Income"
    case forcast = "Monthly Forecast"
    case forcastCost = "Monthly Forecast Cost"
    case forcastIncome = "Monthly Forecast Income"
}
