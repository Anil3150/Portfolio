class ResumeData {
  static const String name = "Anil Kumar Malipeddi";
  static const String title = "Flutter Developer | Mobile Application Developer";
  static const String email = "malipeddianilkumar3150@gmail.com";
  static const String phone = "+91 9059141362";
  static const String location = "Nagarkurnool, Telangana, India";
  static const String linkedIn = "https://www.linkedin.com/in/anil-kumar-malipeddi-149034266/";
  static const String linkedInDisplay = "linkedin.com/in/anil-kumar-malipeddi";
  static const String portfolioUrl = "portfolio-2iay.onrender.com";
  static const String githubUrl = "https://github.com/Anil3150";
  
  static const String summary = 
      "Results-driven Flutter Developer with 2+ years of experience designing, developing, and deploying scalable cross-platform mobile applications for Android and iOS. Skilled in Dart, the Flutter SDK, Clean Architecture, MVVM, and the Repository Pattern, with strong command of state management (GetX, BLoC). Experienced in REST API integration using Dio, secure authentication (JWT, OAuth, Google Sign-In), payment gateway integration, Firebase services, and end-to-end app deployment to the Google Play Store and Apple App Store. Adept at performance optimization, debugging, and problem-solving within Agile/Scrum teams, with proven ownership of the full mobile delivery lifecycle and Git-based collaboration.";

  static const List<Map<String, dynamic>> stats = [
    {"label": "Years Experience", "value": "2+"},
    {"label": "Apps Delivered", "value": "6+"},
    {"label": "Downloads", "value": "100K+"},
    {"label": "APIs Integrated", "value": "20+"},
  ];

  static const Map<String, List<Map<String, dynamic>>> skills = {
    "Programming Languages": [
      {"name": "Dart", "progress": 0.90},
      {"name": "Java", "progress": 0.75},
      {"name": "SQL", "progress": 0.70},
    ],
    "Frameworks & State Management": [
      {"name": "Flutter", "progress": 0.95},
      {"name": "GetX", "progress": 0.90},
      {"name": "BLoC", "progress": 0.85},
    ],
    "Architecture": [
      {"name": "Clean Architecture", "progress": 0.85},
      {"name": "MVVM", "progress": 0.80},
      {"name": "Repository Pattern", "progress": 0.90},
    ],
    "Backend & Integration": [
      {"name": "REST API (Dio)", "progress": 0.95},
      {"name": "Firebase", "progress": 0.85},
      {"name": "WebSockets/Socket.IO", "progress": 0.80},
    ],
    "Tools": [
      {"name": "Git/GitHub", "progress": 0.90},
      {"name": "VS Code", "progress": 0.95},
      {"name": "Postman", "progress": 0.90},
    ]
  };

  static const List<Map<String, dynamic>> experience = [
    {
      "company": "HashStack Solutions",
      "role": "Software Engineer – Flutter",
      "duration": "Apr 2024 – Present",
      "responsibilities": [
        "Developed and delivered 6 scalable cross-platform mobile applications using Flutter for Android and iOS across logistics, real estate, e-commerce, dairy supply chain, and video streaming domains.",
        "Designed responsive, reusable UI components and Flutter widgets following Material Design guidelines, ensuring pixel-perfect rendering across multiple screen sizes and devices.",
        "Integrated REST APIs using Dio with a centralized HTTP client, custom interceptors for JWT token injection, and robust global error handling across Dev, QA, and Prod environments.",
        "Implemented GetX and BLoC state management with lazy-loaded dependency injection to improve application performance, scalability, and maintainability.",
        "Built secure authentication using JWT, OAuth 2.0, OTP verification, and Google Sign-In, with encrypted session management.",
        "Integrated payment gateways including Razorpay, Cashfree, and Stripe with secure webhook and callback handling for checkout, wallet top-ups, and subscription billing.",
        "Configured Firebase Cloud Messaging (FCM) and Push Notifications for real-time order alerts and payment confirmations with accurate foreground/background message routing.",
        "Implemented deep linking and universal linking to power marketing campaigns, product navigation, and seamless cross-app user journeys.",
        "Optimized application startup time, rendering performance, and memory usage through image caching, shimmer states, and on-device video compression, sustaining 60 FPS on low-end Android devices.",
        "Published multiple production applications to the Google Play Store and Apple App Store, managing build flavors, app signing, and multi-environment release cycles.",
        "Collaborated with UI/UX designers, QA engineers, and backend developers in an Agile/Scrum environment; led sprint planning, technical estimation, and code reviews.",
        "Resolved critical production issues and eliminated unhandled network exceptions by standardizing Dartz functional error handling, achieving near-zero production crash rates."
      ],
      "technologies": ["Flutter", "Dart", "GetX", "BLoC", "Clean Architecture", "Dio", "Socket.IO", "Firebase", "Razorpay", "Cashfree", "Google Maps"]
    }
  ];

  static const List<Map<String, dynamic>> projects = [
    {
      "title": "U-Need Business",
      "category": "Logistics & Delivery Platform",
      "company": "HashStack Solutions",
      "description": "Consolidated two separate application contexts (Vendor Business Management and Rider Delivery Operations) into a single optimized Flutter codebase using feature-based Clean Architecture.",
      "technologies": ["Flutter", "GetX", "Clean Architecture", "Socket.IO", "Google Maps SDK", "Cashfree", "Dio", "Dartz"],
      "features": [
        "Real-time order tracking and dispatch with WebSockets",
        "Google Maps SDK integration",
        "Reduced delivery turnaround time"
      ],
      "image": "assets/projects/uneed.png", // Placeholder
      "link": "#"
    },
    {
      "title": "Bizztiny Marketplace",
      "category": "E-Commerce Application",
      "company": "HashStack Solutions",
      "description": "Powered real-time peer-to-peer negotiation messaging via Socket.IO with reactive GetX UI updates and zero message loss.",
      "technologies": ["Flutter", "GetX", "Socket.IO", "WebView", "Google Sign-In", "LinkedIn OAuth", "PDF Generation"],
      "features": [
        "Multi-provider authentication",
        "Encrypted JWT sessions",
        "Automated bilingual PDF invoice generation"
      ],
      "image": "assets/projects/bizztiny.png", // Placeholder
      "link": "#"
    },
    {
      "title": "Secure Your Land & Agent Apps",
      "category": "Real Estate Platform",
      "company": "HashStack Solutions",
      "description": "Built a Socket.IO real-time chat module with read/unread status and automatic reconnection, plus a dynamic service quoting engine.",
      "technologies": ["Flutter", "GetX", "Socket.IO", "Google Maps SDK", "Razorpay", "Cashfree", "PDF Generation"],
      "features": [
        "Auto-generates and emails PDF service contracts",
        "Secure in-app service payments with Razorpay/Cashfree",
        "Confirmation callbacks and transaction history tracking"
      ],
      "image": "assets/projects/syl.png", // Placeholder
      "link": "#"
    },
    {
      "title": "Dhanusya Franchise",
      "category": "Wallet & Supply Chain App",
      "company": "HashStack Solutions",
      "description": "Architected a Domain-Driven Design Flutter app supporting 5 distinct user roles with role-based UI rendering and OTP-based JWT authentication.",
      "technologies": ["Flutter", "Clean Architecture", "GetX", "Dio", "Firebase FCM", "JWT", "OTP Authentication"],
      "features": [
        "Digital wallet for real-time financial tracking",
        "Automated payouts based on daily collection metrics",
        "Paginated multi-filter reporting module"
      ],
      "image": "assets/projects/dhanusya.png", // Placeholder
      "link": "#"
    },
    {
      "title": "CMA",
      "category": "Video Streaming Platform",
      "company": "HashStack Solutions",
      "description": "Developed a hybrid video playback engine integrating native MP4/HLS streams and embedded YouTube content within a unified UI context.",
      "technologies": ["Flutter", "GetX", "Better Player", "YouTube Player", "Firebase", "Video Compress"],
      "features": [
        "On-device video compression pipeline (60% bandwidth reduction)",
        "Visibility-based playback control to prevent memory leaks"
      ],
      "image": "assets/projects/cma.png", // Placeholder
      "link": "#"
    }
  ];

  static const List<Map<String, dynamic>> education = [
    {
      "degree": "Bachelor of Technology (B.Tech) – Electronics & Communication Engineering",
      "college": "St. Peter’s Engineering College, Hyderabad",
      "year": "Jul 2018 – Aug 2022",
      "cgpa": "N/A"
    }
  ];

  static const List<String> achievements = [
    "Shipped 6 production Flutter applications across 5+ business domains within 2+ years, each deployed to the Google Play Store and Apple App Store.",
    "Reduced server bandwidth consumption by 60% through an on-device video compression pipeline on the CMA streaming platform.",
    "Achieved near-zero unhandled production exceptions by standardizing Dartz functional error handling across all team projects.",
    "Integrated 3 distinct payment gateways (Razorpay, Cashfree, WebView) and a custom digital wallet system across multiple production apps."
  ];

  static const String declaration = 
      "I hereby declare that the information provided above is true and accurate to the best of my knowledge and belief. All details mentioned herein are genuine and I take full responsibility for their authenticity.";

  static const List<Map<String, dynamic>> services = [
    {
      "title": "Flutter App Development",
      "description": "Building high-performance, beautiful cross-platform apps for iOS and Android from a single codebase.",
      "icon": "flutter_icon" // Use string identifiers for now
    },
    {
      "title": "API Integration",
      "description": "Seamlessly connecting mobile applications with RESTful APIs, WebSockets, and backend services.",
      "icon": "api_icon"
    },
    {
      "title": "UI/UX Implementation",
      "description": "Translating Figma designs into pixel-perfect, responsive, and animated Flutter interfaces.",
      "icon": "ui_icon"
    },
    {
      "title": "Payment Integration",
      "description": "Integrating secure payment gateways like Razorpay, Cashfree, and Stripe.",
      "icon": "payment_icon"
    }
  ];
}
