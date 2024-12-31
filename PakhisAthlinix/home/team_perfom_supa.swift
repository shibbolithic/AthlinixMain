//import SwiftUI
//import Supabase
//
//struct MatchGraphView: View {
//    @State private var scores: [GameLogtable] = []
//    @State private var isLoading = true
//
//    let athleteID: String
//
//    var body: some View {
//        VStack {
//            Text("Performance Over Time")
//                .font(.headline)
//
//            if isLoading {
//                ProgressView()
//            } else if scores.isEmpty {
//                Text("No match data available")
//            } else {
//                LineGraph(data: scores.map { $0.totalPoints })
//                    .frame(height: 200)
//                    .padding()
//            }
//        }
//        .onAppear(perform: fetchMatchScores)
//    }
//
//    func fetchMatchScores() {
//        isLoading = true
//        Task {
//            do {
//                let fetchedScores = try await Supabase.database
//                    .from("GameLogtable")
//                    .select("*")
//                    .eq("playerID", athleteID)
//                    .order("gameID", ascending: true)
//                    .decode([GameLogtable].self)
//
//                scores = fetchedScores
//            } catch {
//                print("Error fetching match scores: \(error.localizedDescription)")
//            }
//            isLoading = false
//        }
//    }
//}
