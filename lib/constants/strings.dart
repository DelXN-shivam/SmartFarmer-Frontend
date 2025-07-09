import 'package:flutter/material.dart';

class AppStrings {
  static const Locale english = Locale('en', 'US');
  static const Locale hindi = Locale('hi', 'IN');
  static const Locale marathi = Locale('mr', 'IN');

  static const List<Locale> supportedLocales = [english, hindi, marathi];

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // App Title
      'app_title': 'SmartFarmer',

      // Authentication
      'login': 'Login',
      'logout': 'Logout',
      'select_role': 'Select Role',
      'farmer': 'Farmer',
      'crop_verifier': 'Crop Verifier',
      'admin': 'Admin',

      // Dashboard
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'crops': 'Crops',
      'verifications': 'Verifications',
      'reports': 'Reports',
      'settings': 'Settings',

      // Farmer Side
      'farmer_dashboard': 'Farmer Dashboard',
      'add_new_crop': 'Add New Crop',
      'view_profile': 'View Profile',
      'search_farmers': 'Search Farmers',
      'location_filter': 'Location Filter',
      'crop_details': 'Crop Details',
      'farmer_details': 'Farmer Details',

      // Forms
      'name': 'Name',
      'contact_number': 'Contact Number',
      'aadhaar_number': 'Aadhaar Number',
      'address': 'Address',
      'village': 'Village',
      'landmark': 'Nearby Landmark',
      'taluka': 'Taluka',
      'district': 'District',
      'pincode': 'Pincode',
      'crop_name': 'Crop Name',
      'area': 'Area (Acres)',
      'crop_type': 'Crop Type',
      'soil_type': 'Soil Type',
      'sowing_date': 'Sowing Date',
      'expected_harvest_date': 'Expected Harvest Date',
      'expected_yield': 'Expected Yield',
      'previous_crop': 'Previous Crop',
      'live_location': 'Live Location',
      'upload_images': 'Upload Images',
      'save': 'Save',
      'update': 'Update',
      'cancel': 'Cancel',
      'submit': 'Submit',

      // Crop Verifier Side
      'verifier_dashboard': 'Verifier Dashboard',
      'pending_verifications': 'Pending Verifications',
      'verified_crops': 'Verified Crops',
      'field_verification': 'Field Verification',
      'mark_verified': 'Mark as Verified',
      'mark_rejected': 'Mark as Rejected',
      'verification_comments': 'Verification Comments',
      'upload_verification_images': 'Upload Verification Images',

      // Admin Dashboard
      'admin_dashboard': 'Admin Dashboard',
      'total_farmers': 'Total Farmers',
      'total_crops': 'Total Crops',
      'crop_insights': 'Crop Insights',
      'location_insights': 'Location Insights',
      'export_data': 'Export Data',
      'generate_report': 'Generate Report',

      // AI Insights
      'ai_insights': 'AI Insights',
      'crop_age': 'Crop Age',
      'growth_stage': 'Growth Stage',
      'recommendations': 'Recommendations',
      'days_old': 'days old',
      'days_to_harvest': 'days to harvest',

      // Messages
      'data_saved_successfully': 'Data saved successfully',
      'data_updated_successfully': 'Data updated successfully',
      'verification_completed': 'Verification completed',
      'please_fill_all_fields': 'Please fill all required fields',
      'invalid_aadhaar': 'Invalid Aadhaar number (must be 12 digits)',
      'invalid_pincode': 'Invalid pincode (must be 6 digits)',
      'invalid_phone': 'Invalid phone number (must be 10 digits)',
      'location_permission_required': 'Location permission is required',
      'image_upload_failed': 'Image upload failed',
      'no_data_found': 'No data found',
      'search_farmers_placeholder': 'Search by name or ID...',
      'filter_by_location': 'Filter by location',

      // Status
      'pending': 'Pending',
      'verified': 'Verified',
      'rejected': 'Rejected',

      // Growth Stages
      'germination': 'Germination',
      'vegetative': 'Vegetative',
      'flowering': 'Flowering',
      'fruiting': 'Fruiting',
      'harvesting': 'Harvesting',
      'mature': 'Mature',

      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'view': 'View',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'close': 'Close',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',

      // Additional keys for dashboard screens
      'welcome': 'Welcome',
      'home': 'Home',
      'location': 'Location',
      'quick_actions': 'Quick Actions',
      'recent_crops': 'Recent Crops',
      'no_crops_found': 'No crops found',
      'no_crops_found_filter': 'No crops found matching your filter.',
      'no_crops_for_insights': 'No crops available for insights',
      'add_first_crop': 'Add your first crop',
      'error_loading_crops': 'Error loading crops',
      'edit_profile': 'Edit Profile',
      'add_crop': 'Add Crop',
      'language': 'Language',
      'notifications': 'Notifications',
      'help_support': 'Help & Support',
      'about': 'About',

      // Registration
      'registration': 'Registration',
      'personal_information': 'Personal Information',
      'address_information': 'Address Information',
      'full_name': 'Full Name',
      'name_required': 'Name is required',
      'phone_required': 'Phone number is required',
      'aadhaar_required': 'Aadhaar number is required',
      'village_required': 'Village is required',
      'taluka_required': 'Taluka is required',
      'district_required': 'District is required',
      'pincode_required': 'Pincode is required',
      'register': 'Register',
      'already_have_account': 'Already have an account?',

      // New key for search farmer
      'search_farmer': 'Search Farmer',
      'search_crops': 'Search Crops',
      'view_reports': 'View Reports',
    },
    'hi': {
      // App Title
      'app_title': 'स्मार्ट फार्मर',

      // Authentication
      'login': 'लॉगिन',
      'logout': 'लॉगआउट',
      'select_role': 'भूमिका चुनें',
      'farmer': 'किसान',
      'crop_verifier': 'फसल सत्यापनकर्ता',
      'admin': 'प्रशासक',

      // Dashboard
      'dashboard': 'डैशबोर्ड',
      'profile': 'प्रोफाइल',
      'crops': 'फसलें',
      'verifications': 'सत्यापन',
      'reports': 'रिपोर्ट',
      'settings': 'सेटिंग्स',

      // Farmer Side
      'farmer_dashboard': 'किसान डैशबोर्ड',
      'add_new_crop': 'नई फसल जोड़ें',
      'view_profile': 'प्रोफाइल देखें',
      'search_farmers': 'किसान खोजें',
      'location_filter': 'स्थान फ़िल्टर',
      'crop_details': 'फसल विवरण',
      'farmer_details': 'किसान विवरण',

      // Forms
      'name': 'नाम',
      'contact_number': 'संपर्क संख्या',
      'aadhaar_number': 'आधार संख्या',
      'address': 'पता',
      'village': 'गाँव',
      'landmark': 'निकटवर्ती स्थल',
      'taluka': 'तालुका',
      'district': 'जिला',
      'pincode': 'पिन कोड',
      'crop_name': 'फसल का नाम',
      'area': 'क्षेत्र (एकड़)',
      'crop_type': 'फसल का प्रकार',
      'soil_type': 'मिट्टी का प्रकार',
      'sowing_date': 'बुवाई की तारीख',
      'expected_harvest_date': 'अनुमानित कटाई की तारीख',
      'expected_yield': 'अनुमानित उपज',
      'previous_crop': 'पिछली फसल',
      'live_location': 'लाइव स्थान',
      'upload_images': 'छवियां अपलोड करें',
      'save': 'सहेजें',
      'update': 'अपडेट',
      'cancel': 'रद्द करें',
      'submit': 'सबमिट करें',

      // Crop Verifier Side
      'verifier_dashboard': 'सत्यापनकर्ता डैशबोर्ड',
      'pending_verifications': 'लंबित सत्यापन',
      'verified_crops': 'सत्यापित फसलें',
      'field_verification': 'क्षेत्र सत्यापन',
      'mark_verified': 'सत्यापित के रूप में चिह्नित करें',
      'mark_rejected': 'अस्वीकृत के रूप में चिह्नित करें',
      'verification_comments': 'सत्यापन टिप्पणियां',
      'upload_verification_images': 'सत्यापन छवियां अपलोड करें',

      // Admin Dashboard
      'admin_dashboard': 'प्रशासक डैशबोर्ड',
      'total_farmers': 'कुल किसान',
      'total_crops': 'कुल फसलें',
      'crop_insights': 'फसल अंतर्दृष्टि',
      'location_insights': 'स्थान अंतर्दृष्टि',
      'export_data': 'डेटा निर्यात करें',
      'generate_report': 'रिपोर्ट तैयार करें',

      // AI Insights
      'ai_insights': 'एआई अंतर्दृष्टि',
      'crop_age': 'फसल की आयु',
      'growth_stage': 'विकास चरण',
      'recommendations': 'सिफारिशें',
      'days_old': 'दिन पुराना',
      'days_to_harvest': 'कटाई में दिन',

      // Messages
      'data_saved_successfully': 'डेटा सफलतापूर्वक सहेजा गया',
      'data_updated_successfully': 'डेटा सफलतापूर्वक अपडेट किया गया',
      'verification_completed': 'सत्यापन पूरा हुआ',
      'please_fill_all_fields': 'कृपया सभी आवश्यक फ़ील्ड भरें',
      'invalid_aadhaar': 'अमान्य आधार संख्या (12 अंक होने चाहिए)',
      'invalid_pincode': 'अमान्य पिन कोड (6 अंक होने चाहिए)',
      'invalid_phone': 'अमान्य फोन संख्या (10 अंक होने चाहिए)',
      'location_permission_required': 'स्थान अनुमति आवश्यक है',
      'image_upload_failed': 'छवि अपलोड विफल',
      'no_data_found': 'कोई डेटा नहीं मिला',
      'search_farmers_placeholder': 'नाम या आईडी से खोजें...',
      'filter_by_location': 'स्थान के अनुसार फ़िल्टर करें',

      // Status
      'pending': 'लंबित',
      'verified': 'सत्यापित',
      'rejected': 'अस्वीकृत',

      // Growth Stages
      'germination': 'अंकुरण',
      'vegetative': 'वानस्पतिक',
      'flowering': 'फूलना',
      'fruiting': 'फलना',
      'harvesting': 'कटाई',
      'mature': 'परिपक्व',

      // Common
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'warning': 'चेतावनी',
      'info': 'जानकारी',
      'confirm': 'पुष्टि करें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'view': 'देखें',
      'back': 'वापस',
      'next': 'अगला',
      'previous': 'पिछला',
      'close': 'बंद करें',
      'ok': 'ठीक है',
      'yes': 'हाँ',
      'no': 'नहीं',

      // Additional keys for dashboard screens
      'welcome': 'स्वागत',
      'home': 'घर',
      'location': 'स्थान',
      'quick_actions': 'त्वरित कार्य',
      'recent_crops': 'हाल की फसलें',
      'no_crops_found': 'कोई फसल नहीं मिली',
      'no_crops_found_filter':
          'आपके फ़िल्टर से मेल खाने वाली कोई फसल नहीं मिली।',
      'no_crops_for_insights': 'अंतर्दृष्टि के लिए कोई फसल उपलब्ध नहीं है',
      'add_first_crop': 'अपनी पहली फसल जोड़ें',
      'error_loading_crops': 'फसल लोड करने में त्रुटि',
      'edit_profile': 'प्रोफाइल संपादित करें',
      'add_crop': 'फसल जोड़ें',
      'language': 'भाषा',
      'notifications': 'सूचनाएं',
      'help_support': 'सहायता और समर्थन',
      'about': 'बारे में',

      // Registration
      'registration': 'पंजीकरण',
      'personal_information': 'व्यक्तिगत जानकारी',
      'address_information': 'पता जानकारी',
      'full_name': 'पूरा नाम',
      'name_required': 'नाम आवश्यक है',
      'phone_required': 'फोन नंबर आवश्यक है',
      'aadhaar_required': 'आधार नंबर आवश्यक है',
      'village_required': 'गाँव आवश्यक है',
      'taluka_required': 'तालुका आवश्यक है',
      'district_required': 'जिला आवश्यक है',
      'pincode_required': 'पिन कोड आवश्यक है',
      'register': 'पंजीकरण करें',
      'already_have_account': 'पहले से खाता है?',

      // New key for search farmer
      'search_farmer': 'किसान खोजें',
      'search_crops': 'फसलें खोजें',
      'view_reports': 'रिपोर्ट देखें',
    },
    'mr': {
      // App Title
      'app_title': 'स्मार्ट शेतकरी',

      // Authentication
      'login': 'लॉगिन',
      'logout': 'लॉगआउट',
      'select_role': 'भूमिका निवडा',
      'farmer': 'शेतकरी',
      'crop_verifier': 'पिक सत्यापनकर्ता',
      'admin': 'प्रशासक',

      // Dashboard
      'dashboard': 'डॅशबोर्ड',
      'profile': 'प्रोफाइल',
      'crops': 'पिके',
      'verifications': 'सत्यापन',
      'reports': 'अहवाल',
      'settings': 'सेटिंग्ज',

      // Farmer Side
      'farmer_dashboard': 'शेतकरी डॅशबोर्ड',
      'add_new_crop': 'नवीन पिक जोडा',
      'view_profile': 'प्रोफाइल पहा',
      'search_farmers': 'शेतकरी शोधा',
      'location_filter': 'स्थान फिल्टर',
      'crop_details': 'पिक तपशील',
      'farmer_details': 'शेतकरी तपशील',

      // Forms
      'name': 'नाव',
      'contact_number': 'संपर्क क्रमांक',
      'aadhaar_number': 'आधार क्रमांक',
      'address': 'पत्ता',
      'village': 'गाव',
      'landmark': 'जवळील खुण',
      'taluka': 'तालुका',
      'district': 'जिल्हा',
      'pincode': 'पिन कोड',
      'crop_name': 'पिकाचे नाव',
      'area': 'क्षेत्र (एकर)',
      'crop_type': 'पिकाचा प्रकार',
      'soil_type': 'मातीचा प्रकार',
      'sowing_date': 'पेरणी तारीख',
      'expected_harvest_date': 'अपेक्षित कापणी तारीख',
      'expected_yield': 'अपेक्षित उत्पन्न',
      'previous_crop': 'मागील पिक',
      'live_location': 'लाइव्ह स्थान',
      'upload_images': 'प्रतिमा अपलोड करा',
      'save': 'जतन करा',
      'update': 'अपडेट करा',
      'cancel': 'रद्द करा',
      'submit': 'सबमिट करा',

      // Crop Verifier Side
      'verifier_dashboard': 'सत्यापनकर्ता डॅशबोर्ड',
      'pending_verifications': 'प्रलंबित सत्यापन',
      'verified_crops': 'सत्यापित पिके',
      'field_verification': 'शेत सत्यापन',
      'mark_verified': 'सत्यापित म्हणून चिन्हांकित करा',
      'mark_rejected': 'नाकारले म्हणून चिन्हांकित करा',
      'verification_comments': 'सत्यापन टिप्पण्या',
      'upload_verification_images': 'सत्यापन प्रतिमा अपलोड करा',

      // Admin Dashboard
      'admin_dashboard': 'प्रशासक डॅशबोर्ड',
      'total_farmers': 'एकूण शेतकरी',
      'total_crops': 'एकूण पिके',
      'crop_insights': 'पिक अंतर्दृष्टी',
      'location_insights': 'स्थान अंतर्दृष्टी',
      'export_data': 'डेटा निर्यात करा',
      'generate_report': 'अहवाल तयार करा',

      // AI Insights
      'ai_insights': 'एआय अंतर्दृष्टी',
      'crop_age': 'पिकाचे वय',
      'growth_stage': 'वाढीचा टप्पा',
      'recommendations': 'शिफारशी',
      'days_old': 'दिवस जुने',
      'days_to_harvest': 'कापणीला दिवस',

      // Messages
      'data_saved_successfully': 'डेटा यशस्वीरित्या जतन केला',
      'data_updated_successfully': 'डेटा यशस्वीरित्या अपडेट केला',
      'verification_completed': 'सत्यापन पूर्ण झाले',
      'please_fill_all_fields': 'कृपया सर्व आवश्यक फील्ड भरा',
      'invalid_aadhaar': 'अवैध आधार क्रमांक (१२ अंक असणे आवश्यक आहे)',
      'invalid_pincode': 'अवैध पिन कोड (६ अंक असणे आवश्यक आहे)',
      'invalid_phone': 'अवैध फोन क्रमांक (१० अंक असणे आवश्यक आहे)',
      'location_permission_required': 'स्थान परवानगी आवश्यक आहे',
      'image_upload_failed': 'प्रतिमा अपलोड अयशस्वी',
      'no_data_found': 'कोणताही डेटा सापडला नाही',
      'search_farmers_placeholder': 'नाव किंवा आयडीने शोधा...',
      'filter_by_location': 'स्थानानुसार फिल्टर करा',

      // Status
      'pending': 'प्रलंबित',
      'verified': 'सत्यापित',
      'rejected': 'नाकारले',

      // Growth Stages
      'germination': 'अंकुरण',
      'vegetative': 'पर्णवृद्धी',
      'flowering': 'फुलोरा',
      'fruiting': 'फलन',
      'harvesting': 'कापणी',
      'mature': 'प्रौढ',

      // Common
      'loading': 'लोड होत आहे...',
      'error': 'त्रुटी',
      'success': 'यश',
      'warning': 'चेतावणी',
      'info': 'माहिती',
      'confirm': 'पुष्टी करा',
      'delete': 'हटवा',
      'edit': 'संपादन करा',
      'view': 'पहा',
      'back': 'मागे',
      'next': 'पुढे',
      'previous': 'मागील',
      'close': 'बंद करा',
      'ok': 'ठीक आहे',
      'yes': 'होय',
      'no': 'नाही',

      // Additional keys for dashboard screens
      'welcome': 'स्वागत',
      'home': 'मुख्यपृष्ठ',
      'location': 'स्थान',
      'quick_actions': 'त्वरित कृती',
      'recent_crops': 'अलीकडील पिके',
      'no_crops_found': 'कोणतीही पिके सापडली नाहीत',
      'no_crops_found_filter':
          'आपल्या फिल्टरशी जुळणारी कोणतीही पिके सापडली नाहीत.',
      'no_crops_for_insights': 'अंतर्दृष्टीसाठी कोणतीही पिके उपलब्ध नाहीत',
      'add_first_crop': 'आपले पहिले पिक जोडा',
      'error_loading_crops': 'पिके लोड करण्यात त्रुटी',
      'edit_profile': 'प्रोफाइल संपादन करा',
      'add_crop': 'पिक जोडा',
      'language': 'भाषा',
      'notifications': 'सूचना',
      'help_support': 'मदत आणि समर्थन',
      'about': 'बद्दल',

      // Registration
      'registration': 'नोंदणी',
      'personal_information': 'वैयक्तिक माहिती',
      'address_information': 'पत्ता माहिती',
      'full_name': 'पूर्ण नाव',
      'name_required': 'नाव आवश्यक आहे',
      'phone_required': 'फोन क्रमांक आवश्यक आहे',
      'aadhaar_required': 'आधार क्रमांक आवश्यक आहे',
      'village_required': 'गाव आवश्यक आहे',
      'taluka_required': 'तालुका आवश्यक आहे',
      'district_required': 'जिल्हा आवश्यक आहे',
      'pincode_required': 'पिन कोड आवश्यक आहे',
      'register': 'नोंदणी करा',
      'already_have_account': 'आधीपासून खाते आहे?',

      // New key for search farmer
      'search_farmer': 'शेतकरी शोधा',
      'search_crops': 'पिके शोधा',
      'view_reports': 'अहवाल पहा',
    },
  };

  static String getString(String key, String languageCode) {
    return translations[languageCode]?[key] ?? translations['en']![key] ?? key;
  }
}
