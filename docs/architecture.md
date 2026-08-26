# DisasterOps AI – System Architecture

## 1. Project Overview

DisasterOps AI is an AI-powered disaster response and rescue coordination system.

The system coordinates citizen SOS requests, AI-based priority classification, rescue team recommendation, resource allocation, mission tracking, GIS visualization, SMS-based emergency reporting, and disaster analytics.

## 2. High-Level Architecture

Citizen / Admin
        ↓
React Frontend
        ↓
Flask REST API
        ↓
Business Logic
        ↓
MySQL Database
        ↓
AI/ML Prediction Service

External/Supporting Components:
- Leaflet + OpenStreetMap for maps
- SMS interface for emergency fallback
- Python ML models for priority prediction

## 3. Main Modules

### Citizen Module
- Citizen registration/login
- SOS submission
- Location capture
- SOS status tracking

### Admin Module
- Emergency monitoring
- SOS review
- Priority review/override
- Rescue team assignment
- Resource allocation
- Mission monitoring
- Reports and analytics

### AI/ML Module
- Disaster priority classification
- Priority confidence
- Model evaluation
- Prediction integration

### Rescue Operations Module
- Rescue team management
- Team availability
- Team specialization
- Team recommendation
- Resource recommendation
- Mission management

### GIS Module
- SOS locations
- Rescue team locations
- Shelter locations
- Map visualization

### SMS Module
- SMS emergency request parsing
- Conversion of valid SMS requests into SOS requests
- Integration with the normal SOS processing pipeline