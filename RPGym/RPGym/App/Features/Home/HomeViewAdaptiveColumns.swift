import SwiftUI

enum MenuOption: String, CaseIterable, Identifiable, Hashable {
    case routine, fitnessPlan, profile, configurations
    var id: String { self.rawValue }

    var image: String {
        switch self {
        case .routine: "dumbbell.fill"
        case .fitnessPlan: "calendar"
        case .profile: "person.fill"
        case .configurations: "gearshape.fill"
        }
    }
}

struct Constans {
    static let buttonSize: CGFloat = 100
    static let spacing: CGFloat = 20
}

struct HomeViewAdaptiveColumns: View {
    let options: [MenuOption]
    @State private var bottonPressed: MenuOption?

    init(options: [MenuOption] = MenuOption.allCases) {
        self.options = options
    }

    private var overallGridPadding: CGFloat { Constans.spacing }

    @Namespace private var namespace

    var body: some View {
        GeometryReader { geometry in
            let gridContentAreaWidth = geometry.size.width - (overallGridPadding * 2)
            let gridContentAreaHeight = geometry.size.height - (overallGridPadding * 2)
            let safeGridContentAreaWidth = max(0, gridContentAreaWidth)
            let safeGridContentAreaHeight = max(0, gridContentAreaHeight)

            let numCols = calculateNumberOfColumns(
                availableWidth: safeGridContentAreaWidth,
                availableHeight: safeGridContentAreaHeight,
                itemWidth: Constans.buttonSize,
                itemHeight: Constans.buttonSize,
                itemSpacing: Constans.spacing,
                itemCount: options.count
            )
            let columns: [GridItem] = Array(
                repeating: GridItem(.flexible(), spacing: Constans.spacing),
                count: numCols
            )

            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: Constans.spacing
            ) {
                ForEach(options) { option in
                    Image(systemName: option.image)
                        .font(.system(size: Constans.buttonSize * 0.45))
                        .frame(width: Constans.buttonSize, height: Constans.buttonSize)
                        .background(Color.cyan.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .matchedGeometryEffect(id: option.image, in: namespace)
                        .onTapGesture {
                            bottonPressed = option
                        }
                }
            }
            .padding(overallGridPadding)
            .frame(maxWidth: .infinity)
            .animation(.default, value: numCols)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    // MARK: - Calculation

    private func calculateNumberOfColumns(
        availableWidth: CGFloat,
        availableHeight: CGFloat,
        itemWidth: CGFloat,
        itemHeight: CGFloat,
        itemSpacing: CGFloat,
        itemCount: Int
    ) -> Int {
        guard itemCount > 0 else { return 1 } // Default to 1 column if no items
        guard itemWidth > 0, itemHeight > 0 else { return 1 } // Invalid item dimensions

        // Try to find the fewest number of columns (numProposedCols)
        // such that all items fit within availableWidth and availableHeight.
        for numProposedCols in 1...itemCount {
            // Calculate number of rows needed for this many columns
            let numRows = Int(ceil(Double(itemCount) / Double(numProposedCols)))

            // Calculate total width required for items and their spacing
            let requiredGridWidth = (Double(numProposedCols) * Double(itemWidth)) + (max(0.0, Double(numProposedCols) - 1.0) * Double(itemSpacing))
            let requiredGridHeight = (Double(numRows) * Double(itemHeight)) + (max(0.0, Double(numRows) - 1.0) * Double(itemSpacing))

            // If this configuration fits both horizontally and vertically
            if requiredGridWidth <= availableWidth && requiredGridHeight <= availableHeight {
                return numProposedCols // This is the fewest columns that fit everything.
            }
        }

        // Fallback: If no configuration fits all items perfectly within the given available space.
        // Choose the maximum number of columns that can fit horizontally, allowing vertical scrolling.
        var maxColsFitHorizontally: Int
        // Formula: N * itemWidth + (N-1) * itemSpacing <= availableWidth
        //      => N * (itemWidth + itemSpacing) - itemSpacing <= availableWidth
        //      => N <= (availableWidth + itemSpacing) / (itemWidth + itemSpacing)
        if (itemWidth + itemSpacing) <= 0 { // Avoid division by zero or negative/zero denominator
            maxColsFitHorizontally = (itemWidth > 0) ? Int(floor(availableWidth / itemWidth)) : 0
        } else {
            maxColsFitHorizontally = Int(floor((availableWidth + itemSpacing) / (itemWidth + itemSpacing)))
        }

        // Ensure at least 1 column, and not more columns than there are items.
        return max(1, min(maxColsFitHorizontally, itemCount))
    }
}

// MARK: - Preview
#Preview {
    HomeViewAdaptiveColumns()
}
