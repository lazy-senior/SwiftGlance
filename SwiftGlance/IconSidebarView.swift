//
//  IconSidebarView.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI

struct IconSidebarView: View {
    @Binding var selection: Panel

    var body: some View {
        VStack(spacing: 18) {
            navIcon("bookmark", panel: .bookmarks)
            navIcon("globe", panel: .browser)
            navIcon("clock.arrow.circlepath", panel: .recent)

            Spacer()

            navIcon("gearshape", panel: .manage)
        }
        .padding(.vertical, 20)
        .frame(width: 72)
        .background(.ultraThinMaterial)
    }

    private func navIcon(_ systemName: String, panel: Panel) -> some View {
        SidebarIconView(
            systemName: systemName,
            isSelected: selection == panel,
            action: { selection = panel }
        )
    }
}

#Preview {
    IconSidebarView(selection: .Constant(.bookmarks))
        .frame(width: 72, height: 300)
}
