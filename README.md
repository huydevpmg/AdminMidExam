# **Flutter Admin Application**

This is a **Flutter-based admin application** that integrates with **Firebase** for authentication, storage, and real-time data management. The app allows administrators to **manage products**, including adding, editing, and deleting product information.

## **Features**

### **🔥 Firebase Integration**
- **Authentication**: Supports Email/Password login and Google Sign-In.
- **Firestore**: Real-time database for managing product information.
- **Firebase Storage**: Upload and manage product images securely.

### **🛒 Product Management**
- Add, edit, and delete products.
- Upload and display product images.
- Modern and user-friendly UI for product management.

### **🔒 Secure Configuration**
- Firebase configuration is managed using environment variables (`.env` file).

## **Prerequisites**

Before running the application, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A **Firebase project** configured with:
  - Firestore Database
  - Firebase Authentication
  - Firebase Storage

## **Setup Instructions**

### **1️⃣ Clone the Repository**
```bash
git clone <repository-url>
cd admin
```

### **2️⃣ Install Dependencies**
Run the following command to install the required dependencies:

```bash
flutter pub get
```

### **3️⃣ Configure Firebase**
- Download the **`google-services.json`** file from your Firebase project and place it in:
  ```
  android/app/
  ```
- For iOS, download the **`GoogleService-Info.plist`** file and place it in:
  ```
  ios/Runner/
  ```

### **4️⃣ Set Up Environment Variables**
Create a `.env` file in the root of the project and add your Firebase configuration:

```
# Firebase Web Configuration
WEB_API_KEY=your-web-api-key
WEB_APP_ID=your-web-app-id
WEB_MESSAGING_SENDER_ID=your-web-messaging-sender-id
WEB_PROJECT_ID=your-web-project-id
WEB_AUTH_DOMAIN=your-web-auth-domain
WEB_STORAGE_BUCKET=your-web-storage-bucket

# Firebase Android Configuration
ANDROID_API_KEY=your-android-api-key
ANDROID_APP_ID=your-android-app-id
ANDROID_MESSAGING_SENDER_ID=your-android-messaging-sender-id
ANDROID_PROJECT_ID=your-android-project-id
ANDROID_STORAGE_BUCKET=your-android-storage-bucket
```

## **📂 Folder Structure**
```
lib/
├── firebase_options.dart       # Firebase configuration using environment variables
├── main.dart                   # Entry point of the application
├── pages/
│   ├── auth_screen.dart        # Login and authentication screen
│   ├── product_screen.dart     # Product management screen
├── services/
│   ├── image_service.dart      # Service for image picking and uploading
│   ├── product_service.dart    # Service for CRUD product
│   ├── image_service.dart      # Service for image
├── widgets/
│   ├── button.dart             # Custom button widget
│   ├── textfield.dart          # Custom text field widget
```

---

This version enhances readability, improves organization, and ensures consistency. Let me know if you need further refinements! 🚀
