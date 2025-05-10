# API Documentation

This document provides a comprehensive overview of all the available API endpoints, their functionality, and examples of how to use them.

---

## **Endpoints Overview**

### **Account Endpoints**
- `GET /api/accounts` - List all accounts.
- `GET /api/accounts/<int:account_id>` - Get a specific account by ID.
- `POST /api/accounts` - Create a new account.
- `DELETE /api/accounts/<int:account_id>` - Delete an account.
- `PATCH /api/accounts/<int:account_id>/status` - Update account status.
- `PATCH /api/accounts/<int:account_id>/type` - Update account type.
- `PATCH /api/accounts/<int:account_id>/password` - Update account password.
- `PATCH /api/accounts/<int:account_id>/phone` - Update account phone number.
- `PATCH /api/accounts/<int:account_id>/email` - Update account email.
- `PATCH /api/accounts/<int:account_id>/username` - Update account username.
- `PATCH /api/accounts/<int:account_id>/activate` - Activate an account.
- `PATCH /api/accounts/<int:account_id>/suspend` - Suspend an account.
- `PATCH /api/accounts/<int:account_id>/unsuspend` - Unsuspend an account.
- `PATCH /api/accounts/<int:account_id>/deactivate` - Deactivate an account.
- `PATCH /api/accounts/<int:account_id>/delete` - Soft delete an account.
- `PATCH /api/accounts/<int:account_id>/restore` - Restore a deleted account.
- `PUT /api/accounts/<int:account_id>` - Fully update an account.

---

### **Location Endpoints**
- `GET /api/locations` - List all locations.
- `GET /api/locations/<int:id_location>` - Get a specific location by ID.
- `POST /api/locations` - Create a new location.
- `PUT /api/locations/<int:id_location>` - Update a location.
- `DELETE /api/locations/<int:id_location>` - Delete a location.

---

### **Hospital Endpoints**
- `GET /api/hospitals` - List all hospitals.
- `GET /api/hospitals/<int:id_hospital>` - Get a specific hospital by ID.
- `POST /api/hospitals` - Create a new hospital.
- `PUT /api/hospitals/<int:id_hospital>` - Update a hospital.
- `DELETE /api/hospitals/<int:id_hospital>` - Delete a hospital.

---

### **User Endpoints**
#### **Patients**
- `GET /api/patients` - List all patients.
- `GET /api/patients/<int:id_profile>` - Get a specific patient by ID.
- `POST /api/patients` - Create a new patient.
- `PUT /api/patients/<int:id_profile>` - Update a patient.
- `DELETE /api/patients/<int:id_profile>` - Delete a patient.

#### **Doctors**
- `GET /api/doctors` - List all doctors.
- `GET /api/doctors/<int:id_profile>` - Get a specific doctor by ID.
- `POST /api/doctors` - Create a new doctor.
- `PUT /api/doctors/<int:id_profile>` - Update a doctor.
- `DELETE /api/doctors/<int:id_profile>` - Delete a doctor.

---

### **Community Endpoints**
#### **Posts**
- `GET /api/community_posts` - List all community posts.
- `GET /api/community_posts/<int:id_post>` - Get a specific community post by ID.
- `POST /api/community_posts` - Create a new community post.
- `PUT /api/community_posts/<int:id_post>` - Update a community post.
- `DELETE /api/community_posts/<int:id_post>` - Delete a community post.

#### **Comments**
- `POST /api/community_posts/<int:id_post>/comments` - Add a comment to a post.
- `GET /api/community_posts/<int:id_post>/comments` - List all comments for a post.
- `PUT /api/community_posts/<int:id_post>/comments/<int:id_comment>` - Update a comment.
- `DELETE /api/community_posts/<int:id_post>/comments/<int:id_comment>` - Delete a comment.

#### **Reactions**
- `POST /api/community_posts/<int:id_post>/reactions` - Add a reaction to a post.
- `GET /api/community_posts/<int:id_post>/reactions` - List all reactions for a post.
- `DELETE /api/community_posts/<int:id_post>/reactions/<int:id_account>` - Remove a reaction from a post.

---

### **Perspection Endpoints**
- `GET /api/perspections` - List all perspections.
- `POST /api/perspections` - Create a new perspection.
- `PUT /api/perspections/<int:id_perspection>` - Update a perspection.
- `DELETE /api/perspections/<int:id_perspection>` - Delete a perspection.

---

### **Plan and Challenge Endpoints**
#### **Diet Plans**
- `GET /api/diet_plans` - List all diet plans.
- `POST /api/diet_plans` - Create a new diet plan.
- `PUT /api/diet_plans/<int:id_plan>` - Update a diet plan.
- `DELETE /api/diet_plans/<int:id_plan>` - Delete a diet plan.

#### **Challenges**
- `GET /api/challenges` - List all challenges.
- `POST /api/challenges` - Create a new challenge.
- `PUT /api/challenges/<int:id_challenge>` - Update a challenge.
- `DELETE /api/challenges/<int:id_challenge>` - Delete a challenge.

---

### **Activity Endpoints**
- `GET /api/activities` - List all activities.
- `POST /api/activities` - Create a new activity.
- `PUT /api/activities/<int:id_activity>` - Update an activity.
- `DELETE /api/activities/<int:id_activity>` - Delete an activity.

---

### **Meal Endpoints**
- `GET /api/meals` - List all meals.
- `POST /api/meals` - Create a new meal.
- `PUT /api/meals/<int:id_meal>` - Update a meal.
- `DELETE /api/meals/<int:id_meal>` - Delete a meal.

---

### **Blood Sugar Endpoints**
- `GET /api/blood_sugar_records` - List all blood sugar records.
- `POST /api/blood_sugar_records` - Create a new blood sugar record.
- `PUT /api/blood_sugar_records/<int:id_record>` - Update a blood sugar record.
- `DELETE /api/blood_sugar_records/<int:id_record>` - Delete a blood sugar record.

---

### **Notification Endpoints**
- `GET /api/notifications` - List all notifications.
- `POST /api/notifications` - Create a new notification.
- `PUT /api/notifications/<int:id_notification>` - Update a notification.
- `DELETE /api/notifications/<int:id_notification>` - Delete a notification.

---

### **Article Endpoints**
- `GET /api/articles` - List all articles.
- `POST /api/articles` - Create a new article.
- `PUT /api/articles/<int:id_article>` - Update an article.
- `DELETE /api/articles/<int:id_article>` - Delete an article.

---

### **Appointment Endpoints**
- `GET /api/appointments` - List all appointments.
- `POST /api/appointments` - Create a new appointment.
- `PUT /api/appointments/<int:id_appointement>` - Update an appointment.
- `DELETE /api/appointments/<int:id_appointement>` - Delete an appointment.

---

### **Contact Endpoints**
- `GET /api/contacts` - List all contacts.
- `POST /api/contacts` - Create a new contact.
- `PUT /api/contacts/<int:id_contact>` - Update a contact.
- `DELETE /api/contacts/<int:id_contact>` - Delete a contact.

---

### **Additional Info Endpoints**
- `GET /api/additionnal-infos` - List all additional info.
- `POST /api/additionnal-infos` - Create additional info.
- `PUT /api/additionnal-infos/<int:id>` - Update additional info.
- `DELETE /api/additionnal-infos/<int:id>` - Delete additional info.

---

## **Examples**

### **1. Account Endpoints**

#### **1.1 List All Accounts**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/accounts
```

**Response**:
```json
[
    {
        "account_id": 1,
        "user_name": "john_doe",
        "email": "john.doe@example.com",
        "phone_number": "1234567890",
        "account_type": "Doctor",
        "status": "Active"
    },
    {
        "account_id": 2,
        "user_name": "jane_doe",
        "email": "jane.doe@example.com",
        "phone_number": "0987654321",
        "account_type": "Patient",
        "status": "Inactive"
    }
]
```

---

#### **1.2 Get a Specific Account**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/accounts/1
```

**Response**:
```json
{
    "account_id": 1,
    "user_name": "john_doe",
    "email": "john.doe@example.com",
    "phone_number": "1234567890",
    "account_type": "Doctor",
    "status": "Active"
}
```

---

#### **1.3 Create a New Account**
**Request**:
```bash
curl -X POST http://127.0.0.1:5000/api/accounts \
-H "Content-Type: application/json" \
-d '{
    "user_name": "john_doe",
    "email": "john.doe@example.com",
    "phone_number": "1234567890",
    "password": "securepassword",
    "account_type": "Doctor",
    "status": "Active"
}'
```

**Response**:
```json
{
    "message": "Account added",
    "id_profile": 1
}
```

---

#### **1.4 Delete an Account**
**Request**:
```bash
curl -X DELETE http://127.0.0.1:5000/api/accounts/1
```

**Response**:
```json
{
    "message": "Account deleted"
}
```

---

#### **1.5 Update Account Status**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/status \
-H "Content-Type: application/json" \
-d '{
    "status": "Inactive"
}'
```

**Response**:
```json
{
    "message": "Account status updated"
}
```

---

#### **1.6 Update Account Type**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/type \
-H "Content-Type: application/json" \
-d '{
    "account_type": "Patient"
}'
```

**Response**:
```json
{
    "message": "Account type updated"
}
```

---

#### **1.7 Update Account Password**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/password \
-H "Content-Type: application/json" \
-d '{
    "password": "newpassword123"
}'
```

**Response**:
```json
{
    "message": "Account password updated"
}
```

---

#### **1.8 Update Account Phone Number**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/phone \
-H "Content-Type: application/json" \
-d '{
    "phone_number": "9876543210"
}'
```

**Response**:
```json
{
    "message": "Account phone number updated"
}
```

---

#### **1.9 Update Account Email**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/email \
-H "Content-Type: application/json" \
-d '{
    "email": "new.email@example.com"
}'
```

**Response**:
```json
{
    "message": "Account email updated"
}
```

---

#### **1.10 Update Account Username**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/username \
-H "Content-Type: application/json" \
-d '{
    "user_name": "new_username"
}'
```

**Response**:
```json
{
    "message": "Account username updated"
}
```

---

#### **1.11 Activate an Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/activate
```

**Response**:
```json
{
    "message": "Account activated"
}
```

---

#### **1.12 Suspend an Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/suspend
```

**Response**:
```json
{
    "message": "Account suspended"
}
```

---

#### **1.13 Unsuspend an Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/unsuspend
```

**Response**:
```json
{
    "message": "Account unsuspended"
}
```

---

#### **1.14 Deactivate an Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/deactivate
```

**Response**:
```json
{
    "message": "Account deactivated"
}
```

---

#### **1.15 Soft Delete an Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/delete
```

**Response**:
```json
{
    "message": "Account marked as deleted"
}
```

---

#### **1.16 Restore a Deleted Account**
**Request**:
```bash
curl -X PATCH http://127.0.0.1:5000/api/accounts/1/restore
```

**Response**:
```json
{
    "message": "Account restored"
}
```

---

#### **1.17 Fully Update an Account**
**Request**:
```bash
curl -X PUT http://127.0.0.1:5000/api/accounts/1 \
-H "Content-Type: application/json" \
-d '{
    "user_name": "updated_username",
    "email": "updated.email@example.com",
    "phone_number": "1234567890",
    "password": "updatedpassword",
    "account_type": "Doctor",
    "status": "Active"
}'
```

**Response**:
```json
{
    "message": "Account fully updated"
}
```

---

### **2. Location Endpoints**

#### **2.1 List All Locations**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/locations
```

**Response**:
```json
[
    {
        "id_location": 1,
        "address": "123 Main St",
        "latitude": 40.7128,
        "longitude": -74.0060
    },
    {
        "id_location": 2,
        "address": "456 Elm St",
        "latitude": 34.0522,
        "longitude": -118.2437
    }
]
```

---

#### **2.2 Get a Specific Location**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/locations/1
```

**Response**:
```json
{
    "id_location": 1,
    "address": "123 Main St",
    "latitude": 40.7128,
    "longitude": -74.0060
}
```

---

#### **2.3 Create a New Location**
**Request**:
```bash
curl -X POST http://127.0.0.1:5000/api/locations \
-H "Content-Type: application/json" \
-d '{
    "address": "789 Pine St",
    "latitude": 37.7749,
    "longitude": -122.4194
}'
```

**Response**:
```json
{
    "message": "Location added",
    "id_location": 3
}
```

---

#### **2.4 Update a Location**
**Request**:
```bash
curl -X PUT http://127.0.0.1:5000/api/locations/1 \
-H "Content-Type: application/json" \
-d '{
    "address": "Updated Address",
    "latitude": 40.7306,
    "longitude": -73.9352
}'
```

**Response**:
```json
{
    "message": "Location updated"
}
```

---

#### **2.5 Delete a Location**
**Request**:
```bash
curl -X DELETE http://127.0.0.1:5000/api/locations/1
```

**Response**:
```json
{
    "message": "Location deleted"
}
```

---

### **3. Hospital Endpoints**

#### **3.1 List All Hospitals**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/hospitals
```

**Response**:
```json
[
    {
        "id_hospital": 1,
        "name_hospital": "General Hospital",
        "postal_code": "12345",
        "street": "123 Main St",
        "id_location": 1
    }
]
```

---

#### **3.2 Get a Specific Hospital**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/hospitals/1
```

**Response**:
```json
{
    "id_hospital": 1,
    "name_hospital": "General Hospital",
    "postal_code": "12345",
    "street": "123 Main St",
    "id_location": 1
}
```

---

#### **3.3 Create a New Hospital**
**Request**:
```bash
curl -X POST http://127.0.0.1:5000/api/hospitals \
-H "Content-Type: application/json" \
-d '{
    "name_hospital": "New Hospital",
    "postal_code": "67890",
    "street": "456 Elm St",
    "id_location": 2
}'
```

**Response**:
```json
{
    "message": "Hospital added",
    "id_hospital": 2
}
```

---

#### **3.4 Update a Hospital**
**Request**:
```bash
curl -X PUT http://127.0.0.1:5000/api/hospitals/1 \
-H "Content-Type: application/json" \
-d '{
    "name_hospital": "Updated Hospital",
    "postal_code": "54321",
    "street": "Updated Street",
    "id_location": 3
}'
```

**Response**:
```json
{
    "message": "Hospital updated"
}
```

---

#### **3.5 Delete a Hospital**
**Request**:
```bash
curl -X DELETE http://127.0.0.1:5000/api/hospitals/1
```

**Response**:
```json
{
    "message": "Hospital deleted"
}
```

---

### **4. User Endpoints**

#### **4.1 List All Patients**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/patients
```

**Response**:
```json
[
    {
        "id_profile": 1,
        "first_name": "John",
        "last_name": "Doe",
        "blood_type": "A+",
        "date_birth": "1990-01-01",
        "weight": 70.5,
        "height": 175.0,
        "diabete_type": "Type 1"
    }
]
```

---

#### **4.2 Get a Specific Patient**
**Request**:
```bash
curl -X GET http://127.0.0.1:5000/api/patients/1
```

**Response**:
```json
{
    "id_profile": 1,
    "first_name": "John",
    "last_name": "Doe",
    "blood_type": "A+",
    "date_birth": "1990-01-01",
    "weight": 70.5,
    "height": 175.0,
    "diabete_type": "Type 1"
}
```

---

#### **4.3 Create a New Patient**
**Request**:
```bash
curl -X POST http://127.0.0.1:5000/api/patients \
-H "Content-Type: application/json" \
-d '{
    "first_name": "Jane",
    "last_name": "Doe",
    "blood_type": "O+",
    "date_birth": "1995-05-15",
    "weight": 65.0,
    "height": 165.0,
    "diabete_type": "Type 2"
}'
```

**Response**:
```json
{
    "message": "Patient added",
    "id_profile": 2
}
```

---
