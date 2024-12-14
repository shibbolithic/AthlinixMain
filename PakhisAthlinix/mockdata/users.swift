//
//  users.swift
//  AkshitasAthlinix
//
//  Created by admin65 on 13/12/24.
//
import Foundation

// Sample Data for Users, AthleteProfiles, and CoachProfiles

// MARK: Users
var users: [User] = [
    User(userID: "1", username: "arvind12", name: "Arvind Kumar", email: "arvind@example.com", password: "password123", role: .athlete, profilePicture: "profilePic1.jpg", bio: "Basketball enthusiast", dateJoined: Date()),
    User(userID: "2", username: "ravi27", name: "Ravi Shankar", email: "ravi@example.com", password: "password123", role: .athlete, profilePicture: "profilePic2.jpg", bio: "Aspiring footballer", dateJoined: Date()),
    User(userID: "3", username: "neha18", name: "Neha Sharma", email: "neha@example.com", password: "password123", role: .athlete, profilePicture: "profilePic3.jpg", bio: "Track and field athlete", dateJoined: Date()),
    User(userID: "4", username: "mohit32", name: "Mohit Gupta", email: "mohit@example.com", password: "password123", role: .athlete, profilePicture: "profilePic4.jpg", bio: "Cricket lover", dateJoined: Date()),
    User(userID: "5", username: "priya09", name: "Priya Mehta", email: "priya@example.com", password: "password123", role: .athlete, profilePicture: "profilePic5.jpg", bio: "Fitness enthusiast", dateJoined: Date()),
    User(userID: "6", username: "coachArjun", name: "Arjun Sinha", email: "arjun@coach.com", password: "coach123", role: .coach, profilePicture: "coachPic1.jpg", bio: "Experienced basketball coach", dateJoined: Date()),
    User(userID: "7", username: "coachManish", name: "Manish Kumar", email: "manish@coach.com", password: "coach123", role: .coach, profilePicture: "coachPic2.jpg", bio: "Football coach with 10 years of experience", dateJoined: Date())
]

var athleteProfiles: [AthleteProfile] = [
    AthleteProfile(athleteID: "1", height: 5.9, weight: 75.0, experience: 5, position: "Guard", averagePointsPerGame: 12.3, averageReboundsPerGame: 4.5, averageAssistsPerGame: 3.2),
    AthleteProfile(athleteID: "2", height: 6.0, weight: 80.0, experience: 4, position: "Midfielder", averagePointsPerGame: 15.4, averageReboundsPerGame: 6.3, averageAssistsPerGame: 4.1),
    AthleteProfile(athleteID: "3", height: 5.6, weight: 55.0, experience: 3, position: "Sprinter", averagePointsPerGame: 0.0, averageReboundsPerGame: 0.0, averageAssistsPerGame: 0.0),
    AthleteProfile(athleteID: "4", height: 5.8, weight: 70.0, experience: 6, position: "All-rounder", averagePointsPerGame: 18.2, averageReboundsPerGame: 8.1, averageAssistsPerGame: 5.4),
    AthleteProfile(athleteID: "5", height: 5.5, weight: 65.0, experience: 2, position: "Forward", averagePointsPerGame: 10.1, averageReboundsPerGame: 4.8, averageAssistsPerGame: 2.7)
]

var coachProfiles: [CoachProfile] = [
    CoachProfile(coachID: "6", yearsOfExperience: 8, specialization: "Basketball", certification: "coachCert1.jpg"),
    CoachProfile(coachID: "7", yearsOfExperience: 10, specialization: "Football", certification: "coachCert2.jpg")
]


// Output for verification
//print("Teams: \(teams)")
//print("Team Memberships: \(teamMemberships)")
//
//
//// Athlete Profiles
///
///// Sample data for users
//var users: [User] = [
//    // Coaches
//    User(userID: "coach1", username: "John_Kumar", name: "John Kumar", email: "john@example.com", password: "password123", role: .coach, profilePicture: "coach1.jpg", bio: "Experienced basketball coach", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "coach2", username: "Rajesh_Singh", name: "Rajesh Singh", email: "smith@example.com", password: "password123", role: .coach, profilePicture: "coach2.jpg", bio: "Football coach with 10+ years of experience", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "coach3", username: "Priya_Sharma", name: "Priya Sharma", email: "amy@example.com", password: "password123", role: .coach, profilePicture: "coach3.jpg", bio: "Passionate coach with focus on basketball", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "coach4", username: "Vijay_Mehta", name: "Vijay Mehta", email: "mark@example.com", password: "password123", role: .coach, profilePicture: "coach4.jpg", bio: "Coach and mentor for soccer teams", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "coach5", username: "Neha_Patel", name: "Neha Patel", email: "lisa@example.com", password: "password123", role: .coach, profilePicture: "coach5.jpg", bio: "Dedicated coach for youth athletes", dateJoined: Date(), lastLogin: Date()),
//    
//    // Athletes
//    User(userID: "athlete1", username: "Amit_Sharma", name: "Amit Sharma", email: "mike@example.com", password: "password123", role: .athlete, profilePicture: "athlete1.jpg", bio: "Basketball player focused on performance", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "athlete2", username: "Sonia_Gupta", name: "Sonia Gupta", email: "sarah@example.com", password: "password123", role: .athlete, profilePicture: "athlete2.jpg", bio: "Passionate football player", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "athlete3", username: "Ravi_Desai", name: "Ravi Desai", email: "david@example.com", password: "password123", role: .athlete, profilePicture: "athlete3.jpg", bio: "Professional tennis player", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "athlete4", username: "Priya_Nair", name: "Priya Nair", email: "emma@example.com", password: "password123", role: .athlete, profilePicture: "athlete4.jpg", bio: "Soccer player striving for excellence", dateJoined: Date(), lastLogin: Date()),
//    User(userID: "athlete5", username: "Vikas_Reddy", name: "Vikas Reddy", email: "chris@example.com", password: "password123", role: .athlete, profilePicture: "athlete5.jpg", bio: "Track and field athlete", dateJoined: Date(), lastLogin: Date())
//]
//var athleteProfiles: [AthleteProfile] = [
//    AthleteProfile(athleteID: "athlete1", height: 6.5, weight: 220, experience: 5, position: "Guard", averagePointsPerGame: 15.2, averageReboundsPerGame: 7.4, averageAssistsPerGame: 3.1),
//    AthleteProfile(athleteID: "athlete2", height: 5.8, weight: 150, experience: 3, position: "Forward", averagePointsPerGame: 12.5, averageReboundsPerGame: 4.2, averageAssistsPerGame: 2.5),
//    AthleteProfile(athleteID: "athlete3", height: 6.0, weight: 180, experience: 7, position: "Singles", averagePointsPerGame: 10.8, averageReboundsPerGame: 0, averageAssistsPerGame: 0),
//    AthleteProfile(athleteID: "athlete4", height: 5.6, weight: 140, experience: 4, position: "Midfielder", averagePointsPerGame: 9.3, averageReboundsPerGame: 6.8, averageAssistsPerGame: 5.2),
//    AthleteProfile(athleteID: "athlete5", height: 5.10, weight: 165, experience: 6, position: "Sprinter", averagePointsPerGame: 0, averageReboundsPerGame: 0, averageAssistsPerGame: 0)
//]
//
//// Coach Profiles
//var coachProfiles: [CoachProfile] = [
//    CoachProfile(coachID: "coach1", yearsOfExperience: 15, specialization: "Basketball", certification: "coach1_cert.jpg"),
//    CoachProfile(coachID: "coach2", yearsOfExperience: 10, specialization: "Football", certification: "coach2_cert.jpg"),
//    CoachProfile(coachID: "coach3", yearsOfExperience: 8, specialization: "Basketball", certification: "coach3_cert.jpg"),
//    CoachProfile(coachID: "coach4", yearsOfExperience: 12, specialization: "Soccer", certification: "coach4_cert.jpg"),
//    CoachProfile(coachID: "coach5", yearsOfExperience: 6, specialization: "Athletics", certification: "coach5_cert.jpg")
//]

























//// Example of how users and their profiles relate
//let athleteUser = users.first(where: { $0.userID == "u001" })!
//let athleteProfile = athleteProfiles.first(where: { $0.athleteID == athleteUser.userID })!
//print("Athlete: \(athleteUser.username), Position: \(athleteProfile.position)")
//
//let coachUser = users.first(where: { $0.userID == "u002" })!
//let coachProfile = coachProfiles.first(where: { $0.coachID == coachUser.userID })!
//print("Coach: \(coachUser.username), Specialization: \(coachProfile.specialization)")
