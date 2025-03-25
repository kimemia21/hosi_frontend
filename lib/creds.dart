import 'package:frontend/requests/Comms.dart';

final String baseUrl = "http://192.168.88.216:3000";
final String serverUrl = "http://185.141.63.56:7000";
Comms comms = Comms();


  List<String> hospitalStaff = [
    // Medical Staff
    "General Practitioners",
    "Surgeons",
    "Anesthesiologists",
    "Pediatricians",
    "Psychiatrists",
    "Registered Nurses",
    "Nurse Practitioners",
    "Clinical Nurse Specialists",
    "Radiologists",
    "Laboratory Technicians",
    "Respiratory Therapists",
    "Pharmacists",
    "Medical Technicians (X-ray, MRI, CT scan)",

    // Support Staff
    "Medical Assistants",
    "Phlebotomists",
    "Emergency Medical Technicians",
    "Hospital Administrators",
    "Medical Secretaries",
    "Billing and Coding Specialists",
    "Receptionists",
    "Janitors / Housekeeping Staff",
    "Maintenance Technicians",
    "Security Guards",
    "Patient Transporters",
    "Volunteers",
    
    // Allied Health Professionals
    "Physiotherapists",
    "Occupational Therapists",
    "Speech-Language Pathologists",
    "Dietitians / Nutritionists",
    
    // Other Specialized Roles
    "Social Workers",
    "Chaplain / Clergy",
  ];