//
//  MWCategoryData.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

enum MWCategoryType {
    case expense
    case income

    var direction: Int {
        switch self {
        case .expense:
            return -1
        case .income:
            return +1
        }
    }
}

struct MWCategoryData {
    let title: String
    let identifier: String
    let icon: String
    let type: MWCategoryType
}

extension MWCategoryData {

    static var list: [MWCategoryData] {
        return MWCategoryData.expenseList + MWCategoryData.incomeList
    }

    static let expenseList: [MWCategoryData] = [
        MWCategoryData(
            title: "Foods & Drinks",
            identifier: "cat_expense_foods",
            icon: "fa-utensils",
            type: .expense
        ),
        MWCategoryData(
            title: "Groceries",
            identifier: "cat_expense_groceries",
            icon: "fa-shopping-cart",
            type: .expense
        ),
        MWCategoryData(
            title: "General",
            identifier: "cat_expense_general",
            icon: "fa-stream",
            type: .expense
        ),
        MWCategoryData(
            title: "Transport",
            identifier: "cat_expense_transport",
            icon: "fa-subway",
            type: .expense
        ),
        MWCategoryData(
            title: "Entertainment",
            identifier: "cat_expense_entertainment",
            icon: "fa-smile-beam",
            type: .expense
        ),
        MWCategoryData(
            title: "Personal Care",
            identifier: "cat_expense_care",
            icon: "fa-heartbeat",
            type: .expense
        ),
        MWCategoryData(
            title: "Bills",
            identifier: "cat_expense_bills",
            icon: "fa-file-invoice",
            type: .expense
        ),
        MWCategoryData(
            title: "Shopping",
            identifier: "cat_expense_shopping",
            icon: "fa-shopping-bag",
            type: .expense
        ),
        MWCategoryData(
            title: "Accommodation",
            identifier: "cat_expense_accommodation",
            icon: "fa-building",
            type: .expense
        ),
        MWCategoryData(
            title: "Housing",
            identifier: "cat_expense_housing",
            icon: "fa-paint-roller",
            type: .expense
        ),
        MWCategoryData(
            title: "Holidays",
            identifier: "cat_expense_holidays",
            icon: "fa-umbrella-beach",
            type: .expense
        ),
        MWCategoryData(
            title: "Lending",
            identifier: "cat_expense_lending",
            icon: "fa-hand-holding-usd",
            type: .expense
        )
    ]

    static let incomeList: [MWCategoryData] = [
        MWCategoryData(
            title: "Salary",
            identifier: "cat_income_salary",
            icon: "fa-suitcase",
            type: .income
        ),
        MWCategoryData(
            title: "General",
            identifier: "cat_income_general",
            icon: "fa-stream",
            type: .income
        ),
        MWCategoryData(
            title: "Gifts",
            identifier: "cat_income_gifts",
            icon: "fa-gift",
            type: .income
        ),
        MWCategoryData(
            title: "Sales",
            identifier: "cat_income_sales",
            icon: "fa-chart-bar",
            type: .income
        ),
        MWCategoryData(
            title: "Interests",
            identifier: "cat_income_interests",
            icon: "fa-coins",
            type: .income
        ),
        MWCategoryData(
            title: "Coupon",
            identifier: "cat_income_copuns",
            icon: "fa-money-bill-wave",
            type: .income
        ),
        MWCategoryData(
            title: "Supports",
            identifier: "cat_income_supports",
            icon: "fa-star",
            type: .income
        ),
        MWCategoryData(
            title: "Investments",
            identifier: "cat_income_investments",
            icon: "fa-piggy-bank",
            type: .income
        ),
        MWCategoryData(
            title: "Refunding Debt",
            identifier: "cat_income_refunding",
            icon: "fa-undo-alt",
            type: .income
        )
    ]
}

enum MWAppConfig {
    static var isSnapshot: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaults.snapshotKey)
    }
}

