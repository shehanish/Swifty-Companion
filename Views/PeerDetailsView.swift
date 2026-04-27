//
//  PeerDetailsView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 11.04.26.
//

import SwiftUI

struct PeerDetailsView: View {
    @ObservedObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    let navyBlue = Color(red: 0.04, green: 0.15, blue: 0.33)
    
    // 0 = Info, 1 = Projects, 2 = Skills
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            if let user = authManager.searchedUser {
                VStack {
                    // MARK: - Top Header (Avatar, Name, Title)
                    VStack(spacing: 8) {
                        AsyncImage(url: URL(string: user.image?.link ?? "")) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill").resizable().foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(navyBlue, lineWidth: 3))
                        .shadow(radius: 5)
                        .padding(.top, 10)
                        
                        Text(user.displayname)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Parse and show the user's title (42 formats it as "%login% the Great")
                        if let firstTitle = user.titles?.first?.name {
                            Text(firstTitle.replacingOccurrences(of: "%login%", with: user.login))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Tabs (Info, Projects, Skills)
                    Picker("Details", selection: $selectedTab) {
                        Text("Info").tag(0)
                        Text("Projects").tag(1)
                        Text("Skills").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // MARK: - Tab Content
                    ScrollView {
                        if selectedTab == 0 {
                            // --- INFO TAB ---
                            VStack(spacing: 15) {
                                // Personal Details Card
                                VStack(spacing: 15) {
                                    InfoRow(icon: "person.text.rectangle", title: "Login", value: user.login, color: navyBlue)
                                    Divider()
                                    InfoRow(icon: "envelope.fill", title: "Email", value: user.email, color: navyBlue)
                                    Divider()
                                    if let phone = user.phone, phone != "hidden" {
                                        InfoRow(icon: "phone.fill", title: "Mobile", value: phone, color: navyBlue)
                                        Divider()
                                    }
                                    if let location = user.location {
                                        InfoRow(icon: "mappin.and.ellipse", title: "Location", value: location, color: navyBlue)
                                    } else {
                                        InfoRow(icon: "mappin.slash", title: "Location", value: "Unavailable", color: .gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                
                                // Stats Card
                                HStack(spacing: 20) {
                                    StatBox(title: "Wallet", value: "\(user.wallet) ₳", color: .yellow)
                                    StatBox(title: "Eval Points", value: "\(user.correction_point)", color: .blue)
                                }
                                
                                // Level Card
                                if let mainCursus = user.cursus_users.last {
                                    VStack(spacing: 10) {
                                        Text("\(mainCursus.cursus.name) - Level \(String(format: "%.2f", mainCursus.level))")
                                            .font(.headline)
                                        
                                        ProgressView(value: mainCursus.level.truncatingRemainder(dividingBy: 1.0))
                                            .progressViewStyle(LinearProgressViewStyle(tint: navyBlue))
                                            .scaleEffect(x: 1, y: 2, anchor: .center)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                }
                            }
                            
                        } else if selectedTab == 1 {
                            // --- PROJECTS TAB ---
                            let completedProjects = user.projects_users.filter { $0.status == "finished" }
                            VStack(spacing: 10) {
                                ForEach(completedProjects) { projectUser in
                                    HStack {
                                        Text(projectUser.project.name).font(.subheadline).bold()
                                        Spacer()
                                        if let mark = projectUser.final_mark {
                                            Text("\(mark)").bold().foregroundColor((projectUser.`validated?` ?? false) ? .green : .red)
                                        }
                                        Image(systemName: (projectUser.`validated?` ?? false) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor((projectUser.`validated?` ?? false) ? .green : .red)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                            
                        } else {
                            // --- SKILLS TAB ---
                            if let mainCursus = user.cursus_users.last {
                                VStack(spacing: 10) {
                                    ForEach(mainCursus.skills) { skill in
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Text(skill.name).font(.subheadline).bold()
                                                Spacer()
                                                Text(String(format: "Level %.2f", skill.level)).font(.caption).foregroundColor(.gray)
                                            }
                                            ProgressView(value: skill.level.truncatingRemainder(dividingBy: 1.0))
                                                .progressViewStyle(LinearProgressViewStyle(tint: navyBlue))
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Loading user data...").foregroundColor(.gray)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Search")
                    }
                    .foregroundColor(navyBlue)
                }
            }
        }
    }
}

// MARK: - Helper Views

// A clean row component for the Info Tab
struct InfoRow: View {
    var icon: String
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

// Stats Box Component
struct StatBox: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

