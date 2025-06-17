class AppConstants {
  // SharedPreferences keys
  static const String prefRelationship = 'relationship';
  static const String prefMemories = 'memories';
  static const String prefMilestones = 'milestones';
  static const String prefTrips = 'trips';
  static const String prefCartoons = 'cartoons';
  static const String prefUserProfile = 'user_profile';

  // Default values
  static const String defaultUserName = 'Me';
  static const String defaultPartnerName = 'Partner';

  // Milestone types
  static const String milestoneBirthday = 'birthday';
  static const String milestoneAnniversary = 'anniversary';
  static const String milestoneValentine = 'valentine';

  // Error messages
  static const String errorRelationshipNotSet =
      'Please set up your relationship information first';
  static const String errorDateInvalid = 'Invalid date';
  static const String errorImageGeneration =
      'Image generation failed, please try again';
  static const String errorApiConnection =
      'Failed to connect to AI service, please check your internet connection';

  // Tip messages
  static const String tipPackingReminder =
      'Departing tomorrow, please pack your luggage!';
  static const String tipCartoonGeneration =
      'The more detailed your description, the better the generated image';
  static const String tipAiGeneration =
      'For best results, describe the scene, atmosphere, lighting, and style';

  // AI Generation
  static const String aiModelName = 'Kwai-Kolors/Kolors';
  static const String aiImageSize = '1024x1024';
  static const int aiSeed = 4999999999;
  static const int aiSteps = 20;
  static const double aiGuidance = 7.5;
}
