import 'package:gsheets/gsheets.dart';
import 'package:pelviease_website/backend/models/contact_form.dart';

class GoogleSheetsService {
  static const String _credentials = '''
{
  "type": "service_account",
  "project_id": "YOUR_PROJECT_ID",
  "private_key_id": "YOUR_PRIVATE_KEY_ID",
  "private_key": "YOUR_PRIVATE_KEY",
  "client_email": "YOUR_CLIENT_EMAIL",
  "client_id": "YOUR_CLIENT_ID",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "YOUR_CLIENT_X509_CERT_URL"
}
''';

  static const String _spreadsheetId = 'YOUR_SPREADSHEET_ID';
  static const String _worksheetTitle = 'Contact_Forms';

  late GSheets _gsheets;
  late Spreadsheet _spreadsheet;
  late Worksheet _worksheet;

  GoogleSheetsService() {
    _gsheets = GSheets(_credentials);
  }

  Future<void> _init() async {
    try {
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);

      // Try to get existing worksheet or create new one
      _worksheet = _spreadsheet.worksheetByTitle(_worksheetTitle) ??
          await _spreadsheet.addWorksheet(_worksheetTitle);

      // Check if headers exist, if not add them
      final headers = await _worksheet.values.row(1);
      if (headers.isEmpty) {
        await _worksheet.values.insertRow(1, ContactForm.getHeaders());
      }
    } catch (e) {
      print('Error initializing Google Sheets: $e');
      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      await _init();

      final allEmails =
          await _worksheet.values.column(2); // Email is in column 2

      // Skip header row and check if email exists
      for (int i = 1; i < allEmails.length; i++) {
        if (allEmails[i].toLowerCase().trim() == email.toLowerCase().trim()) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking email existence: $e');
      return false; // Return false if there's an error to allow submission
    }
  }

  Future<bool> submitContactForm(ContactForm contactForm) async {
    try {
      await _init();

      // Add the new row
      final success =
          await _worksheet.values.appendRow(contactForm.toRowData());

      return success;
    } catch (e) {
      print('Error submitting contact form: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllContactForms() async {
    try {
      await _init();

      final allData = await _worksheet.values.allRows();

      if (allData.isEmpty || allData.length <= 1) {
        return [];
      }

      final headers = allData[0];
      final rows = allData.sublist(1);

      return rows.map((row) {
        Map<String, dynamic> contactData = {};
        for (int i = 0; i < headers.length && i < row.length; i++) {
          contactData[headers[i]] = row[i];
        }
        return contactData;
      }).toList();
    } catch (e) {
      print('Error getting contact forms: $e');
      return [];
    }
  }

  // Method to update credentials (call this when you provide your credentials)
  static void updateCredentials({
    required String projectId,
    required String privateKeyId,
    required String privateKey,
    required String clientEmail,
    required String clientId,
    required String clientX509CertUrl,
    required String spreadsheetId,
  }) {
    // This would typically be handled through environment variables or secure storage
    // For now, you'll need to manually replace the values in the _credentials string
    print('Please replace the credential values in google_sheets_service.dart');
    print('Project ID: $projectId');
    print('Spreadsheet ID: $spreadsheetId');
  }
}
