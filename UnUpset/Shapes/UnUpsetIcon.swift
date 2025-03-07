//
//  UnUpsetIcon.swift
//  UnUpset
//
//  Created by Андрей Степанов on 06.03.2025.
//

import SwiftUI

struct UnUpsetIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5*width, y: 0.99398*height))
        path.addCurve(to: CGPoint(x: 0.35969*width, y: 0.82831*height), control1: CGPoint(x: 0.42251*width, y: 0.99398*height), control2: CGPoint(x: 0.35969*width, y: 0.91981*height))
        path.addLine(to: CGPoint(x: 0.35969*width, y: 0.70407*height))
        path.addCurve(to: CGPoint(x: 0.39477*width, y: 0.66265*height), control1: CGPoint(x: 0.35969*width, y: 0.68119*height), control2: CGPoint(x: 0.3754*width, y: 0.66265*height))
        path.addCurve(to: CGPoint(x: 0.42985*width, y: 0.70407*height), control1: CGPoint(x: 0.41414*width, y: 0.66265*height), control2: CGPoint(x: 0.42985*width, y: 0.68119*height))
        path.addLine(to: CGPoint(x: 0.42985*width, y: 0.82831*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.91114*height), control1: CGPoint(x: 0.42985*width, y: 0.87406*height), control2: CGPoint(x: 0.46126*width, y: 0.91114*height))
        path.addCurve(to: CGPoint(x: 0.57015*width, y: 0.82831*height), control1: CGPoint(x: 0.53874*width, y: 0.91114*height), control2: CGPoint(x: 0.57015*width, y: 0.87406*height))
        path.addLine(to: CGPoint(x: 0.57015*width, y: 0.70407*height))
        path.addCurve(to: CGPoint(x: 0.60523*width, y: 0.66265*height), control1: CGPoint(x: 0.57015*width, y: 0.68119*height), control2: CGPoint(x: 0.58586*width, y: 0.66265*height))
        path.addCurve(to: CGPoint(x: 0.64031*width, y: 0.70407*height), control1: CGPoint(x: 0.6246*width, y: 0.66265*height), control2: CGPoint(x: 0.64031*width, y: 0.68119*height))
        path.addLine(to: CGPoint(x: 0.64031*width, y: 0.82831*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.99398*height), control1: CGPoint(x: 0.64031*width, y: 0.91981*height), control2: CGPoint(x: 0.57749*width, y: 0.99398*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.14923*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.28954*width, y: 0.16566*height), control1: CGPoint(x: 0.22672*width, y: 0), control2: CGPoint(x: 0.28954*width, y: 0.07417*height))
        path.addLine(to: CGPoint(x: 0.28954*width, y: 0.70397*height))
        path.addCurve(to: CGPoint(x: 0.25455*width, y: 0.74539*height), control1: CGPoint(x: 0.28954*width, y: 0.7268*height), control2: CGPoint(x: 0.27389*width, y: 0.74533*height))
        path.addCurve(to: CGPoint(x: 0.21939*width, y: 0.70397*height), control1: CGPoint(x: 0.23514*width, y: 0.74544*height), control2: CGPoint(x: 0.21939*width, y: 0.72688*height))
        path.addLine(to: CGPoint(x: 0.21939*width, y: 0.16566*height))
        path.addCurve(to: CGPoint(x: 0.14923*width, y: 0.08283*height), control1: CGPoint(x: 0.21939*width, y: 0.11992*height), control2: CGPoint(x: 0.18798*width, y: 0.08283*height))
        path.addCurve(to: CGPoint(x: 0.07908*width, y: 0.16566*height), control1: CGPoint(x: 0.11049*width, y: 0.08283*height), control2: CGPoint(x: 0.07908*width, y: 0.11992*height))
        path.addLine(to: CGPoint(x: 0.07908*width, y: 0.70407*height))
        path.addCurve(to: CGPoint(x: 0.04401*width, y: 0.74548*height), control1: CGPoint(x: 0.07908*width, y: 0.72694*height), control2: CGPoint(x: 0.06338*width, y: 0.74548*height))
        path.addCurve(to: CGPoint(x: 0.00893*width, y: 0.70407*height), control1: CGPoint(x: 0.02463*width, y: 0.74548*height), control2: CGPoint(x: 0.00893*width, y: 0.72694*height))
        path.addLine(to: CGPoint(x: 0.00893*width, y: 0.16566*height))
        path.addCurve(to: CGPoint(x: 0.14923*width, y: 0), control1: CGPoint(x: 0.00893*width, y: 0.07417*height), control2: CGPoint(x: 0.07175*width, y: 0))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.85077*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.99107*width, y: 0.16566*height), control1: CGPoint(x: 0.92825*width, y: 0), control2: CGPoint(x: 0.99107*width, y: 0.07417*height))
        path.addLine(to: CGPoint(x: 0.99107*width, y: 0.70397*height))
        path.addCurve(to: CGPoint(x: 0.95608*width, y: 0.74539*height), control1: CGPoint(x: 0.99107*width, y: 0.7268*height), control2: CGPoint(x: 0.97542*width, y: 0.74533*height))
        path.addCurve(to: CGPoint(x: 0.92092*width, y: 0.70397*height), control1: CGPoint(x: 0.93667*width, y: 0.74544*height), control2: CGPoint(x: 0.92092*width, y: 0.72688*height))
        path.addLine(to: CGPoint(x: 0.92092*width, y: 0.16566*height))
        path.addCurve(to: CGPoint(x: 0.85077*width, y: 0.08283*height), control1: CGPoint(x: 0.92092*width, y: 0.11992*height), control2: CGPoint(x: 0.88951*width, y: 0.08283*height))
        path.addCurve(to: CGPoint(x: 0.78061*width, y: 0.16566*height), control1: CGPoint(x: 0.81202*width, y: 0.08283*height), control2: CGPoint(x: 0.78061*width, y: 0.11992*height))
        path.addLine(to: CGPoint(x: 0.78061*width, y: 0.70407*height))
        path.addCurve(to: CGPoint(x: 0.74554*width, y: 0.74548*height), control1: CGPoint(x: 0.78061*width, y: 0.72694*height), control2: CGPoint(x: 0.76491*width, y: 0.74548*height))
        path.addCurve(to: CGPoint(x: 0.71046*width, y: 0.70407*height), control1: CGPoint(x: 0.72616*width, y: 0.74548*height), control2: CGPoint(x: 0.71046*width, y: 0.72694*height))
        path.addLine(to: CGPoint(x: 0.71046*width, y: 0.16566*height))
        path.addCurve(to: CGPoint(x: 0.85077*width, y: 0), control1: CGPoint(x: 0.71046*width, y: 0.07417*height), control2: CGPoint(x: 0.77328*width, y: 0))
        path.closeSubpath()
        return path
    }
}
