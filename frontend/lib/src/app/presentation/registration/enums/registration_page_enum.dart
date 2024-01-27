enum RegistrationPageSection {
  login,
  location,
  radius,
  nameEmail,
  genderPreference,
  pictures,
  interests,
  jobBio,
  summary,
  submit
}

extension RegistrationPageNavigation on RegistrationPageSection {
  RegistrationPageSection get predecessor {
    switch(this) {
      case RegistrationPageSection.location:
        return RegistrationPageSection.login;
      case RegistrationPageSection.radius:
        return RegistrationPageSection.location;
      case RegistrationPageSection.nameEmail:
        return RegistrationPageSection.radius;
      case RegistrationPageSection.genderPreference:
        return RegistrationPageSection.nameEmail;
      case RegistrationPageSection.pictures:
        return RegistrationPageSection.genderPreference;
      case RegistrationPageSection.interests:
        return RegistrationPageSection.pictures;
      case RegistrationPageSection.jobBio:
        return RegistrationPageSection.interests;
      case RegistrationPageSection.summary:
        return RegistrationPageSection.jobBio;
      default:
        return RegistrationPageSection.login;
    }
  }

  RegistrationPageSection get successor {
    switch(this) {
      case RegistrationPageSection.location:
        return RegistrationPageSection.radius;
      case RegistrationPageSection.radius:
        return RegistrationPageSection.nameEmail;
      case RegistrationPageSection.nameEmail:
        return RegistrationPageSection.genderPreference;
      case RegistrationPageSection.genderPreference:
        return RegistrationPageSection.pictures;
      case RegistrationPageSection.pictures:
        return RegistrationPageSection.interests;
      case RegistrationPageSection.interests:
        return RegistrationPageSection.jobBio;
      case RegistrationPageSection.jobBio:
        return RegistrationPageSection.summary;
      case RegistrationPageSection.summary:
        return RegistrationPageSection.submit;
      default:
        return RegistrationPageSection.login;
    }
  }
}
