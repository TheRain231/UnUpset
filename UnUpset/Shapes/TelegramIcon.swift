//
//  TelegramIcon.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import SwiftUI

struct TelegramIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0.03422*height))
        path.addLine(to: CGPoint(x: 0.84347*width, y: 0.9257*height))
        path.addCurve(to: CGPoint(x: 0.7614*width, y: 0.95786*height), control1: CGPoint(x: 0.84347*width, y: 0.9257*height), control2: CGPoint(x: 0.82157*width, y: 0.9875*height))
        path.addLine(to: CGPoint(x: 0.40024*width, y: 0.64503*height))
        path.addLine(to: CGPoint(x: 0.39856*width, y: 0.64411*height))
        path.addCurve(to: CGPoint(x: 0.84218*width, y: 0.19296*height), control1: CGPoint(x: 0.44735*width, y: 0.59462*height), control2: CGPoint(x: 0.82565*width, y: 0.21038*height))
        path.addCurve(to: CGPoint(x: 0.82217*width, y: 0.1703*height), control1: CGPoint(x: 0.86777*width, y: 0.16599*height), control2: CGPoint(x: 0.85188*width, y: 0.14993*height))
        path.addLine(to: CGPoint(x: 0.26337*width, y: 0.57119*height))
        path.addLine(to: CGPoint(x: 0.04779*width, y: 0.48925*height))
        path.addCurve(to: CGPoint(x: 0.0106*width, y: 0.44597*height), control1: CGPoint(x: 0.04779*width, y: 0.48925*height), control2: CGPoint(x: 0.01387*width, y: 0.47561*height))
        path.addCurve(to: CGPoint(x: 0.04891*width, y: 0.40022*height), control1: CGPoint(x: 0.0073*width, y: 0.41628*height), control2: CGPoint(x: 0.04891*width, y: 0.40022*height))
        path.addLine(to: CGPoint(x: 0.92777*width, y: 0.01074*height))
        path.addCurve(to: CGPoint(x: width, y: 0.03422*height), control1: CGPoint(x: 0.92777*width, y: 0.01074*height), control2: CGPoint(x: width, y: -0.02512*height))
        path.closeSubpath()
        return path
    }
}
