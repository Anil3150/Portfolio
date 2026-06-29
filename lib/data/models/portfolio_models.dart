class PortfolioProfile {
  final String name;
  final String designation;
  final String summary;
  final String location;
  final String email;
  final String phone;
  final String linkedIn;
  final String github;
  final String profileImage;
  final String resumeFileName;
  final double yearsOfExperience;
  final List<String> roles;

  const PortfolioProfile({
    required this.name,
    required this.designation,
    required this.summary,
    required this.location,
    required this.email,
    required this.phone,
    required this.linkedIn,
    required this.github,
    required this.profileImage,
    required this.resumeFileName,
    required this.yearsOfExperience,
    required this.roles,
  });

  factory PortfolioProfile.fromJson(Map<String, dynamic> json) {
    return PortfolioProfile(
      name: json['name'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      location: json['location'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      linkedIn: json['linkedIn'] as String? ?? '',
      github: json['github'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      resumeFileName: json['resumeFileName'] as String? ?? '',
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toDouble() ?? 0,
      roles: List<String>.from(json['roles'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'designation': designation,
    'summary': summary,
    'location': location,
    'email': email,
    'phone': phone,
    'linkedIn': linkedIn,
    'github': github,
    'profileImage': profileImage,
    'resumeFileName': resumeFileName,
    'yearsOfExperience': yearsOfExperience,
    'roles': roles,
  };

  PortfolioProfile copyWith({
    String? name,
    String? designation,
    String? summary,
    String? location,
    String? email,
    String? phone,
    String? linkedIn,
    String? github,
    String? profileImage,
    String? resumeFileName,
    double? yearsOfExperience,
    List<String>? roles,
  }) {
    return PortfolioProfile(
      name: name ?? this.name,
      designation: designation ?? this.designation,
      summary: summary ?? this.summary,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      profileImage: profileImage ?? this.profileImage,
      resumeFileName: resumeFileName ?? this.resumeFileName,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      roles: roles ?? this.roles,
    );
  }
}

class SkillCategory {
  final String title;
  final List<String> skills;
  final double strength;

  const SkillCategory({
    required this.title,
    required this.skills,
    required this.strength,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) => SkillCategory(
    title: json['title'] as String? ?? '',
    skills: List<String>.from(json['skills'] as List? ?? const []),
    strength: (json['strength'] as num?)?.toDouble() ?? .7,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'skills': skills,
    'strength': strength,
  };
}

class ExperienceItem {
  final String company;
  final String role;
  final String duration;
  final String location;
  final List<String> achievements;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.duration,
    required this.location,
    required this.achievements,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) => ExperienceItem(
    company: json['company'] as String? ?? '',
    role: json['role'] as String? ?? '',
    duration: json['duration'] as String? ?? '',
    location: json['location'] as String? ?? '',
    achievements: List<String>.from(json['achievements'] as List? ?? const []),
  );

  Map<String, dynamic> toJson() => {
    'company': company,
    'role': role,
    'duration': duration,
    'location': location,
    'achievements': achievements,
  };
}

class ProjectItem {
  final String title;
  final String description;
  final List<String> technologies;
  final List<String> highlights;
  final String githubUrl;
  final String demoUrl;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.technologies,
    required this.highlights,
    this.githubUrl = '',
    this.demoUrl = '',
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    technologies: List<String>.from(json['technologies'] as List? ?? const []),
    highlights: List<String>.from(json['highlights'] as List? ?? const []),
    githubUrl: json['githubUrl'] as String? ?? '',
    demoUrl: json['demoUrl'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'technologies': technologies,
    'highlights': highlights,
    'githubUrl': githubUrl,
    'demoUrl': demoUrl,
  };
}

class EducationItem {
  final String degree;
  final String institution;
  final String duration;
  final String grade;

  const EducationItem({
    required this.degree,
    required this.institution,
    required this.duration,
    this.grade = '',
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) => EducationItem(
    degree: json['degree'] as String? ?? '',
    institution: json['institution'] as String? ?? '',
    duration: json['duration'] as String? ?? '',
    grade: json['grade'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'degree': degree,
    'institution': institution,
    'duration': duration,
    'grade': grade,
  };
}

class CertificationItem {
  final String title;
  final String issuer;
  final String date;

  const CertificationItem({
    required this.title,
    required this.issuer,
    this.date = '',
  });

  factory CertificationItem.fromJson(Map<String, dynamic> json) =>
      CertificationItem(
        title: json['title'] as String? ?? '',
        issuer: json['issuer'] as String? ?? '',
        date: json['date'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'issuer': issuer,
    'date': date,
  };
}

class ServiceItem {
  final String title;
  final String description;

  const ServiceItem({required this.title, required this.description});

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'title': title, 'description': description};
}

class TestimonialItem {
  final String quote;
  final String author;
  final String role;

  const TestimonialItem({
    required this.quote,
    required this.author,
    required this.role,
  });

  factory TestimonialItem.fromJson(Map<String, dynamic> json) =>
      TestimonialItem(
        quote: json['quote'] as String? ?? '',
        author: json['author'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'quote': quote,
    'author': author,
    'role': role,
  };
}

class PortfolioData {
  final PortfolioProfile profile;
  final List<String> highlights;
  final List<SkillCategory> skillCategories;
  final List<ExperienceItem> experiences;
  final List<ProjectItem> projects;
  final List<EducationItem> education;
  final List<CertificationItem> certifications;
  final List<ServiceItem> services;
  final List<TestimonialItem> testimonials;

  const PortfolioData({
    required this.profile,
    required this.highlights,
    required this.skillCategories,
    required this.experiences,
    required this.projects,
    required this.education,
    required this.certifications,
    required this.services,
    required this.testimonials,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) => PortfolioData(
    profile: PortfolioProfile.fromJson(
      json['profile'] as Map<String, dynamic>? ?? const {},
    ),
    highlights: List<String>.from(json['highlights'] as List? ?? const []),
    skillCategories:
        (json['skillCategories'] as List? ?? const [])
            .map((item) => SkillCategory.fromJson(item as Map<String, dynamic>))
            .toList(),
    experiences:
        (json['experiences'] as List? ?? const [])
            .map(
              (item) => ExperienceItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
    projects:
        (json['projects'] as List? ?? const [])
            .map((item) => ProjectItem.fromJson(item as Map<String, dynamic>))
            .toList(),
    education:
        (json['education'] as List? ?? const [])
            .map((item) => EducationItem.fromJson(item as Map<String, dynamic>))
            .toList(),
    certifications:
        (json['certifications'] as List? ?? const [])
            .map(
              (item) =>
                  CertificationItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
    services:
        (json['services'] as List? ?? const [])
            .map((item) => ServiceItem.fromJson(item as Map<String, dynamic>))
            .toList(),
    testimonials:
        (json['testimonials'] as List? ?? const [])
            .map(
              (item) => TestimonialItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'profile': profile.toJson(),
    'highlights': highlights,
    'skillCategories': skillCategories.map((item) => item.toJson()).toList(),
    'experiences': experiences.map((item) => item.toJson()).toList(),
    'projects': projects.map((item) => item.toJson()).toList(),
    'education': education.map((item) => item.toJson()).toList(),
    'certifications': certifications.map((item) => item.toJson()).toList(),
    'services': services.map((item) => item.toJson()).toList(),
    'testimonials': testimonials.map((item) => item.toJson()).toList(),
  };
}
