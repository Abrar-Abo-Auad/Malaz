# malaz_v1
    TODO :  write the project description

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Project Structure

````
lib/
├── main.dart                     
├── injection_container.dart       
│
├── core/                          
│   ├── network/                    
│   │   ├── api_client.dart       
│   │   └── network_info.dart    
│   ├── error/                      
│   │   ├── failures.dart        
│   │   └── exceptions.dart        
│   ├── usecases/                  
│   │   └── usecase.dart            
│   └── config/                      
│
├── presentation/                  
│   ├── screens/                 
│   │   ├── auth/                  
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── home/                 
│   │       └── home_screen.dart
│   │
│   ├── cubits/                 
│   │   ├── auth/                   
│   │   │   ├── auth_cubit.dart    
│   │   │   └── auth_state.dart    
│   │   └── booking/              
│   │
│   └── widgets/                   
│       ├── custom_button.dart
│       └── custom_text_field.dart
│
├── domain/                      
│   ├── entities/                  
│   │   ├── user.dart              
│   │   └── apartment.dart         
│   │
│   ├── repositories/             
│   │   ├── auth_repository.dart   
│   │   └── booking_repository.dart 
│   │
│   └── usecases/                
│       ├── auth/
│       │   ├── login_usecase.dart  
│       │   └── logout_usecase.dart
│       └── booking/
│           └── book_apartment_usecase.dart
│
└── data/                      
    ├── models/                    
    │   ├── user_model.dart        
    │   └── apartment_model.dart 
    │  
    ├── datasources/               
    │   ├── remote/               
    │   │   └── auth_remote_data_source.dart 
    │   └── local/                
    │       └── auth_local_data_source.dart  
    │
    └── repositories/              
        ├── auth_repository_impl.dart   
        └── booking_repository_impl.dart