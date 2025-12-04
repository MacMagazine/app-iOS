//
//  MMAccessibilityUtils.swift
//  MacMagazineLibrary
//
//  Created by Renato Ferraz Castelo Branco Ferreira on 04/12/25.
//


public enum AccessibilityUtils {
    public static func spokenDuration(from formatted: String) -> String {
        let parts = formatted.split(separator: ":").map { String($0) }
        
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        if parts.count == 3 {
            hours = Int(parts[0]) ?? 0
            minutes = Int(parts[1]) ?? 0
            seconds = Int(parts[2]) ?? 0
        } else if parts.count == 2 {
            minutes = Int(parts[0]) ?? 0
            seconds = Int(parts[1]) ?? 0
        } else if parts.count == 1 {
            seconds = Int(parts[0]) ?? 0
        }
        
        var chunks: [String] = []
        if hours > 0 {
            chunks.append("\(hours) " + (hours == 1 ? "hora" : "horas"))
        }
        if minutes > 0 {
            chunks.append("\(minutes) " + (minutes == 1 ? "minuto" : "minutos"))
        }
        if seconds > 0 {
            chunks.append("\(seconds) " + (seconds == 1 ? "segundo" : "segundos"))
        }
        
        if chunks.isEmpty {
            return "0 segundos"
        }
        
        if chunks.count == 1 {
            return chunks[0]
        } else if chunks.count == 2 {
            return chunks.joined(separator: " e ")
        } else {
            return chunks[0] + ", " + chunks[1] + " e " + chunks[2]
        }
    }
    
    public static func join(_ parts: [String?]) -> String {
        parts
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}
