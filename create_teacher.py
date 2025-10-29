import requests
import json
import sys
from faker import Faker

# --- API SERVER DETAILS ---
SERVER_IP = "http://129.80.85.203:8080"
# --------------------------

# --- DATABASE CONNECTION DETAILS (for fetching roles/subjects/departments) ---
# These are still needed to fetch existing data for user selection
DB_HOST = "129.80.85.203"
DB_PORT = 5432
DB_NAME = "swadiq"
DB_USER = "imaad"
DB_PASSWORD = "Ertdfgxc"
# ---------------------------------------------------------------------------

def get_roles_from_db(conn):
    """Fetches all roles from the database."""
    roles = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM roles ORDER BY name")
        roles = cur.fetchall()
        cur.close()
    except psycopg2.Error as e:
        print(f"Database error while fetching roles: {e}", file=sys.stderr)
    return roles

def get_departments_from_db(conn):
    """Fetches all departments from the database."""
    departments = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM departments WHERE is_active = true ORDER BY name")
        departments = cur.fetchall()
        cur.close()
    except psycopg2.Error as e:
        print(f"Database error while fetching departments: {e}", file=sys.stderr)
    return departments

def get_subjects_by_department_from_db(conn, department_id):
    """Fetches subjects for a specific department from the database."""
    subjects = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM subjects WHERE department_id = %s AND is_active = true ORDER BY name", (department_id,))
        subjects = cur.fetchall()
        cur.close()
    except psycopg2.Error as e:
        print(f"Database error while fetching subjects for department {department_id}: {e}", file=sys.stderr)
    return subjects

def create_teacher_via_api(teacher_data):
    """
    Creates a new teacher by sending a POST request to the Go Fiber API.
    """
    create_teacher_url = f"{SERVER_IP}/api/teachers"
    
    headers = {
        "Content-Type": "application/json",
    }
    
    try:
        response = requests.post(create_teacher_url, headers=headers, data=json.dumps(teacher_data))
        response.raise_for_status()  # Raise an exception for bad status codes
        
        print(f"Teacher created successfully via API!")
        print("Response:", response.json())
        
    except requests.exceptions.RequestException as e:
        print(f"An error occurred while creating the teacher via API: {e}", file=sys.stderr)
        if hasattr(e, 'response') and e.response is not None:
            print("Response body:", e.response.text, file=sys.stderr)

if __name__ == "__main__":
    db_conn = None
    try:
        # Establish database connection to fetch roles, departments, subjects
        import psycopg2 # Import here to avoid circular dependency if not needed
        db_conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT
        )
        print("Database connection for data fetching successful.")

        roles = get_roles_from_db(db_conn)
        if not roles:
            print("No roles found. Please ensure roles are populated.")
            sys.exit(1)

        all_departments = get_departments_from_db(db_conn)
        if not all_departments:
            print("No departments found. Please create departments first.")
            sys.exit(1)

        try:
            num_teachers_str = input("Enter the number of teachers to create: ")
            num_teachers = int(num_teachers_str)
            if num_teachers <= 0:
                print("Please enter a positive number.")
                sys.exit(1)
        except ValueError:
            print("Invalid input. Please enter a number.")
            sys.exit(1)

        fake = Faker()

        for i in range(num_teachers):
            print(f"\n--- Creating Teacher {i+1} of {num_teachers} ---")
            
            # Select Role
            print("Please select a role for this teacher:")
            for idx, role in enumerate(roles):
                print(f"  {idx + 1}: {role[1]}")
            while True:
                try:
                    role_choice_str = input(f"Enter role number (1-{len(roles)}): ")
                    role_choice = int(role_choice_str) - 1
                    if 0 <= role_choice < len(roles):
                        selected_role_name = roles[role_choice][1] # Get role name
                        break
                    else:
                        print("Invalid number. Please try again.")
                except ValueError:
                    print("Invalid input. Please enter a number.")

            # Select Department
            selected_department_id = None
            while True:
                assign_dept_choice = input("Assign this teacher to a department? (yes/no): ").lower()
                if assign_dept_choice in ['yes', 'no']:
                    break
                else:
                    print("Invalid input. Please enter 'yes' or 'no'.")
            
            if assign_dept_choice == 'yes':
                print("\nPlease select a department:")
                for idx, dept in enumerate(all_departments):
                    print(f"  {idx + 1}: {dept[1]}")
                while True:
                    try:
                        dept_choice_str = input(f"Enter department number (1-{len(all_departments)}): ")
                        dept_choice = int(dept_choice_str) - 1
                        if 0 <= dept_choice < len(all_departments):
                            selected_department_id = all_departments[dept_choice][0]
                            break
                        else:
                            print("Invalid number. Please try again.")
                    except ValueError:
                        print("Invalid input. Please enter a number.")

            # Select Subjects
            selected_subject_ids = []
            while True:
                assign_subjects_choice = input("Assign subjects to this teacher? (yes/no): ").lower()
                if assign_subjects_choice in ['yes', 'no']:
                    break
                else:
                    print("Invalid input. Please enter 'yes' or 'no'.")
            
            if assign_subjects_choice == 'yes':
                # Select Departments for subject assignment
                print("\nPlease select department(s) for subject assignment (comma-separated, e.g., 1,3):")
                for idx, dept in enumerate(all_departments):
                    print(f"  {idx + 1}: {dept[1]}")
                
                selected_dept_indices = []
                while True:
                    try:
                        dept_choices_str = input(f"Enter department number(s) (1-{len(all_departments)}): ")
                        selected_dept_indices = [int(i.strip()) - 1 for i in dept_choices_str.split(',')]
                        if all(0 <= i < len(all_departments) for i in selected_dept_indices):
                            break
                        else:
                            print("Invalid number in selection. Please try again.")
                    except ValueError:
                        print("Invalid input. Please enter numbers separated by commas.")
                
                selected_departments_for_subjects = [all_departments[i] for i in selected_dept_indices]

                # Select Subjects for each chosen Department
                for dept_id, dept_name in selected_departments_for_subjects:
                    subjects_in_dept = get_subjects_by_department_from_db(db_conn, dept_id)
                    if not subjects_in_dept:
                        print(f"No active subjects found in {dept_name}.")
                        continue
                    
                    print(f"\n--- Select subjects for {dept_name} ---")
                    for idx, sub in enumerate(subjects_in_dept):
                        print(f"  {idx + 1}: {sub[1]}")
                    
                    while True:
                        try:
                            sub_choices_str = input(f"Enter subject number(s) for {dept_name} (comma-separated, e.g., 1,2): ")
                            sub_indices = [int(i.strip()) - 1 for i in sub_choices_str.split(',')]
                            if all(0 <= i < len(subjects_in_dept) for i in sub_indices):
                                selected_subject_ids.extend([subjects_in_dept[i][0] for i in sub_indices])
                                break
                            else:
                                print("Invalid number in selection. Please try again.")
                        except ValueError:
                            print("Invalid input. Please enter numbers separated by commas.")
            
            teacher_data = {
                'first_name': fake.first_name(),
                'last_name': fake.last_name(),
                'email': fake.unique.email(),
                'password': 'password123',  # Default password
                'role': selected_role_name,
                'department_id': selected_department_id,
                'subject_ids': selected_subject_ids
            }

            create_teacher_via_api(teacher_data)

    except psycopg2.Error as e:
        print(f"Database connection failed: {e}", file=sys.stderr)

    finally:
        if db_conn:
            db_conn.close()
            print("\nDatabase connection for data fetching closed.")