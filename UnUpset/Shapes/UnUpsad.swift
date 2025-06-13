//
//  UnUpsad.swift
//  UnUpset
//
//  Created by Андрей Степанов on 02.06.2025.
//

import SwiftUI

struct UnUpsad: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5*width, y: 0.66667*height))
        path.addCurve(to: CGPoint(x: 0.35819*width, y: 0.83333*height), control1: CGPoint(x: 0.42168*width, y: 0.66667*height), control2: CGPoint(x: 0.35819*width, y: 0.74129*height))
        path.addLine(to: CGPoint(x: 0.35819*width, y: 0.95833*height))
        path.addCurve(to: CGPoint(x: 0.39364*width, y: height), control1: CGPoint(x: 0.35819*width, y: 0.98135*height), control2: CGPoint(x: 0.37406*width, y: height))
        path.addCurve(to: CGPoint(x: 0.42909*width, y: 0.95833*height), control1: CGPoint(x: 0.41322*width, y: height), control2: CGPoint(x: 0.42909*width, y: 0.98135*height))
        path.addLine(to: CGPoint(x: 0.42909*width, y: 0.83333*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.75*height), control1: CGPoint(x: 0.42909*width, y: 0.78731*height), control2: CGPoint(x: 0.46084*width, y: 0.75*height))
        path.addCurve(to: CGPoint(x: 0.57091*width, y: 0.83333*height), control1: CGPoint(x: 0.53916*width, y: 0.75*height), control2: CGPoint(x: 0.57091*width, y: 0.78731*height))
        path.addLine(to: CGPoint(x: 0.57091*width, y: 0.95833*height))
        path.addCurve(to: CGPoint(x: 0.60636*width, y: height), control1: CGPoint(x: 0.57091*width, y: 0.98135*height), control2: CGPoint(x: 0.58678*width, y: height))
        path.addCurve(to: CGPoint(x: 0.64181*width, y: 0.95833*height), control1: CGPoint(x: 0.62594*width, y: height), control2: CGPoint(x: 0.64181*width, y: 0.98135*height))
        path.addLine(to: CGPoint(x: 0.64181*width, y: 0.83333*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.66667*height), control1: CGPoint(x: 0.64181*width, y: 0.74129*height), control2: CGPoint(x: 0.57832*width, y: 0.66667*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.14547*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.28728*width, y: 0.16667*height), control1: CGPoint(x: 0.22379*width, y: 0), control2: CGPoint(x: 0.28728*width, y: 0.07462*height))
        path.addLine(to: CGPoint(x: 0.28728*width, y: 0.70824*height))
        path.addCurve(to: CGPoint(x: 0.25191*width, y: 0.7499*height), control1: CGPoint(x: 0.28728*width, y: 0.73121*height), control2: CGPoint(x: 0.27146*width, y: 0.74985*height))
        path.addCurve(to: CGPoint(x: 0.21637*width, y: 0.70824*height), control1: CGPoint(x: 0.2323*width, y: 0.74996*height), control2: CGPoint(x: 0.21637*width, y: 0.73129*height))
        path.addLine(to: CGPoint(x: 0.21637*width, y: 0.16667*height))
        path.addCurve(to: CGPoint(x: 0.14547*width, y: 0.08333*height), control1: CGPoint(x: 0.21637*width, y: 0.12064*height), control2: CGPoint(x: 0.18463*width, y: 0.08333*height))
        path.addCurve(to: CGPoint(x: 0.07456*width, y: 0.16667*height), control1: CGPoint(x: 0.10631*width, y: 0.08333*height), control2: CGPoint(x: 0.07456*width, y: 0.12064*height))
        path.addLine(to: CGPoint(x: 0.07456*width, y: 0.70833*height))
        path.addCurve(to: CGPoint(x: 0.03911*width, y: 0.75*height), control1: CGPoint(x: 0.07456*width, y: 0.73135*height), control2: CGPoint(x: 0.05869*width, y: 0.75*height))
        path.addCurve(to: CGPoint(x: 0.00365*width, y: 0.70833*height), control1: CGPoint(x: 0.01953*width, y: 0.75*height), control2: CGPoint(x: 0.00365*width, y: 0.73135*height))
        path.addLine(to: CGPoint(x: 0.00365*width, y: 0.16667*height))
        path.addCurve(to: CGPoint(x: 0.14547*width, y: 0), control1: CGPoint(x: 0.00365*width, y: 0.07462*height), control2: CGPoint(x: 0.06715*width, y: 0))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.85453*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.99634*width, y: 0.16667*height), control1: CGPoint(x: 0.93285*width, y: 0), control2: CGPoint(x: 0.99634*width, y: 0.07462*height))
        path.addLine(to: CGPoint(x: 0.99634*width, y: 0.70824*height))
        path.addCurve(to: CGPoint(x: 0.96097*width, y: 0.7499*height), control1: CGPoint(x: 0.99634*width, y: 0.73121*height), control2: CGPoint(x: 0.98053*width, y: 0.74985*height))
        path.addCurve(to: CGPoint(x: 0.92544*width, y: 0.70824*height), control1: CGPoint(x: 0.94136*width, y: 0.74996*height), control2: CGPoint(x: 0.92544*width, y: 0.73129*height))
        path.addLine(to: CGPoint(x: 0.92544*width, y: 0.16667*height))
        path.addCurve(to: CGPoint(x: 0.85453*width, y: 0.08333*height), control1: CGPoint(x: 0.92544*width, y: 0.12064*height), control2: CGPoint(x: 0.89369*width, y: 0.08333*height))
        path.addCurve(to: CGPoint(x: 0.78363*width, y: 0.16667*height), control1: CGPoint(x: 0.81537*width, y: 0.08333*height), control2: CGPoint(x: 0.78363*width, y: 0.12064*height))
        path.addLine(to: CGPoint(x: 0.78363*width, y: 0.70833*height))
        path.addCurve(to: CGPoint(x: 0.74817*width, y: 0.75*height), control1: CGPoint(x: 0.78363*width, y: 0.73135*height), control2: CGPoint(x: 0.76775*width, y: 0.75*height))
        path.addCurve(to: CGPoint(x: 0.71272*width, y: 0.70833*height), control1: CGPoint(x: 0.72859*width, y: 0.75*height), control2: CGPoint(x: 0.71272*width, y: 0.73135*height))
        path.addLine(to: CGPoint(x: 0.71272*width, y: 0.16667*height))
        path.addCurve(to: CGPoint(x: 0.85453*width, y: 0), control1: CGPoint(x: 0.71272*width, y: 0.07462*height), control2: CGPoint(x: 0.77621*width, y: 0))
        path.closeSubpath()
        return path
    }
}
