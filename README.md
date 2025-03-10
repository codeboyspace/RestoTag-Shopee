# E-Commerce App with Admin Panel

## 🛠 Tech Stack
- **Frontend**: Flutter
- **Backend**: Django (Django REST Framework)
- **Database**: SQLite (can be extended to PostgreSQL/MySQL)
- **Authentication**: Firebase Authentication
- **Email Service**: Django Email Backend
- **State Management**: Provider (in Flutter)

---
## 🚀 Features
### 🏪 **E-Commerce App (User-Side)**
- Home screen with a list of products.
- Product details screen with images and descriptions.
- Shopping cart functionality.
- Firebase Authentication (Sign Up & Login).
- Real-time cart storage using Firebase Realtime Database.

### 🎛 **Admin Panel (Django)**
- Seller invite system (only invited sellers can register).
- API to send invitation emails with unique tokens.
- Seller management via Django Admin.
- Secure token-based seller registration.

---
## 📂 Project Structure

```
📦 RestoTag
 ├── 📂 backend (Django Project)
 │   ├── 📂 sellers
 │   │   ├── models.py
 │   │   ├── views.py
 │   │   ├── serializers.py
 │   │   ├── admin.py
 │   │   ├── urls.py
 │   ├── 📂 products
 │   ├── 📂 cart
 │   ├── 📄 settings.py
 │   ├── 📄 urls.py
 │   ├── 📄 wsgi.py
 │   ├── 📄 manage.py
 │
 ├── 📂 frontend (Flutter App)
 │   ├── 📂 lib
 │   │   ├── 📂 screens
 │   │   │   ├── home_screen.dart
 │   │   │   ├── product_screen.dart
 │   │   │   ├── cart_screen.dart
 │   │   ├── 📂 providers
 │   │   ├── 📂 services
 │   │   ├── main.dart
 │
 ├── 📄 README.md
 ├── 📄 requirements.txt
 ├── 📄 pubspec.yaml
```

---
## 🛠 Installation & Setup
### **Backend Setup (Django)**
1. Clone the repository:
   ```sh
   git clone https://github.com/codeboyspace/RestoTag-Shopee.git
   cd RestoTag.git/backend
   ```
2. Create a virtual environment and install dependencies:
   ```sh
   python -m venv venv
   source venv/bin/activate  # (Windows: venv\Scripts\activate)
   pip install -r requirements.txt
   ```
3. Apply migrations & create superuser:
   ```sh
   python manage.py migrate
   python manage.py createsuperuser
   ```
4. Run the server:
   ```sh
   python manage.py runserver
   ```

### **Frontend Setup (Flutter)**
1. Navigate to the Flutter app folder:
   ```sh
   cd ../frontend
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the Flutter app:
   ```sh
   flutter run
   ```

---
## 🔑 Environment Variables
Create a `.env` file in the backend folder and add:
```
SECRET_KEY=your_secret_key
EMAIL_HOST_USER=your_email@gmail.com
EMAIL_HOST_PASSWORD=your_email_password
FRONTEND_URL=http://localhost:3000  # Update with your frontend URL
```

---
## 📌 API Endpoints
### **Seller Invitation API**
- `POST /api/sellers/send-invite/` - Send invite to seller (Admin only)
- `POST /api/sellers/register/` - Register seller using invite token
- `GET /api/products/` - Get all products
- `POST /api/cart/` - Add product to cart
- `GET /api/cart/` - Get cart items


📧 Email: surya.mail.personal@gmail.com
(https://github.com/codeboyspace)

