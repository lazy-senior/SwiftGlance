//
//  SidebarIcon.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//


import SwiftUI

struct SidebarIconView: View {
    let systemName: String
    var isSelected: Bool = false
    var badge: Int? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            ZStack(alignment: .topTrailing) {
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 52, height: 52)
                    .overlay(
                        Image(systemName: systemName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(
                                isSelected ? .white : .primary.opacity(0.75)
                            )
                    )
                
                if let badge, badge > 0 {
                    Text("\(badge)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .offset(x: 8, y: -6)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
