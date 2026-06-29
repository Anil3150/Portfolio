import 'package:portfolio/core/app_constants.dart';
import 'package:portfolio/data/models/portfolio_models.dart';

class PortfolioRepository {
  PortfolioData loadSeedPortfolio() => PortfolioData.fromJson(_seedData);
}

final Map<String, dynamic> _seedData = {
  'profile': {
    'name': 'Anil Kumar Malipeddi',
    'designation': 'Flutter Developer',
    'summary':
        'Flutter Developer with 2 years of experience building robust, scalable, and high-performance cross-platform mobile applications for Android, iOS, and web. Strong in GetX, Clean Architecture, Dio based REST APIs, performance optimization, and responsive user interfaces.',
    'location': 'Nagarkurnool, Telangana',
    'email': 'malipeddianilkumar3150@gmail.com',
    'phone': '+91 9059141362',
    'linkedIn': 'https://www.linkedin.com/in/anil-kumar-malipeddi-149034266/?skipRedirect=true',
    'github': '',
    'profileImage': AppConstants.profileImagePath,
    'resumeFileName': 'Anil_Malipeddi_resume.docx',
    'yearsOfExperience': 2,
    'roles': [
      'Flutter Developer',
      'GetX Specialist',
      'Mobile App Engineer',
      'Clean Architecture Practitioner',
    ],
  },
  'highlights': [
    'Lead development of cross-platform Flutter applications with GetX and Clean Architecture.',
    'Built modular data, domain, and presentation layers to reduce technical debt.',
    'Optimized rebuilds, lazy loading, video playback, and API reliability for production apps.',
    'Collaborated with product and UI/UX teams to ship responsive, pixel-perfect interfaces.',
  ],
  'skillCategories': [
    {
      'title': 'Mobile Engineering',
      'skills': ['Flutter', 'Dart', 'Android', 'iOS', 'Web', 'Responsive UI'],
      'strength': .94,
    },
    {
      'title': 'Architecture',
      'skills': [
        'GetX',
        'Clean Architecture',
        'MVVM',
        'SOLID',
        'Reusable Widgets',
      ],
      'strength': .9,
    },
    {
      'title': 'Backend Integration',
      'skills': [
        'Dio',
        'REST APIs',
        'JWT Auth',
        'Firebase',
        'Socket.IO',
        'FCM',
      ],
      'strength': .86,
    },
    {
      'title': 'Tooling',
      'skills': [
        'Git',
        'GitHub',
        'Android Studio',
        'VS Code',
        'ChatGPT',
        'Cursor',
      ],
      'strength': .82,
    },
  ],
  'experiences': [
    {
      'company': 'HashStack Solutions',
      'role': 'Software Engineer (Flutter)',
      'duration': 'Apr 2024 - Present',
      'location': 'Visakhapatnam',
      'achievements': [
        'Led cross-platform app development with Flutter, Dart, GetX, and Clean Architecture.',
        'Implemented Dio API layers with interceptors, token auth, logging, and error handling.',
        'Reduced unnecessary widget rebuilds through refactoring and SOLID design.',
        'Participated in sprint planning, estimation, code reviews, and UI implementation.',
      ],
    },
  ],
  'projects': [
    {
      'title': 'Dhenusya Rider',
      'description':
          'Multi-role dairy delivery and milk collection app for riders, collection agents, and farmers.',
      'technologies': ['Flutter', 'GetX', 'Firebase', 'JWT APIs', 'FCM'],
      'highlights': [
        'Built role-based access, order tracking, proof of delivery, and collection reports.',
        'Integrated push notifications, Firebase Analytics, OTP auth, and wallet flows.',
        'Added attendance and leave management with calendar-based tracking.',
      ],
    },
    {
      'title': 'CMA',
      'description':
          'Property listing and video streaming app with multi-step listing flows.',
      'technologies': ['Flutter', 'GetX', 'Dio', 'YouTube', 'Video Streaming'],
      'highlights': [
        'Created video upload, playback, compression, and visibility-based playback control.',
        'Built property CRUD, discover feeds, filters, OTP auth, and profile management.',
        'Used shimmer loaders and lazy loading for smooth media-heavy UX.',
      ],
    },
    {
      'title': 'Bizztiny',
      'description':
          'Marketplace for businesses, commercial properties, and franchise listings.',
      'technologies': [
        'Flutter',
        'GetX',
        'Socket.IO',
        'WebView',
        'Localization',
      ],
      'highlights': [
        'Implemented real-time buyer-seller chat and multi-auth sign-in.',
        'Built listing promotion payments, advanced search, filters, and saved listings.',
        'Added PDF generation, media management, transaction history, and theming.',
      ],
    },
    {
      'title': 'Secure Your Land',
      'description':
          'Full-stack property and services platform with bookings, payments, and maps.',
      'technologies': [
        'Flutter',
        'GetX',
        'Dio',
        'Google Maps',
        'Razorpay',
        'Cashfree',
      ],
      'highlights': [
        'Delivered property CRUD, service bookings, transaction receipts, and chat.',
        'Integrated payments, token refresh, Google Sign-In, push notifications, and badges.',
        'Added geolocation and address autocomplete for onboarding and location flows.',
      ],
    },
    {
      'title': 'Agri Insights',
      'description':
          'Responsive agriculture insights app focused on clean architecture and fast data loading.',
      'technologies': ['Flutter', 'GetX', 'LayoutBuilder', 'Dio', 'REST APIs'],
      'highlights': [
        'Implemented Clean Architecture with GetX state management.',
        'Achieved responsive layouts across device classes.',
        'Optimized performance via lazy loading and custom widgets.',
      ],
    },
  ],
  'education': [
    {
      'degree':
          'Bachelor of Technology (B.Tech), Electronics and Communication Engineering',
      'institution': "St. Peter's Engineering College, Hyderabad",
      'duration': 'July 2018 - August 2022',
      'grade': '',
    },
  ],
  'certifications': [
    {'title': 'Java Programming', 'issuer': 'Naresh Technologies', 'date': ''},
    {'title': 'Oracle Database', 'issuer': 'Naresh Technologies', 'date': ''},
  ],
  'services': [
    {
      'title': 'Mobile App Development',
      'description':
          'Cross-platform Flutter apps for Android, iOS, web, and desktop.',
    },
    {
      'title': 'Backend Integration',
      'description':
          'REST APIs, Dio clients, auth flows, interceptors, and secure storage.',
    },
    {
      'title': 'UI/UX Implementation',
      'description':
          'Responsive, polished interfaces translated from product and design needs.',
    },
    {
      'title': 'Firebase Services',
      'description':
          'FCM, Analytics, OTP support, and app event instrumentation.',
    },
    {
      'title': 'API Integration',
      'description':
          'Reliable third-party integrations, payments, maps, chat, and video flows.',
    },
  ],
  'testimonials': [
    {
      'quote':
          'Anil brings calm execution, clean Flutter patterns, and a strong eye for responsive UI details.',
      'author': 'Project Stakeholder',
      'role': 'Product Collaboration',
    },
    {
      'quote':
          'His GetX and API integration work helped convert complex requirements into maintainable mobile features.',
      'author': 'Engineering Lead',
      'role': 'Mobile Delivery',
    },
  ],
};
